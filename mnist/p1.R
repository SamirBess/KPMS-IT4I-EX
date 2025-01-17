
#' svdmod
#' 
#' Computes SVD for each image label in training data
#' Returns SVDs truncated to either k components or percent variability
#' 
svdmod = function(data, labels, k = NULL, pct = NULL, plots = FALSE) {
  ## trains svd model for each label
  
  if(is.null(k) & is.null(pct)) 
    stop("svdmod: At least one of k and pct must be provided")
  
  ulabels = unique(labels)
  models = setNames(vector("list", length(ulabels)), ulabels)
  
  ## train on each label data
  for(label in ulabels) {
    labdat = unname(as.matrix(data[labels == label, ]))
    udv = La.svd(labdat)
    
    if(!is.null(k)) { # k components
      ik = 1:k
    } else { # pct variability
      cvar = cumsum(udv$d^2)
      ik = 1:(which(100*cvar/cvar[length(cvar)] >= pct))[1]
    }
    mod = list(d = udv$d[ik], u = udv$u[, ik], vt = udv$vt[ik, ], 
               k = length(ik), pct = 100*sum(udv$d[ik]^2)/sum(udv$d^2))
    models[[label]] = mod
  }
  if(plots) lapply(models, function(x) plot(1:length(x$d), cumsum(x$d^2)))
  models
}

#' predict_svdmod
#' 
#' Computes classification of new images in test data
#' 
predict_svdmod = function(test, models) {
  np = nrow(test)
  pred = rep(NA, np)
  mnames = names(models)
  mloss = matrix(NA, nrow = np, ncol = length(mnames))
  colnames(mloss) = mnames
  
  y = as.matrix(test)   ## removed loop and set y as matrix
  for(m in mnames) {
    vt = models[[m]]$vt
    yhat = y %*% t(vt) %*% vt  ## transpose of t(vt) %*% vt %*% y
    mloss[, m] = rowSums((y - yhat)^2)/ncol(y) ## rowSums instead of sum
  }
  pred = apply(mloss, 1, function(x) mnames[which.min(x)]) ## apply over rows
  pred
}

#' image_ggplot
#' 
#' Produces a facet plot of first few basis vectors as images
#' 

# Removed function image ggplot

#' model_report
#' 
#' reports a summary for each label model of basis vectors
#' optionally plots basis images
#' 
model_report = function(models, kplot = 0) {
  for(m in names(models)) {
    mk = min(kplot, models[[m]]$k)
    cat("Model", m, ": size ", models[[m]]$k, " var captured ", 
        models[[m]]$pct, " %\n", sep = "") 
    if(kplot) image_ggplot(models[[m]]$vt, 1:mk, paste("Digit", m))
  }
}

suppressMessages(library(pbdMPI))
suppressMessages(library(pbdIO))
suppressMessages(library(parallel))
#library(ggplot2)
source("../mnist/mnist_read.R")
source("../code/flexiblas_setup.r")

#blas_threads = as.numeric(commandArgs(TRUE)[2])
#fork_cores = as.numeric(commandArgs(TRUE)[3])
#setback("OPENBLAS")
#setthreads(blas_threads)

## Begin CV (This CV is with mclapply. Exercise 8 needs MPI parallelization.)
## set up cv parameters

nfolds = 10

# Assign number to the worker by his comm.rank
# I hope this is consistently numbered from 0 to number of ranks - 1
worker.number <- comm.rank() 

pars = seq(80.0  , 95, .2)
amount.of.work.for.one <- length(pars)/comm.size() 
# Code probably rely on comm.size from shell file which I will set
# comm.size() should divide 76 without zbytek
pars = pars[(worker.number*amount.of.work.for.one + 1):((worker.number + 1)*amount.of.work.for.one)]

comm.set.seed(seed = 609, diff = FALSE)
folds = sample( rep_len(1:nfolds, nrow(train)), nrow(train) ) ## random folds
cv = expand.grid(par = pars, fold = 1:nfolds)  ## all combinations

## function for parameter combination i
fold_err = function(i, cv, folds, train) {
  par = cv[i, "par"]
  fold = (folds == cv[i, "fold"])
  models = svdmod(train[!fold, ], train_lab[!fold], pct = par)
  predicts = predict_svdmod(train[fold, ], models)
  sum(predicts != train_lab[fold])
}

## apply fold_err() over parameter combinations
cv_err = mclapply(1:nrow(cv), fold_err, cv = cv, folds = folds, train = train,
                  mc.cores = 4)
print(cv_err)

## sum fold errors for each parameter value

#cv_err_par = tapply(unlist(cv_err), cv[, "par"], sum)

finalize()