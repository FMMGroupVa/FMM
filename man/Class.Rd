\name{FMM-class}
\alias{FMM-class}

\title{FMM Class Representation}

\description{

    Class representation for an S4 object of class \code{'FMM'}.
}

\value{

    The S4 object of class \code{'FMM'} contains the following slots:

    \item{@timePoints}{
        The time points as specified by the input argument. It is a numeric vector containing the time points
        at which each data of one single period is observed.
        }
    \item{@data}{
        The data as specified by the input argument. It is a numeric vector containing the data to be fitted
        a FMM model. Data could be collected over multiple periods.
        }
    \item{@summarizedData}{
        When the data has more than one period, a numeric vector containing \code{data} averaging the data at
        each time point across all considered periods.
    	}
   	\item{@nPeriods}{
        A numeric value containing the number of periods in data as specified by the input argument.
        }
    \item{@fittedValues}{
        A numeric vector of the fitted values by the FMM model.
        }
    \item{@M}{
         A numeric value of the estimated intercept parameter \eqn{M}.
        }
    \item{@A}{
        A numeric value or vector of the estimated FMM wave amplitude parameter(s) \eqn{A}.
        }
    \item{@alpha}{
        A numeric value or vector of the estimated FMM wave phase translation parameter(s) \eqn{\alpha}.
        }
    \item{@beta}{
        A numeric value or vector of the estimated FMM wave skewness parameter(s) \eqn{\beta}.
        }
    \item{@omega}{
        A numeric value or vector of the estimated FMM wave kurtosis parameter(s) \eqn{\omega}.
        }
    \item{@SSE}{
        A numeric value of the sum of the residual squares values.
        }
    \item{@R2}{
        A numeric vector specifying the explained variance by each of the fitted FMM components.
    	}
     \item{@nIter}{
        A numeric value specifying the number of iterations of the fitting algorithm.
    	}

}

\examples{
## FMM class
getClass("FMM")
getSlots("FMM")
}




