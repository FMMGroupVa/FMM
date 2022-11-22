#' Fifth annotated beat (lead MLII) from patient sel100 in 'QT database'
#'
#' Voltage electric activity data (mV) of the fifth annotated heartbeat for patient sel100 in 'QT database'.
#' 200 samples were collected along 0.8 seconds with a sampling frequency of 250 Hz.
#' Data records correspond to samples from 151248 to 151049 and can be dowload as text files from 'Physionet' website.
#' Annotated beats were manually revised by experts including R peaks and fiducial marks.
#'
#' @docType data
#'
#' @usage data(ecgData)
#'
#' @format A numeric vector.
#'
#' @keywords datasets
#'
#' @references Goldberger A, Amaral L, Glass L, Hausdorff J et al. (2000).
#' A qrs detection and r point recognition method for wearable single-lead ecg devices.
#' \emph{Circulation}, \bold{101} (23), E215-20. \url{https://www.ncbi.nlm.nih.gov/pmc/articles/PMC5621148/}
#'
#' Laguna P, Mark RG, Goldberg A,  Moody GB (1997).
#' A database for evaluation of algorithms for measurement of qt and other waveform intervals
#' in the ecg.
#' \emph{Computers in cardiology 1997}, 673-676. \url{https://ieeexplore.ieee.org/document/648140}
#'
#' @source 'QT database' from 'Physionet' <https://archive.physionet.org/cgi-bin/atm/ATM>
#'
#' @examples
#' data(ecgData)
#' str(ecgData)
"ecgData"
