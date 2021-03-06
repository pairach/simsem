

buildPT <- function(paramSet,constraint,aux=NULL) {

  object <- collapseExo(object, label = TRUE)
    constraint <- collapseExo(constraint, label = TRUE, value = NA)  ###################Have some zeros
    if (!isNullObject(object@LY)) {
        for (i in 1:ncol(object@LY)) {
            temp <- paste(colnames(object@LY)[i], "=~")
            something <- FALSE
            for (j in 1:nrow(object@LY)) {
                if (is.na(object@LY[j, i]) | object@LY[j, i] != 0 | !is.na(constraint@LY[j, i])) {
                  content <- paste(object@LY[j, i], "*", sep = "")
                  if (!is.na(constraint@LY[j, i])) 
                    content <- constraint@LY[j, i]
                  temp <- paste(temp, " ", content, rownames(object@LY)[j], sep = "")
                  something <- TRUE
                }
                if (something && j != nrow(object@LY) && (is.na(object@LY[j + 1, i]) | object@LY[j + 1, i] != 0)) 
                  temp <- paste(temp, "+")
            }
            if ((sum(is.na(object@LY[, i])) == 0) && (sum(object@LY[, i]) == 0)) 
                temp <- paste(temp, "0*", rownames(object@LY)[1], sep = "")
            if (!is.null(aux)) {
                noVar <- !(is.na(diag(object@TE)) | diag(object@TE) != 0)
                lab <- "0"
                if (sum(noVar) > 0) {
                  LYsingle <- extract(object@LY, which(noVar), i)
                  LYsingle <- is.na(LYsingle) | LYsingle != 0
                  if (sum(LYsingle) > 0) 
                    lab <- "NA"
                }
                temp <- paste(temp, paste(paste(" + ", lab, "*", aux, sep = ""), collapse = ""))
            }
            result <- paste(result, temp, "\n")
        }
    }
    if (!isNullObject(object@BE)) {
        for (i in 1:nrow(object@BE)) {
            temp <- NULL
            for (j in 1:ncol(object@BE)) {
                if (is.na(object@BE[i, j]) | object@BE[i, j] != 0 | !is.na(constraint@BE[i, j])) {
                  content <- paste(object@BE[i, j], "*", sep = "")
                  if (!is.na(constraint@BE[i, j])) 
                    content <- constraint@BE[i, j]
                  temp <- paste(temp, " ", content, colnames(object@BE)[j], sep = "")
                }
                if (!is.null(temp) && j != ncol(object@BE) && (is.na(object@BE[i, j + 1]) | object@BE[i, j + 1] != 0)) 
                  temp <- paste(temp, "+")
            }
            if (!is.null(temp)) {
                temp2 <- paste(rownames(object@BE)[i], "~")
                result <- paste(result, temp2, temp, "\n")
            }
        }
        if (isNullObject(object@LY) && !is.null(aux)) {
            set <- findRecursiveSet(object@BE)
            target <- colnames(object@BE)[set[[1]]]
            for (i in 1:length(aux)) {
                temp <- paste(aux[1], " ~ ", paste(paste("NA*", target), collapse = " + "), "\n", sep = "")
                result <- paste(result, temp)
            }
        }
    }
    if (!isNullObject(object@PS)) {
        var.code <- NULL
        for (i in 1:length(diag(object@PS))) {
            if (!is.na(object@PS[i, i]) | !is.na(constraint@PS[i, i])) {
                content <- paste(object@PS[i, i], "*", sep = "")
                if (!is.na(constraint@PS[i, i])) 
                  content <- constraint@PS[i, i]
                var.code <- paste(var.code, colnames(object@PS)[i], " ~~ ", content, colnames(object@PS)[i], " \n", sep = "")
            }
        }
        cov.code <- NULL
        if (nrow(object@PS) > 1) {
            for (i in 2:nrow(object@PS)) {
                for (j in 1:(i - 1)) {
                  if (is.na(object@PS[i, j]) | object@PS[i, j] != 0 | !is.na(constraint@PS[i, j])) {
                    content <- paste(object@PS[i, j], "*", sep = "")
                    if (!is.na(constraint@PS[i, j])) 
                      content <- constraint@PS[i, j]
                    if (isNullObject(object@BE)) {
                      cov.code <- paste(cov.code, rownames(object@PS)[i], " ~~ ", content, colnames(object@PS)[j], " \n", sep = "")
                    } else {
                      exo.set <- findRecursiveSet(object@BE)[[1]]
                      if (!(is.element(i, exo.set) & is.element(j, exo.set))) {
                        cov.code <- paste(cov.code, rownames(object@PS)[i], " ~~ ", content, colnames(object@PS)[j], " \n", sep = "")
                      }
                    }
                  } else {
                    content <- paste(object@PS[i, j], "*", sep = "")
                    if (isNullObject(object@BE)) {
                      cov.code <- paste(cov.code, rownames(object@PS)[i], " ~~ ", content, colnames(object@PS)[j], " \n", sep = "")
                    } else {
                      auxFac <- which(apply(object@BE, 1, function(x) all(!is.na(x) & (x == 0))) & apply(object@BE, 2, function(x) all(!is.na(x) & (x == 0))))
                      if (is.element(i, auxFac) | is.element(j, auxFac)) {
                        cov.code <- paste(cov.code, rownames(object@PS)[i], " ~~ 0*", colnames(object@PS)[j], " \n", sep = "")
                      }
                    }
                  }
                }
            }
        }
        result <- paste(result, var.code, cov.code)
        if (isNullObject(object@LY) && !is.null(aux)) {
            set <- findRecursiveSet(object@BE)
            target <- colnames(object@BE)[-set[[1]]]
            varCode <- paste(paste(aux, " ~~ NA*", aux, sep = ""), collapse = "\n")
            result <- paste(result, varCode, "\n")
            corCode <- paste(outer(aux, target, paste, sep = " ~~ NA*"), collapse = "\n")
            result <- paste(result, corCode, "\n")
        }
    }
    if (!isNullObject(object@TE)) {
        var.code <- NULL
        for (i in 1:length(diag(object@TE))) {
            if (!is.na(object@TE[i, i]) | !is.na(constraint@TE[i, i])) {
                content <- paste(object@TE[i, i], "*", sep = "")
                if (!is.na(constraint@TE[i, i])) 
                  content <- constraint@TE[i, i]
                var.code <- paste(var.code, colnames(object@TE)[i], " ~~ ", content, colnames(object@TE)[i], " \n", sep = "")
            }
        }
        cov.code <- NULL
        for (i in 2:nrow(object@TE)) {
            for (j in 1:(i - 1)) {
                if (is.na(object@TE[i, j]) | object@TE[i, j] != 0 | !is.na(constraint@TE[i, j])) {
                  content <- paste(object@TE[i, j], "*", sep = "")
                  if (!is.na(constraint@TE[i, j])) 
                    content <- constraint@TE[i, j]
                  cov.code <- paste(cov.code, rownames(object@TE)[i], " ~~ ", content, colnames(object@TE)[j], " \n", sep = "")
                }
            }
        }
        result <- paste(result, var.code, cov.code)
        if (!isNullObject(object@LY) && !is.null(aux)) {
            nonConstant <- is.na(diag(object@TE)) | diag(object@TE) != 0
            target <- colnames(object@TE)[nonConstant]
            varCode <- paste(paste(aux, " ~~ NA*", aux, sep = ""), collapse = "\n")
            result <- paste(result, varCode, "\n")
            corCode <- paste(outer(aux, target, paste, sep = " ~~ NA*"), collapse = "\n")
            result <- paste(result, corCode, "\n")
        }
    }
    if (!is.null(aux) && length(aux) > 1) {
        corCode <- outer(aux, aux, paste, sep = " ~~ NA*")
        diag(corCode) <- ""
        corCode <- corCode[lower.tri(corCode)]
        corCode <- paste(paste(corCode, collapse = "\n"), "\n")
        result <- paste(result, corCode)
    }
    if (!isNullObject(object@AL)) {
        mean.code <- NULL
        for (i in 1:length(object@AL)) {
            if (!(object@modelType == "Path" | object@modelType == "Path.exo") | !is.na(object@AL[i]) | !is.na(constraint@AL[i])) {
                content <- paste(object@AL[i], "*", sep = "")
                if (!is.na(constraint@AL[i])) 
                  content <- constraint@AL[i]
                mean.code <- paste(mean.code, names(object@AL)[i], " ~ ", content, "1 \n", sep = "")
            }
        }
        result <- paste(result, mean.code)
    }
    if (!isNullObject(object@TY)) {
        mean.code <- NULL
        for (i in 1:length(object@TY)) {
            content <- paste(object@TY[i], "*", sep = "")
            if (!is.na(constraint@TY[i])) 
                content <- constraint@TY[i]
            mean.code <- paste(mean.code, names(object@TY)[i], " ~ ", content, "1 \n", sep = "")
        }
        result <- paste(result, mean.code)
    }
    if (!is.null(aux)) {
        temp <- paste(paste(aux, " ~ NA*1 \n"), collapse = "")
        result <- paste(result, temp)
    }
    return(result)
}
