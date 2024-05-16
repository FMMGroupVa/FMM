# FMM 0.4.0

Enhancements:

-   Optimized monocomponent and multicomponent model computation: (1) The grid search is performed without redundant calculus, and (2) the post-optimization procedure now only searchs in a 2-dimensional space, converging faster to a better solution. These changes make the parallelization (`parallelize` argument) and the iterative refinement of the grid (`numReps` argument) useless.
-   New internal function `precalculateBase`. This function performs the precalculations needed to optimize grid search calculus.
-   New implementation of function `step2FMM`, used to perform the post-optimization. First argument `parameters` is a vector with values alpha and omega to evaluate the objective function.


Changes:

-   `parallelize` and `numReps` arguments are now internally treated as deprecated. A warning is thrown when a call to `fitFMM`, `fitFMM_back` or `fitFMM_unit` contains `parallelize` or `numReps` arguments. 
-   New version of `step1FMM` function to adapt calculus to the `precalculateBase` results. The old version of this function is availible as `step1FMMOld`. `step1FMMOld` is still used in functions to perform restricted models.
-   `omega = 1` is not permitted to avoid singular systems. Then, `omegaGrid` in function `fitFMM`, `fitFMM_back` and `fitFMM_unit` is changed. This restriction is included in post-optimization routines.
-   The link to the GitHub repository (`DESCRIPTION` file) has been changed to repo FMMGroupVa/FMM.

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
