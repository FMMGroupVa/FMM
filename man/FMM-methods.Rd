\name{FMM-methods}

\alias{FMM-methods}
\alias{summary}
\alias{coef}
\alias{fitted}
\alias{resid}
\alias{summary,FMM-method}
\alias{coef,FMM-method}
\alias{fitted,FMM-method}
\alias{resid,FMM-method}

\title{Methods for objects of class \code{'FMM'}}

\description{
    The methods for objects of class \code{'FMM'} are:

    \tabular{ll}{
    \code{coef}    \tab coef method for S4 class \code{'FMM'}, \cr
    \code{summary} \tab summary method for S4 class \code{'FMM'}, \cr
    \code{fitted}  \tab fitted method for S4 class \code{'FMM'}, \cr
    \code{resid}   \tab resid method for S4 class \code{'FMM'}.}
}

\usage{
## S4 coef method for signature 'FMM'
coef(object,...)

## S4 summary method for signature 'FMM'
summary(object,...)

## S4 fitted method for signature 'FMM'
fitted(object,...)

## S4 resid method for signature 'FMM'
resid(object,...)

}


\arguments{
   \item{object}{object of class \code{'FMM'}.}
   \item{...}{additional arguments passed to the method.}
}

\value{
\itemize{
   \item{The function \code{coef()} returns a \code{list} with two components:
      \tabular{lll}{
        \tab  \code{M}    \tab A numeric value. The estimated intercept parameter \eqn{M}.\cr
        \tab  \code{wave} \tab A \code{data.frame} with the estimates of each FMM wave parameters.
                          It is organised as one component per row.
      }
   }

   \item{ The function \code{summary()} displays relevant results of the fitting.
          When it is assigned, this function returns a \code{list} with the following components:
      \tabular{lll}{
         \tab   \code{coef}        \tab    The \code{list} returns by the function \code{coef()}.\cr
         \tab   \code{peak.time}   \tab    A \code{data.frame} with the estimates of the peak and trough
                                           times of each wave. It is organised as one component per row.\cr
         \tab   \code{resid}       \tab    The \code{vector} of residuals.\cr
         \tab   \code{R.squared}   \tab    A numerical value with the R squared of each wave. The total R square
                                           is computed as the sum of the contribution of each component.
      }
     }

    \item{The function \code{fitted()} returns a \code{data.frame} with two columns:
                   \code{timePoints} and \code{fittedValues}.
        }

  \item{The function \code{resid()} returns a numeric \code{vector} with residuals of the model.
        }


     }
}


\examples{
## Generate example data:
fmm2.data <- generateFMM(0, rep(2, 2), c(1.5, 3.4), c(0.2, 2.3), c(0.1, 0.2),
                    plot = FALSE, outvalues = TRUE,
                    sigmaNoise = 0.5) # add a gaussian noise with sigma = 0.5

## Fit the FMM model with nback = 2 component
## fit is an object of S4 class 'FMM'
fit <- fitFMM(vData = fmm2.data$y,timePoints = fmm2.data$t,nback = 2,
              lengthAlphaGrid = 24,lengthOmegaGrid = 10)

## Extract coefficients of the model:
coef(fit)

## Summarize results:
summary(fit)

## Results on a list:
res <- summary(fit)
res$peak.time # fiducial points

## fitted values:
fit.values <- fitted(fit)

## residuals
res <- resid(fit)

}

