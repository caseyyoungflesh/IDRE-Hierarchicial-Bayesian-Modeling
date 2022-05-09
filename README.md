# IDRE-Hierarchicial-Bayesian-Modeling

### What

Hierarchical Bayesian modeling with applications for spatial environmental data science (**1-day workshop**)


### When

May 6, 9am - 4pm (Pacific)

### Where

Virtual (register with UCLA Institute for Digital Research & Education [here](https://ucla.zoom.us/meeting/register/tJEsduqhqjktG9R4_YV0gj_IjFpK3Ae5H9Wm))


### Schedule

09:00 AM – 09:05 AM - Welcome and Introduction

09:05 AM – 12:00 PM - Intro to hierarchical Bayesian modeling using [Stan](https://mc-stan.org/) (Instructor: [Youngflesh](https://www.caseyyoungflesh.com/))

12:00 PM – 01: 00 PM - Lunch Break

01:00 PM – 04:00 PM - Hierarchical Bayesian modeling for spatial data science (Instructor: [Banerjee](http://sudipto.bol.ucla.edu/))


### Before the workshop begins

Parts of this workshop will be interactive. That is, you will fit Bayesian models on your own computers. To take advantage of these activities, please have the following installed on your computer before the start of the workshop:

* [RStudio](https://www.rstudio.com/)
* [R](https://www.r-project.org/)
* For the MORNING SESSION: The `rstan`, `tidyverse`, and `MCMCvis` packages
  * Install R packages with: `install.packages('rstan', 'tidyverse', 'MCMCvis')`
  * Detailed instructions for installing the `rstan` package can be found [here](https://github.com/stan-dev/rstan/wiki/RStan-Getting-Started)
  * The [Stan forums](https://discourse.mc-stan.org) are a useful resource to help troubleshoot package installation issues
* For the AFTERNOON SESSION: The `maps`, `spdep`, `maptools`, `classInt`, `RColorBrewer`, `MBA`, `fields`, `geoR`, `R2OpenBUGS`, `spatialreg`, `raster`, `leaflet`, and `sp` packages
  * Please install OpenBUGS before installing the `R2OpenBUGS` package from [here](https://www.mrc-bsu.cam.ac.uk/software/bugs/openbugs/). Instructions for installation of OpenBUGS on Mac can be found [here](https://oliviergimenez.github.io/blog/run_openbugs_on_mac/).
  * Install R packages with: `install.packages('maps', 'spdep', 'maptools', 'classInt', 'RColorBrewer', 'MBA', 'fields', 'geoR', 'R2OpenBUGS', 'spatialreg', 'raster', 'leaflet', 'sp')`
  


### Code

Code for the morning session can be found at [`Scripts/morning_session/`](Scripts/morning_session/):

* [`1-pdf.R`](Scripts/morning_session/1-pdf.R) - plot normal pdf
* [`2-globe.R`](Scripts/morning_session/2-globe.R) - grid approximation - globe model
* [`3-bird-simulation.R`](Scripts/morning_session/3-bird-simulation.R) - simulate bird data for linear regression
* [`4-fit-linear-bird-model.R`](Scripts/morning_session/4-fit-linear-bird-model.R) - simulate data then fit/assess linear regression
* [`4-linear-bird-model.stan`](Scripts/morning_session/4-linear-bird-model.stan) - Stan file (bird weight ~ bird food)
* [`5-var-int-simulation.R`](Scripts/morning_session/5-var-int-simulation.R) - simulate data for varying intercepts regression
* [`6-fit-var-int-bird-model.R`](Scripts/morning_session/6-fit-var-int-bird-model.R) - simulate data then fit/assess varying intercepts linear regression
* [`6-var-int-bird-model.stan`](Scripts/morning_session/6-var-int-bird-model.stan) - Stan file for varying intercepts model


Code and data for the afternoon session can be found at [`Scripts/afternoon_session/`](Scripts/afternoon_session/)


### Slides

Slides for the morning session can be found at [`Presentations/morning_session/`](Presentations/morning_session/)

Slides for the afternoon session can be found at [`Presentations/afternoon_session/`](Presentations/afternoon_session/)


### Presentation

A recording of the workshop in its entirity can be found [here](https://youtu.be/Ubsns37DD_U)
