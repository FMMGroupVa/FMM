\name{FMM-internal}

\alias{internal}
\alias{fitFMM_unit}
\alias{fitFMM_back}
\alias{fitFMM_restr}
\alias{fitFMM_restr_omega_beta}
\alias{fitFMM_unit_restr}
\alias{step1FMM}
\alias{bestStep1}
\alias{step2FMM}
\alias{step2FMM_restr}
\alias{backfittingRestr}
\alias{iterateOmegaGrid}
\alias{stepOmega}
\alias{R2}
\alias{alwaysFalse}
\alias{PV}
\alias{PVj}
\alias{angularMean}
\alias{seqTimes}
\alias{calculateCosPhi}
\alias{getApply}
\alias{addShowMethod}

\title{Internal functions for the 'FMM' package.}

\description{
The 'FMM' package contains several internal functions called by other functions that are not designed to be called by the user.

To fit a 'FMM' model: The fitting function \code{fitFMM()} calls different internal functions for fits in different situations. \code{fitFMM_unit()} function fits a monocomponent 'FMM' model and \code{fitFMM_back()} fits a multicomponent 'FMM' model via a backfitting algorithm. For restricted version, \code{fitFMM_unit_restr()} is used to fit a monocomponent FMM model with fixed omega; \code{fitFMM_restr_omega_beta()} and \code{fitFMM_restr()} are used to fit multicomponent 'FMM' models with equality constraints for the beta and omega parameters.

To fit a single 'FMM' component: The functions \code{step1FMM()}, \code{bestStep1()} are used to find the initial parameter estimations and their optimal values in the first step of the fitting process. \code{step2FMM()} computes the residual sum of squares in the second step of 'FMM' fitting process. In the restricted version, this function is called \code{step2FMM_restr()}. In addition, \code{stepOmega()} function is used in an extra optimization step of omega.

To check the convergence criterion for the backfitting algorithm: \code{alwaysFalse()} is used to force a number of iterations while \code{R2()} is used to check if the stop condition, based on the difference between the variability explained in two consecutive iterations, is reached.

Additional functions: The functions \code{PV()}, \code{PVj()}, \code{angularMean()} and \code{calculateCosPhi()} are used in the fitting process to compute the total percentage of variability explained, the percentage of variability explained by each component of 'FMM' model, the angular mean and the cosinus of each of the waves phase,respectively. \code{seqTimes()} is used to build a sequence of equally time points spaced in range \eqn{[0, 2\pi]}. \code{getApply()} serves to prepare the parallelized estimation procedure.

}

\details{These are not to be called directly by the user.}

\value{
Depending on the returned value:
\itemize{
   \item{\code{fitFMM_unit()}, \code{fitFMM_back()}, \code{fitFMM_unit_restr()},
         \code{fitFMM_restr_omegaBeta()}, \code{backFittingRestr()} and \code{fitFMM_restr()}
         return an S4 object of class \code{'FMM'}.
   }
   \item{\code{iterateOmegaGrid()} returns a list with S4 objects of class FMM.
   }
   \item{\code{step1FMM()} and \code{bestStep1()} return a numerical vector with the initial parameter estimations
         and residual sum of squares, respectively. \code{PVj()} returns a vector with the percentage of variability
         explained by each component of 'FMM' model. \code{seqTime()} returns a numerical vector with a sequence of
         equally time points spaced in range [0,2*pi].
   }
   \item{\code{step2FMM()}, \code{step2FMM_restr()} and \code{stepOmega()} return a numerical value with residual
         sum of squares of a possible solution. \code{PV()} returns the total percentage of variability explained
         by the model. \code{angularMean()} returns the angular mean of the input angles.
   }
    \item{\code{R2()} and \code{alwaysFalse()} return a logical value. \code{alwaysFalse()} always returns
          \code{FALSE} while \code{R2()} returns \code{TRUE} when the convergence criterion is reached.
    }
  }
}

\keyword{ internal }
