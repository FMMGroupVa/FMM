###############################################################
# Internal function: to fit restricted FMM models: exact solution.
# An external grid for omega parameter is used for fitting process.
# Used by 'fitFMM_restr_omegaBeta'.
# Arguments:
#   vData: data to be fitted an FMM model.
#   nback: number of FMM components to be fitted.
#   betaRestrictions: betas' constraint vector.
#   omegaRestrictions: omegas' constraint vector.
#   timePoints: one single period time points.
#   maxiter: maximum number of iterations for the backfitting algorithm.
#   stopFunction: function to check the criterion convergence for the backfitting algorithm.
#   lengthAlphaGrid, lengthOmegaGrid: precision of the grid of alpha and omega parameters.
#   alphaGrid, omegaGrid: grids of alpha and omega parameters.
#   omegaMin: min value for omega.
#   omegaMax: max value for omega.
#   numReps: number of times the alpha-omega grid search is repeated.
#   parallelize: TRUE to use parallelized procedure to fit restricted FMM model.
# Returns an object of class FMM.
###############################################################
fitFMM_restr<-function(vData, nback, betaRestrictions, omegaRestrictions,
                       timePoints = seqTimes(length(vData)), maxiter = nback,
                       stopFunction = alwaysFalse, lengthAlphaGrid = 48,
                       lengthOmegaGrid = 24,
                       alphaGrid = seq(0,2*pi,length.out = lengthAlphaGrid), omegaMin = 0.0001, omegaMax = 1,
                       omegaGrid = exp(seq(log(omegaMin),log(omegaMax), length.out = lengthOmegaGrid)),
                       numReps = 3, parallelize = FALSE){

  betaRestrictions <- sort(betaRestrictions)
  omegaRestrictions <- sort(omegaRestrictions)

  # External grid of omega parameters
  numOmegas <- length(unique(omegaRestrictions))
  listOmegas <- replicate(n = numOmegas, omegaGrid, simplify = FALSE)
  omegasIter <- expand.grid(listOmegas)[,omegaRestrictions]

  # External loop on the omega grid, setting its value
  objectFMMList <- iterateOmegaGrid(vData = vData, omegasIter = omegasIter, betaRestrictions = betaRestrictions,
                                    timePoints = timePoints, alphaGrid = alphaGrid, numReps = numReps,
                                    nback = nback, maxiter = maxiter, stopFunction = stopFunction, parallelize = parallelize)

  # We keep the best solution
  SSElist <- lapply(objectFMMList, getSSE)
  outMobius <- objectFMMList[[which.min(SSElist)]]

  # Extra optimization to allow omega's to move more freely.
  # The stepOmega function is used.
  uniqueOmegas <- unique(getOmega(outMobius))
  uniqueOmegasOptim <- optim(par = uniqueOmegas, fn = stepOmega, indOmegas = omegaRestrictions,
                             objFMM = outMobius, omegaMax = omegaMax,
                             control = list(warn.1d.NelderMead = FALSE))$par
  # warn.1d.NelderMead to suppress Nelder-Mead method warning when used for a single omega.

  # A and M estimates are recalculated by linear regression
  beta <- getBeta(outMobius)
  alpha <- getAlpha(outMobius)
  omega <- uniqueOmegasOptim[omegaRestrictions]

  designMatrix <- calculateCosPhi(alpha = alpha, beta = beta, omega = omega, timePoints = timePoints)
  regresion <- lm(vData ~ designMatrix)
  M <- as.vector(coefficients(regresion)[1])
  A <- as.vector(coefficients(regresion)[-1])

  # Fitted values
  fittedFMMvalues <- predict(regresion)

  # Residual sum of squares
  SSE <- sum((fittedFMMvalues-vData)^2)
  nIter <- getNIter(outMobius)

  # Returns an object of class FMM
  return(FMM(
    M = M,
    A = A,
    alpha = alpha,
    beta = beta,
    omega = omega,
    timePoints = timePoints,
    summarizedData = vData,
    fittedValues= fittedFMMvalues,
    SSE = SSE,
    R2 = PVj(vData, timePoints, alpha, beta, omega),
    nIter = nIter
  ))
}

###############################################################
# Internal function: to fit restricted FMM models: approximated solution.
# Nested backfitting algorithm is used for fitting process. Depends on 'fitFMM_restr'.
# Arguments:
#   vData: data to be fitted an FMM model.
#   nback: number of FMM components to be fitted.
#   betaRestrictions: beta's constraint vector.
#   omegaRestrictions: omega's constraint vector.
#   timePoints: one single period time points.
#   maxiter: maximum number of iterations for the backfitting algorithm.
#   stopFunction: function to check the criterion convergence for the backfitting algorithm.
#   lengthAlphaGrid, lengthOmegaGrid: precision of the grid of alpha and omega parameters.
#   alphaGrid, omegaGrid: grids of alpha and omega parameters.
#   omegaMin: min value for omega.
#   omegaMax: max value for omega.
#   numReps: number of times the alpha-omega grid search is repeated.
#   showProgress: TRUE to display a progress indicator on the console.
#   parallelize: TRUE to use parallelized procedure to fit restricted FMM model.
# Returns an object of class FMM.
###############################################################
fitFMM_restr_omega_beta<-function(vData, nback, betaRestrictions, omegaRestrictions,
                                  timePoints = seqTimes(length(vData)), maxiter = nback,
                                  stopFunction = alwaysFalse, lengthAlphaGrid = 48, lengthOmegaGrid = 24,
                                  alphaGrid = seq(0, 2*pi, length.out = lengthAlphaGrid), omegaMin = 0.0001, omegaMax = 1,
                                  omegaGrid = exp(seq(log(omegaMin),log(omegaMax), length.out=lengthOmegaGrid)),
                                  numReps = 3, showProgress = TRUE, parallelize = FALSE){
  nObs <- length(vData)

  # showProgress
  if(showProgress){
    totalMarks <- 50
    partialMarkLength <- 2
    progressHeader<-paste(c("|",rep("-",totalMarks),"|\n|"), collapse = "")
    cat(progressHeader)
    completedPercentage <- 0.00001
    previousPercentage <- completedPercentage
  }

  # omega blocks
  numBlocks <- length(unique(omegaRestrictions))

  # Object initialization
  fittedValuesPerBlock <- matrix(0, ncol = numBlocks, nrow = nObs)
  fittedFMMPerBlock <- list()
  prevFittedFMMvalues <- NULL

  stopCriteria<-"Stopped by reaching maximum iterations ("
  # Backfitting algorithm: iteration
  for(i in 1:maxiter){

    blockIndex <- 1

    # Backfitting algorithm: component for each omega block
    for(j in unique(omegaRestrictions)){
        currentBlock <- which(omegaRestrictions == j)
        nCurrentBlock <- length(currentBlock)

        # data for block k: difference between vData and all other components fitted values
        # of other blocks
        backfittedData <- vData - apply(as.matrix(fittedValuesPerBlock[,-blockIndex]), 1, sum)

        # fitting of a block using fitFMM_restr function
        fittedFMMPerBlock[[blockIndex]] <- fitFMM_restr(backfittedData, nback = nCurrentBlock,
                                                  betaRestrictions = betaRestrictions[currentBlock],
                                                  omegaRestrictions = rep(1,nCurrentBlock),
                                                  timePoints = timePoints,
                                                  maxiter = ifelse(nCurrentBlock > 1,
                                                                   min(nCurrentBlock + 1, 4), 1),
                                                  lengthAlphaGrid = lengthAlphaGrid, lengthOmegaGrid = lengthOmegaGrid,
                                                  alphaGrid = alphaGrid, omegaMax = omegaMax, omegaGrid = omegaGrid,
                                                  numReps = numReps, parallelize = parallelize)
        fittedValuesPerBlock[,blockIndex] <- getFittedValues(fittedFMMPerBlock[[blockIndex]])

        blockIndex <- blockIndex + 1

        # showProgress
        if(showProgress){
          completedPercentage <- completedPercentage + 100/(nback*maxiter)
          if(ceiling(previousPercentage) < floor(completedPercentage)){
            progressDone <- paste(rep("=",sum((seq(ceiling(previousPercentage), floor(completedPercentage), by = 1)
                                             %% partialMarkLength == 0))), collapse = "")
            cat(progressDone)
            previousPercentage <- completedPercentage
          }
        }
    }

    # Check stop criterion
    # Fitted values as sum of all components
    fittedFMMvalues <- apply(fittedValuesPerBlock, 1, sum)

    if(!is.null(prevFittedFMMvalues)){
      if(PV(vData, prevFittedFMMvalues) > PV(vData, fittedFMMvalues)){
        fittedFMMPerBlock <- prevFittedFMMPerBlock
        fittedFMMvalues <- prevFittedFMMvalues
        stopCriteria <- "Stopped by reaching maximum R2 ("
        break
      }
      if(stopFunction(vData, fittedFMMvalues, prevFittedFMMvalues)){
        stopCriteria <- "Stopped by the stopFunction ("
        break
      }
    }
    prevFittedFMMvalues <- fittedFMMvalues
    prevFittedFMMPerBlock <- fittedFMMPerBlock
  }
  nIter <- i

  # showProgress
  if(showProgress){
    if(completedPercentage < 100){
      completedPercentage <- 100
      nMarks <- ifelse(ceiling(previousPercentage) < floor(completedPercentage),
                       sum((seq(ceiling(previousPercentage), floor(completedPercentage), by = 1)
                            %% partialMarkLength == 0)), 0)
      if (nMarks > 0) {
        cat(paste(rep("=",nMarks), collapse = ""))
        previousPercentage <- completedPercentage
      }
    }
    cat("|\n", paste(stopCriteria, nIter, sep = ""), "iteration(s))", "\n")
  }

  # alpha, beta and omega estimates
  alpha <- unlist(lapply(fittedFMMPerBlock, getAlpha))
  beta <- unlist(lapply(fittedFMMPerBlock, getBeta))
  omega <- unlist(lapply(fittedFMMPerBlock, getOmega))

  # A and M estimates are recalculated by linear regression
  cosPhi <- calculateCosPhi(alpha = alpha, beta = beta, omega = omega, timePoints = timePoints)
  regression <- lm(vData ~ cosPhi)
  M <- as.vector(coefficients(regression)[1])
  A <- as.vector(coefficients(regression)[-1])

  # Fitted values
  fittedFMMvalues <- predict(regression)

  # Residual sum of squares
  SSE <- sum((fittedFMMvalues - vData)^2)

  # Returns an object of class FMM
  return(FMM(
    M = M,
    A = A,
    alpha = alpha,
    beta = beta,
    omega = omega,
    timePoints = timePoints,
    summarizedData = vData,
    fittedValues = fittedFMMvalues,
    SSE = SSE,
    R2 = PVj(vData, timePoints, alpha, beta, omega),
    nIter = nIter
  ))
}
