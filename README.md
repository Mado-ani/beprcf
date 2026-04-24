# BEPRCF: Bivariate ExOW-POLO Regression with Cure Fraction


[![License: CC BY 4.0](https://img.shields.io/badge/License-CC_BY_4.0-lightgrey.svg)](https://creativecommons.org/licenses/by/4.0/)

## Overview

This repository contains the code, data access instructions, and supplementary materials for the paper:

> **"Bivariate ExOW-POLO Regression with Cure Fraction and Bayesian Variable Selection: A Unified Framework for Paired Ophthalmic Survival Data"**
>
> 2026

The BEPRCF framework provides a unified approach for joint modeling of bilateral intraocular pressure (IOP) endpoints in longitudinal glaucoma trials, combining:

- **ExOW-POLO marginal distribution** (flexible five-parameter survival model)
- **Clayton copula** (inter-eye dependence)
- **Mixture cure model** (long-term IOP control)
- **Bayesian LASSO** (regularized variable selection)
- **Hamiltonian Monte Carlo** via Stan (efficient posterior computation)

## Repository Structure
beprcf/
├── README.md

├── LICENSE

├── CITATION.cff

├── .gitignore

├── paper/ # Manuscript source (to be added)

│ └── figures/

├── stan/ # Stan model files

│ ├── beprcf_model.stan

│ └── beprcf_sensitivity.stan

├── R/ # Analysis and simulation scripts

│ ├── 01_simulation_study.R

│ ├── 02_ohts_analysis.R

│ ├── 03_figures_tables.R

│ ├── 04_sensitivity_analysis.R

│ ├── 05_misspecification.R

│ └── utils.R

├── data/ # Data access information

│ └── README.md

├── results/ # Processed results

└── supplementary/ # Supplementary materials



## Quick Start

bash
git clone https://github.com/Mado-ani/beprcf.git

## Prerequisites
R ≥ 4.3.0

Stan ≥ 2.33

Required R packages: rstan, survival, flexsurv, copula, ggplot2, dplyr

## Install Dependencies

# Simulation study
source("R/01_simulation_study.R")
results <- run_simulation()

# OHTS analysis (requires dbGaP access)
source("R/02_ohts_analysis.R")
fit <- analyze_ohts_data("data/processed/")

## Reproducing Results
# Simulation study
source("R/01_simulation_study.R")
results <- run_simulation()

# OHTS analysis (requires dbGaP access)
source("R/02_ohts_analysis.R")
fit <- analyze_ohts_data("data/processed/")

## Data Availability
The OHTS data are available through the NIH Database of Genotypes and Phenotypes (dbGaP, accession phs000240.v1.p1) under authorized access procedures. See data/README.md for detailed instructions.

## Acknowledgments
The Ocular Hypertension Treatment Study was supported by awards from the National Eye Institute (EY09341, EY09307), the National Center on Minority Health and Health Disparities, NIH, the Horncrest Foundation, Research to Prevent Blindness, Inc., Merck Research Laboratories, and Pfizer, Inc.





