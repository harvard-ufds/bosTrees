
<!-- README.md is generated from README.Rmd. Please edit that file -->

# bosTrees

<!-- badges: start -->
<!-- badges: end -->

`bosTrees` is a data package that contains information on trees and tree
planting sites in Boston, Massachusetts. This package includes two
distinct datasets, each offering unique insights into the urban forestry
of Boston:

- `bosTrees` pulls in data on 6,836 primary street trees located
  throughout Boston.

- `camTrees` pulls in data on 38,050 trees and tree planting sites
  owned, planted or maintained by the City of Cambridge, the
  Massachusetts Department of Conservation and Recreation, and MIT,
  Harvard University and other private organizations

The data pulled for `camTrees` is maintained by the Cambridge Public
Works and updated regularly by the City Arborist while the `bosTrees`
dataset was created by the City of Boston’s GIS Team.

## Installation

``` r
# Do the following once
# install.packages("devtools")

# Then, install the package
devtools::install_github("harvard-ufds/bosTrees")
```

## Example \[to be edited\]

This is a basic example which shows you how to solve a common problem:

``` r
install.packages("devtools")
#> Installing package into '/private/var/folders/mp/vd1ynsh93v51m1fmz6n99n440000gn/T/RtmpZhzTnQ/temp_libpathf00917803483'
#> (as 'lib' is unspecified)
#> 
#> The downloaded binary packages are in
#>  /var/folders/mp/vd1ynsh93v51m1fmz6n99n440000gn/T//RtmpoJzpwv/downloaded_packages
devtools::install_github("harvard-ufds/bosTrees")
#> Downloading GitHub repo harvard-ufds/bosTrees@HEAD
#> ── R CMD build ─────────────────────────────────────────────────────────────────
#> * checking for file ‘/private/var/folders/mp/vd1ynsh93v51m1fmz6n99n440000gn/T/RtmpoJzpwv/remotesf4339998b4d/harvard-ufds-bosTrees-b96f783/DESCRIPTION’ ... OK
#> * preparing ‘bosTrees’:
#> * checking DESCRIPTION meta-information ... OK
#> * checking for LF line-endings in source and make files and shell scripts
#> * checking for empty or unneeded directories
#> * building ‘bosTrees_0.0.0.9000.tar.gz’
#> Installing package into '/private/var/folders/mp/vd1ynsh93v51m1fmz6n99n440000gn/T/RtmpZhzTnQ/temp_libpathf00917803483'
#> (as 'lib' is unspecified)
library(bosTrees)
library(tidyverse)
#> ── Attaching core tidyverse packages ──────────────────────── tidyverse 2.0.0 ──
#> ✔ dplyr     1.1.2     ✔ readr     2.1.4
#> ✔ forcats   1.0.0     ✔ stringr   1.5.0
#> ✔ ggplot2   3.4.2     ✔ tibble    3.2.1
#> ✔ lubridate 1.9.2     ✔ tidyr     1.3.0
#> ✔ purrr     1.0.1
#> ── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──
#> ✖ dplyr::filter() masks stats::filter()
#> ✖ dplyr::lag()    masks stats::lag()
#> ℹ Use the conflicted package (<http://conflicted.r-lib.org/>) to force all conflicts to become errors
## basic example code

exampleplot<-camTrees %>%
  filter(Longitude > -71.13, Longitude < -71.11, Latitude > 42.359, Latitude < 42.375) %>%
ggplot(aes(x = Longitude, y = Latitude, color = Ownership)) +
  geom_point() +
  xlim(-71.13, -71.11) +
  ylim(42.359, 42.375) +
  labs(title = "Ownership of Trees alongside Charles River on Harvard's Campus")

exampleplot
```

<img src="man/figures/README-example-1.png" width="100%" />

What is special about using `README.Rmd` instead of just `README.md`?
You can include R chunks like so:

``` r
summary(cars)
#>      speed           dist       
#>  Min.   : 4.0   Min.   :  2.00  
#>  1st Qu.:12.0   1st Qu.: 26.00  
#>  Median :15.0   Median : 36.00  
#>  Mean   :15.4   Mean   : 42.98  
#>  3rd Qu.:19.0   3rd Qu.: 56.00  
#>  Max.   :25.0   Max.   :120.00
```

You’ll still need to render `README.Rmd` regularly, to keep `README.md`
up-to-date. `devtools::build_readme()` is handy for this. You could also
use GitHub Actions to re-render `README.Rmd` every time you push. An
example workflow can be found here:
<https://github.com/r-lib/actions/tree/v1/examples>.

You can also embed plots, for example:

<img src="man/figures/README-pressure-1.png" width="100%" />

In that case, don’t forget to commit and push the resulting figure
files, so they display on GitHub and CRAN.
