# FMM 0.4.0

Enhancements:

- **Significant computation time reduction**: The grid search is performed without redundant calculus, and the profile likelihood approach is implemented in the post-optimization procedure, which ensures a faster convergence to a local optimum. These changes make the parallelization (`parallelize` argument) and the iterative refinement of the grid (`numReps` argument) useless.

- **`plotFMM` improvements**: Bug fixes and predictions now computed on a denser, evenly spaced grid, in addition to the original time points.

- **Cleaner, more efficient code:** Deprecated numReps and parallelize arguments. Default value of showProgress changed from TRUE to FALSE.

New features:

- **Extended fitFMM arguments:** New parameters: omegaMin, omegaMax, and omegaGrid.

- **New warnings added:** for excessively large amplitude estimates and significantly wide gaps in time points.

Changes:

-  **Repository**: The link to the GitHub repository (`DESCRIPTION` file) has been changed to repo *FMMGroupVa/FMM*.

-  **Vignettes**: The vignette has been updated as a result of the changes.

-  **Internal functions**: Functions `bestStep1`, `getApply` are moved from `FMM_internal` to `FMM_internal_restr`. The old version of `step1FMM` have been renamed as `step1FMMRestr` and also moved `FMM_internal_restr`. New internal functions `checkArguments` and `checkSolution` to validate input parameters and verify the correctness of computed results.

# FMM 0.3.1

Minor improvements and fixes:

-   A vignette has been added.
-   The default value of the argument showTime of fitFMM() function has been changed to FALSE.
-   `R2()` and `alwaysFalse()` functions are listed in `NAMESPACE` file.
-   A link to the GitHub repository has been added to `DESCRIPTION` file.
-   An example for plotting the original time scale on the x-axis of the ggplots has been added to the documentation of the `plotFMM()` function.
-   Add automated unit tests for `fitFMM()` function.
-   `fitFMM()` prints informative error messages when the number of observation is insufficient or data are constant.

# FMM 0.3.0

Enhancements:

-   Optimization of the estimation procedure for the monocomponent, multicomponent and restricted FMM models. An embedded parallelized procedure is available for all the models for faster estimations.
-   Code has been refined: it is now more object-oriented, code duplicity has been reduced, unnecessary orders have been suppressed, API usability has been improved, and the documentation is now automatically created with `roxygen2`.

New features:

-   In addition to the estimation by blocks previously available for the restricted model, an exact implementation has been added for more accurate fits in expense of more computational time.

# FMM 0.2.0

New features:

-   Optimized monocomponent and multicomponent model computation.

# FMM 0.1.2

Enhancements:

-   Added a slot in the FMM object with information on the number of iteraction of the fitting process.
-   Renamed the `FMMPeaks` function to `getFMMPeaks`.
-   Renamed the `generate_FMM` function to `generateFMM`. Also parameters `a`, `b` and `w` to `alpha`, `beta` and `omega`, respectively.

New features:

-   New `show()` method to print basic information on an FMM object.

# FMM 0.1.1

Fixed the issues pointed out in the review of the CRAN submission:

-   Modified the beginning of the description.
-   Added details about internal functions in the documentation.
-   Replaced the use of `cat()` by `warning()`.
-   `options(warn=-1)` is no longer used.
-   No example in the documentation of the functions uses more than two processor cores.

# FMM 0.1.0

-   Submitted version 0.1.0 to CRAN.
