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
* The `rstan`, `tidyverse`, and `MCMCvis` packages
  * Detailed instructions for installing the `rstan` package can be found [here](https://github.com/stan-dev/rstan/wiki/RStan-Getting-Started)
  * The [Stan forums](https://discourse.mc-stan.org) are a useful resource to help troubleshoot package installation issues


### Resources

Code for morning session can be found at [`Scripts_morning_session/`](Scripts_morning_session/):

* [`1-pdf.R`](Scripts_morning_session/1-pdf.R) - plot normal pdf
* [`2-globe.R`](Scripts_morning_session/2-globe.R) - grid approximation - globe model
* [`3-bird-simuation.R`](Scripts_morning_session/3-bird-simuation.R) - simulate bird data for linear regression
* [`4-fit-linear-bird-model.R`](Scripts_morning_session/4-fit-linear-bird-model.R) - simulate data then fit/assess linear regression
* [`4-linear-bird-model.stan`](Scripts_morning_session/4-linear-bird-model.stan) - Stan file (bird weight ~ bird food)
* [`5-var-int-simulation.R`](Scripts_morning_session/5-var-int-simulation.R) -simulate data for varying intercepts regression
* [`6-fit-var-int-bird-model.R`](Scripts_morning_session/6-fit-var-int-bird-model.R) - simulate data then fit/assess varying intercepts linear regression
* [`6-fit-var-int-bird-model.stan`](Scripts_morning_session/6-fit-var-int-bird-model.stan) - Stan file for varying intercepts model

