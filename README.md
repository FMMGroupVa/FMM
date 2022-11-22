# FMM: Rhythmic Patterns Modeling by FMM Models

## Overview

[![CRAN_Status_Badge](https://www.r-pkg.org/badges/version/FMM)](https://cran.r-project.org/package=FMM)

Provides a collection of functions to fit and explore single, multi-component and restricted Frequency Modulated Moebius (FMM) models in the programming language R. 'FMM' is a nonlinear parametric regression model capable of fitting non-sinusoidal shapes in rhythmic patterns. Details about the mathematical formulation of 'FMM' models can be found in Rueda et al. (2019) <https://doi.org/10.1038/s41598-019-54569-1>.

## Installation

```
# Can be installed directly from CRAN
install.packages("FMM")
# Or the development version from GitHub:
# install.packages("devtools")
devtools::install_github("alexARC26/FMM")
```

## Using FMM

To get acquainted with some of the important functions, read the vignette:

```
# Overview of the package
vignette("FMMVignette", package = "FMM")
```