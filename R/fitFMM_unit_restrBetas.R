
fitFMM_unit_restrBetas <- function(vData, timePoints = seqTimes(length(vData)),
                              lengthAlphaGrid = 48, lengthOmegaGrid = 24,
                              alphaGrid = seq(0, 2*pi, length.out = lengthAlphaGrid),
                              omegaMin = 0.0001, omegaMax = 1,
                              omegaGrid = exp(seq(log(omegaMin), log(omegaMax),
                                                  length.out = lengthOmegaGrid+1))[1:lengthOmegaGrid],
                              betaMin, betaMax,
                              numReps = 1, usedApply = NA,
                              gridList = precalculateBase(alphaGrid = alphaGrid, omegaGrid = omegaGrid,
                                                          timePoints = timePoints)){

  step1OutputNames <- c("M","A","alpha","beta","omega","RSS")
  nObs <- length(vData)
  #grid <- expand.grid(alphaGrid, omegaGrid)
  step1 <- matrix(unlist(lapply(FUN = step1FMMRestrBetas, X = gridList, vData = vData,
                                betaMin = betaMin, betaMax = betaMax)),
                  ncol = 6, byrow = T)

  colnames(step1) <- step1OutputNames

  # We find the optimal initial parameters,
  # minimizing Residual Sum of Squared with several stability conditions.
  # We use bestStep1 internal function
  bestPar <- bestStep1(vData, step1)

  ## Step 2: Nelder-Mead optimization. 'step2FMM' function is used.
  nelderMead <- optim(par = bestPar[c(3,5)], fn = step2FMMRestrBetas, vData = vData,
                      timePoints = timePoints, omegaMax = omegaMax,
                      betaMin = betaMin, betaMax = betaMax)
  parFinal <- nelderMead$par
  parFinal[1] <- parFinal[1] %% (2*pi)
  SSE <- nelderMead$value

  nonlinearMob = 2*atan(parFinal[2]*tan((timePoints-parFinal[1])/2))
  M <- cbind(rep(1, nObs), cos(nonlinearMob), sin(nonlinearMob))
  OLS <- .lm.fit(M, vData)$coefficients
  sigmaMat <- solve(t(M)%*%M)

  betaOLS <- atan2(-OLS[3], OLS[2])
  betaOLS2 <- (betaOLS-betaMin)%%(2*pi)

  betaRegionAmplitude <- (betaMax-betaMin)%%(2*pi)
  if(betaRegionAmplitude<pi){
    if(betaOLS2<(betaMax-betaMin)){
      # Region whose points are valid solutions
      RLS <- OLS

    }else if(betaOLS2 > (3*pi/2)){
      # Region whose points project onto R1
      R <- matrix(c(0, tan(betaMin), 1), ncol = 3)
      RLS <- OLS - sigmaMat%*%t(R)%*%solve(R%*%sigmaMat%*%t(R))%*%(R%*%OLS)

    }else if(betaOLS2 < (betaMax-betaMin+pi/2)){
      # Region whose points project onto R2
      R <- matrix(c(0, tan(betaMax), 1), ncol = 3)
      RLS <- OLS - sigmaMat%*%t(R)%*%solve(R%*%sigmaMat%*%t(R))%*%(R%*%OLS)

    }else{
      # Region whose points project onto the origin
      RLS <- c(mean(vData), 0, 0)
    }
  }else{
    R1 <- matrix(c(0, tan(betaMin), 1), ncol = 3)
    RLS1 <- OLS - sigmaMat%*%t(R1)%*%solve(R1%*%sigmaMat%*%t(R1))%*%(R1%*%OLS)
    RSS1 <- sum((vData-(RLS1[1] + RLS1[2]*cos(nonlinearMob)+RLS1[3]*sin(nonlinearMob)))^2)

    R2 <- matrix(c(0, tan(betaMax), 1), ncol = 3)
    RLS2 <- OLS - sigmaMat%*%t(R2)%*%solve(R2%*%sigmaMat%*%t(R2))%*%(R2%*%OLS)
    RSS2 <- sum((vData-(RLS2[1] + RLS2[2]*cos(nonlinearMob)+RLS2[3]*sin(nonlinearMob)))^2)

    if(RSS1<RSS2){
      RLS <- RLS1
    }else{
      RLS <- RLS2
    }
  }


  aParameter <- sqrt(RLS[2]^2 + RLS[3]^2)
  betaParameter <- (atan2(-RLS[3], RLS[2])) %% (2*pi)
  parFinal <- c(RLS[1], aParameter, parFinal[1], betaParameter, parFinal[2])

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
