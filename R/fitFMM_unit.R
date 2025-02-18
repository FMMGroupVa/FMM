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
#   reltol:
#   gridList: list that contains precalculations to make grid search
#             calculations lighter
# Returns an object of class FMM.
################################################################################
fitFMM_unit <- function(vData, timePoints = seqTimes(length(vData)),
                        lengthAlphaGrid = 48, lengthOmegaGrid = 24,
                        alphaGrid = seq(0, 2*pi, length.out = lengthAlphaGrid),
                        omegaMin = 0.0001, omegaMax = 0.999,
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
  step1OutputNames <- c("alpha","omega","RSS")

  ## Step 1: initial values of M, A, alpha, beta and omega. Parameters alpha and
  # omega are initially fixed and cosinor model is used to calculate the rest of the parameters.
  # step1FMM function is used to make this estimate.
  step1 <- matrix(unlist(lapply(FUN = step1FMM, X = gridList, vData = vData)),
                  ncol = 3, byrow = T)
  colnames(step1) <- step1OutputNames
  bestPar <- step1[which.min(step1[,"RSS"]),]

  ## Step 2: Nelder-Mead optimization. 'step2FMM' function is used.
  nelderMead <- optim(par = bestPar[c(1,2)], fn = step2FMM,
                      vData = vData, timePoints = timePoints,
                      omegaMin = omegaMin, omegaMax = omegaMax)

  parFinal <- nelderMead$par
  parFinal[1] <- parFinal[1] %% (2*pi)

  # Linear parameters recalculation
  nonlinearMob = 2*atan(parFinal[2]*tan((timePoints-parFinal[1])/2))
  M <- cbind(rep(1, nObs), cos(nonlinearMob), sin(nonlinearMob))
  pars <- stats::.lm.fit(M, vData)$coefficients

  # Returns an object of class FMM.
  fittedFMMvalues <- pars[1]+ pars[2]*cos(nonlinearMob) + pars[3]*sin(nonlinearMob)
  SSE <- sum((fittedFMMvalues-vData)^2)

  return(FMM(
    M = pars[1],
    A = sqrt(pars[2]^2 + pars[3]^2),
    alpha = parFinal[1] %% (2*pi),
    beta = atan2(-pars[3], pars[2]) %% (2*pi),
    omega = parFinal[2],
    timePoints = timePoints,
    summarizedData = vData,
    fittedValues = fittedFMMvalues,
    SSE = SSE,
    R2 = PV(vData, fittedFMMvalues),
    nIter = 0
  ))
}



