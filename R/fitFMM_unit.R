################################################################################
# Internal function: fit monocomponent FMM model
# Arguments:
#   vData: data to be fitted an FMM model.
#   timePoints: one single period time points.
#   lengthAlphaGrid, lengthOmegaGrid: precision of the grid of
#                                     alpha and omega parameters.
#   alphaGrid, omegaGrid: grids of alpha and omega parameters.
#   omegaMax: max value for omega.
#   (DEPRECATED) numReps: number of times the alpha-omega grid search is repeated.
#   (DEPRECATED) usedApply: paralellized version of apply for grid search
#   gridList: list that contains precalculations to make grid search
#             calculations lighter
# Returns an object of class FMM.
################################################################################
fitFMM_unit <- function(vData, timePoints = seqTimes(length(vData)),
                        lengthAlphaGrid = 48, lengthOmegaGrid = 24,
                        alphaGrid = seq(0, 2*pi, length.out = lengthAlphaGrid),
                        omegaMin = 0.0001, omegaMax = 1,
                        omegaGrid = exp(seq(log(omegaMin), log(omegaMax),
                                            length.out = lengthOmegaGrid+1))[1:lengthOmegaGrid],
                        numReps = 1, usedApply = NA,
                        gridList = precalculateBase(alphaGrid = alphaGrid, omegaGrid = omegaGrid,
                                                    timePoints = timePoints)){
  if(!is.na(usedApply)){
    warning("Argument 'usedApply' is deprecated.")
  }

  if(numReps>1){
    warning("Argument 'numReps' is deprecated.")
  }

  nObs <- length(vData)
  grid <- expand.grid(alphaGrid, omegaGrid)
  step1OutputNames <- c("M","A","alpha","beta","omega","RSS")

  ## Step 1: initial values of M, A, alpha, beta and omega. Parameters alpha and
  # omega are initially fixed and cosinor model is used to calculate the rest of the parameters.
  # step1FMM function is used to make this estimate.
  step1 <- matrix(unlist(lapply(FUN = step1FMM, X = gridList, vData = vData)),
                  ncol = 6, byrow = T)
  colnames(step1) <- step1OutputNames

  # We find the optimal initial parameters,
  # minimizing Residual Sum of Squared with several stability conditions.
  # We use bestStep1 internal function
  bestPar <- bestStep1(vData, step1)

  ## Step 2: Nelder-Mead optimization. 'step2FMM' function is used.
  nelderMead <- optim(par = bestPar[c(3,5)], fn = step2FMM, vData = vData,
                      timePoints = timePoints, omegaMax = omegaMax)
  parFinal <- nelderMead$par
  parFinal[1] <- parFinal[1] %% (2*pi)
  SSE <- nelderMead$value

  nonlinearMob = 2*atan(parFinal[2]*tan((timePoints-parFinal[1])/2))
  M <- cbind(rep(1, nObs), cos(nonlinearMob), sin(nonlinearMob))
  pars <- .lm.fit(M, vData)$coefficients

  aParameter <- sqrt(pars[2]^2 + pars[3]^2)
  betaParameter <- (atan2(-pars[3], pars[2])+2*pi) %% (2*pi)
  parFinal <- c(pars[1], aParameter, parFinal[1], betaParameter, parFinal[2])

  # alpha and beta between 0 and 2pi
  parFinal[3] <- parFinal[3]%%(2*pi)

  names(parFinal) <- step1OutputNames[-6]

  # Returns an object of class FMM.
  fittedFMMvalues <- parFinal["M"] + parFinal["A"]*cos(parFinal["beta"] +
                                                         2*atan(parFinal["omega"]*tan((timePoints-parFinal["alpha"])/2)))
  SSE <- sum((fittedFMMvalues-vData)^2)

  return(FMM(
    M = parFinal[[1]],
    A = parFinal[[2]],
    alpha = parFinal[[3]],
    beta = parFinal[[4]],
    omega = parFinal[[5]],
    timePoints = timePoints,
    summarizedData = vData,
    fittedValues = fittedFMMvalues,
    SSE = SSE,
    R2 = PV(vData, fittedFMMvalues),
    nIter = 0
  ))
}



