\name{getS4}

\alias{getTimePoints}
\alias{getData}
\alias{getSummarizedData}
\alias{getNPeriods}
\alias{getFittedValues}
\alias{getM}
\alias{getA}
\alias{getAlpha}
\alias{getBeta}
\alias{getOmega}
\alias{getSSE}
\alias{getR2}
\alias{getNIter}

\title{General S4 Class Extractor Functions}


\description{

    A collection of functions to extract slots from S4 objects of class \code{'FMM'}.
    \cr

    The extractor functions are:

    \tabular{ll}{
    % \code{getCall} \tab Extracts the call slot from a S4 object, \cr
    \code{getTimePoints} \tab Extracts the timePoints slot from a S4 object of class \code{'FMM'}. \cr
    \code{getData} \tab Extracts the data slot from a S4 object of class \code{'FMM'}, \cr
    \code{getSummarizedData} \tab Extracts the  summarizedData slot from a S4 object of class \code{'FMM'}, \cr
    \code{getNPeriods} \tab Extracts the  nPeriods slot from a S4 object of class \code{'FMM'}, \cr
    \code{getFittedValues} \tab Extracts the fittedValues slot from a S4 object of class \code{'FMM'}, \cr
    \code{getM} \tab Extracts the M slot from a S4 object of class \code{'FMM'}, \cr
    \code{getA} \tab Extracts the A slot from a S4 object of class \code{'FMM'}, \cr
    \code{getAlpha} \tab Extracts the alpha slot from a S4 object of class \code{'FMM'}, \cr
    \code{getBeta} \tab Extracts the beta slot from a S4 object of class \code{'FMM'}, \cr
    \code{getOmega} \tab Extracts the omega slot from a S4 object of class \code{'FMM'}, \cr
    \code{getSSE} \tab Extracts the SSE slot from a S4 object of class \code{'FMM'}, \cr
    \code{getR2} \tab Extracts the R2 slot from a S4 object of class \code{'FMM'}, \cr
    \code{getNIter} \tab Extracts the nIter slot from a S4 object of class \code{'FMM'}, \cr
    }

}
\usage{
getM(objFMM)
getOmega(objFMM)
getData(objFMM)
}

\arguments{
  \item{objFMM}{an object of class of class \code{'FMM'}.}
}
\value{
   Return the content of the corresponding slot.
}


