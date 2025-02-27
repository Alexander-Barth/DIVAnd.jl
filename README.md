# DIVAnd
[![Project Status: Active – The project has reached a stable, usable state and is being actively developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
[![Build Status](https://github.com/gher-ulg/DIVAnd.jl/workflows/CI/badge.svg)](https://github.com/gher-ulg/DIVAnd.jl/actions)
[![codecov.io](http://codecov.io/github/gher-ulg/DIVAnd.jl/coverage.svg?branch=master)](http://codecov.io/github/gher-ulg/DIVAnd.jl?branch=master)
[![documentation stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://gher-ulg.github.io/DIVAnd.jl/stable/)
[![documentation latest](https://img.shields.io/badge/docs-latest-blue.svg)](https://gher-ulg.github.io/DIVAnd.jl/latest/)
[![DOI](https://zenodo.org/badge/79277337.svg)](https://zenodo.org/badge/latestdoi/79277337)

`DIVAnd` (Data-Interpolating Variational Analysis in n dimensions) performs an n-dimensional variational analysis/gridding of arbitrarily located observations. Observations will be interpolated/analyzed on a curvilinear grid in 1, 2, 3 or more dimensions. In this sense it is a generalization of the original two-dimensional DIVA version (still available here https://github.com/gher-ulg/DIVA but not further developed anymore).

The method bears some similarities and equivalences with Optimal Interpolation or Krigging in that it allows to create a smooth and continous field from a collection of observations, observations which can be affected by errors. The analysis method is however different in practise, allowing to take into account topological features, physical constraints etc in a natural way. The method was initially developped with ocean data in mind, but it can be applied to any field where localized observations have to be used to produce gridded fields which are "smooth".

See also https://gher-ulg.github.io/DIVAnd-presentation/#1

Please cite this paper as follows if you use `DIVAnd` in a publication:

Barth, A., Beckers, J.-M., Troupin, C., Alvera-Azcárate, A., and Vandenbulcke, L.: DIVAnd-1.0: n-dimensional variational data analysis for ocean observations, Geosci. Model Dev., 7, 225-241, doi:[10.5194/gmd-7-225-2014](https://doi.org/10.5194/gmd-7-225-2014), 2014.

(click [here](./data/DIVAnd.bib) for the BibTeX entry).


# Installing

You need [Julia](http://julialang.org) (version 1.6 or 1.7) to run `DIVAnd`. The command line version is sufficient for `DIVAnd`.
Inside a Julia terminal, you can download and install the package by issuing:

```julia
using Pkg
Pkg.add("DIVAnd")
```

It is not recommended to download the source of `DIVAnd.jl` directly (using the green *Clone or Download* button above) because this by-passes Julia's package manager and you would need to install the dependencies of `DIVAnd.jl` manually.


# Updating DIVAnd

To update DIVAnd, run the following command and restart Julia (or restart the jupyter notebook kernel using `Kernel` -> `Restart`):

```julia
using Pkg
Pkg.update("DIVAnd")
```

Note that Julia does not directly delete the previous installed version.
To check if you have the latest version run the following command:

```julia
using Pkg
Pkg.status()
```

The latest version number is available from [here](https://github.com/gher-ulg/DIVAnd.jl/releases).

To explicitly install a given version `X.Y.Z` you can also use:

```julia
using Pkg
Pkg.add(name="DIVAnd", version="X.Y.Z")
```
Or the master version:

```julia
using Pkg
Pkg.add(name="DIVAnd", rev="master")
```

# Testing

A test script is included to verify the correct functioning of the toolbox.
The script should be run in a Julia session.
Make sure to be in a directory with write-access (for example your home directory).
You can change the directory to your home directory with the `cd(homedir())` command.

```julia
using Pkg
Pkg.test("DIVAnd")
```

All tests should pass without error.

```
INFO: Testing DIVAnd
Test Summary: | Pass  Total
  DIVAnd      |  427    427
INFO: DIVAnd tests passed
```

The test suite will download some sample data.
You need to have Internet access and run the test function from a directory with write access.

# Documentation

The main routine of this toolbox is called `DIVAnd` which performs an n-dimensional variational analysis of arbitrarily located observations. Type the following in Julia to view a list of parameters:

```julia
using DIVAnd
?DIVAndrun
```

see also https://gher-ulg.github.io/DIVAnd.jl/latest/index.html

## Example

[DIVAnd_simple_example_4D.jl](https://github.com/gher-ulg/DIVAnd.jl/blob/master/examples/DIVAnd_simple_example_4D.jl) is a basic example in fours dimensions. The call to `DIVAndrun` looks like this:

```julia
fi,s = DIVAndrun(mask,(pm,pn,po,pq),(xi,yi,zi,ti),(x,y,z,t),f,len,epsilon2);

```
where
`mask` is the land-sea mask, usually obtained from the bathymetry/topography,
`(pm,pn,po,pq)` is a *n*-element tuple (4 in this case) containing the scale factors of the grid,
`(xi,yi,zi,ti)` is a *n*-element tuple containing the coordinates of the final grid,
`(x,y,z,t)` is a *n*-element tuple containing the coordinates of the observations,
`f` is the data anomalies (with respect to a background field),
`len` is the correlation length and
`epsilon2` is the error variance of the observations.

The call returns `fi`, the analyzed field on the grid `(xi,yi,zi,ti)`.

More examples are available in the notebooks from the [Diva Workshop](https://github.com/gher-ulg/Diva-Workshops).

## Note on which analysis function to use

`DIVAndrun` is the core analysis function in n dimensions. It does not know anything about the physical parameters or units you work with. Coordinates can also be very general. The only constraint is that the metrics `(pm,pn,po,...)` when multiplied by the corresponding length scales `len` lead to non-dimensional parameters. Furthermore the coordinates of the output grid `(xi,yi,zi,...)` need to have the same units as the observation coordinates `(x,y,z,...)`.

`DIVAndgo` is only needed for very large problems when a call to `DIVAndrun` leads to memory or CPU time problems. This function tries to decide which solver (direct or iterative) to use and how to make an automatic domain decomposition. Not all options from `DIVAndrun` are available.

`diva3D` is a higher-level function specifically designed for climatological analysis of data on Earth, using longitude/latitude/depth/time coordinates and correlations length in meters. It makes the necessary preparation of metrics, parameter optimizations etc you normally would program yourself before calling the analysis function `DIVAndrun`.


## Note about the background field

If zero is not a valid first guess for your variable (as it is the case for e.g. ocean temperature), you have to subtract the first guess from the observations before calling `DIVAnd` and then add the first guess back in.

## Determining the analysis parameters

The parameter `epsilon2` and parameter `len` are crucial for the analysis.

`epsilon2` corresponds to the inverse of the [signal-to-noise ratio](https://en.wikipedia.org/wiki/Signal-to-noise_ratio). `epsilon2` is the normalized variance of observation error (i.e. divided by the background error variance). Therefore, its value depends on how accurate and how representative the observations are.
`len` corresponds to the correlation length and the value of `len` can sometimes be determined by physical arguments. Note that there should be one correlation length per dimension of the analysis.

One statistical way to determine the parameter(s) is to do a [cross-validation](https://en.wikipedia.org/wiki/Cross-validation_%28statistics%29).

1. choose, at random, a relatively small subset of observations (about 5%). This is the validation data set.
2. make the analysis without your validation data set
3. compare the analysis to your validation data set and compute the RMS difference
4. repeat steps 2 and 3 with different values of the parameters and try to minimize the RMS difference.

You can repeat all steps with a different validation data set to ensure that the optimal parameter values are robust.
Tools to help you are included in  ([DIVAnd_cv.jl](https://github.com/gher-ulg/DIVAnd.jl/blob/master/src/DIVAnd_cv.jl)).


## Note about the error fields

`DIVAnd` allows the calculation of the analysis error variance, scaled by the background error variance. Though it can be calculated "exactly" using the diagonal of the error covariance matrix s.P, it is too costly and approximations are provided. Two version are recommended, `DIVAnd_cpme` for a quick estimate and `DIVAnd_aexerr` for a version closer the theoretical estimate (see [Beckers et al 2014](https://doi.org/10.1175/JTECH-D-13-00130.1) )

## Advanced usage

### Additional constraint

An arbitrary number of additional constraints can be included to the cost function which should have the following form:

*J*(**x**) = ∑<sub>*i*</sub> (**C**<sub>*i*</sub> **x**  - **z**<sub>*i*</sub>)ᵀ **Q**<sub>*i*</sub><sup>-1</sup> (**C**<sub>*i*</sub> **x** - **z**<sub>*i*</sub>)

For every constrain, a structure with the following fields is passed to `DIVAnd`:

* `yo`: the vector **z**<sub>*i*</sub>
* `H`: the matrix **C**<sub>*i*</sub>
* `R`: the matrix **Q**<sub>*i*</sub> (symmetric and positive defined)

Internally the observations are also implemented as constraint defined in this way.

## Run notebooks on a server which has no graphical interface

On the server, launch the notebook with:
```bash
jupyter-notebook --no-browser --ip='0.0.0.0' --port=8888
```
where the path to `jupyter-notebook` might have to be adapted, depending on your installation. The `ip` and `port` parameters can also be modified.

Then from the local machine it is possible to connect to the server through the browser.

Thanks to Lennert and Bart (VLIZ) for this trick.

# Example data

Some examples in `DIVAnd.jl` use a quite large data set which cannot be efficiently distributed through `git`. This data can be downloaded from the URL https://dox.ulg.ac.be/index.php/s/Bo01EicxnMgP9E3/download. The zip file should be decompressed and the directory `DIVAnd-example-data` should be placed on the same level than the directory `DIVAnd.jl`.

# Reporting issues

Please include the following information when reporting an issue:

* Version of Julia
* Version of DIVAnd
* Operating system
* Full screen output preferably obtained by setting `ENV["JULIA_DEBUG"] = "DIVAnd"`.
* Full stack strace with error message
* A short description of the problem
* The command and their arguments which produced the error

# Fun

An [educational web application](http://data-assimilation.net/Tools/divand_demo/html/) has been developed to reconstruct a field based on point "observations". The user must choose in an optimal way the location of 10 observations such that the analysed field obtained by `DIVAnd` based on these observations is as close as possible to the original field.
