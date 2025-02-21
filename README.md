# FMM base R Package

## Overview

The FMM (Frequency Modulated Möbius) model is a nonlinear parametric regression approach designed to analyze nearly periodic, non-sinusoidal physiological time series, extracting key features encoded in time-varying oscillatory morphology. This method decomposes signals into harmonic functions, known as Möbius waves, which are characterized by four physiologically interpretable parameters: amplitude ($A$), location ($\alpha$), width/sharpness ($\omega$), and direction/symmetry ($\beta$).

The FMM approach has demonstrated its effectiveness across various fields, including cardiology, neuroscience, and circadian biology, among many others. 

Readers may refer to Rueda, Larriba, and Peddada (2019), Rueda, Rodríguez-Collado, and Larriba (2021), and Rueda, Larriba, and Lamela (2021) for further details.

## FMM R package

[![CRAN_Status_Badge](https://www.r-pkg.org/badges/version/FMM)](https://cran.r-project.org/package=FMM)

The 'FMM' R package provides a collection of well-documented functions to fit and explore single, multi-component, and restricted FMM models in the programming language R. 

### Installation

```
# Can be installed directly from CRAN
install.packages("FMM")
# Or the development version from GitHub:
# install.packages("devtools")
devtools::install_github("FMMGroupVa/FMM")
```

### Using FMM

To get acquainted with some of the important functions, read the vignette:

```
# Overview of the package
vignette("FMMVignette", package = "FMM")
```

## References

Rueda, C., Larriba, Y., & Peddada, S. D. (2019). Frequency modulated möbius model accurately predicts rhythmic signals in biological and physical sciences. *Scientific reports, 9(1)*, 18701.

Rueda, C., Rodríguez-Collado, A., & Larriba, Y. (2021). A novel wave decomposition for oscillatory signals. *IEEE Transactions on Signal Processing, 69*, 960-972.

Rueda, C., Larriba, Y., & Lamela, A. (2021). The hidden waves in the ECG uncovered revealing a sound automated interpretation method. *Scientific reports, 11(1)*, 3724.
