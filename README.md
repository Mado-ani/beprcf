# BEPRCF: Bivariate ExOW-POLO Regression with Cure Fraction

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.XXXXXXX.svg
        
        
        
        )](https://doi.org/10.5281/zenodo.XXXXXXX
        
        
        
        )
[![License: CC BY 4.0](https://img.shields.io/badge/License-CC_BY_4.0-lightgrey.svg)](https://creativecommons.org/licenses/by/4.0/)

## Overview

This repository contains the code, data access instructions, and supplementary materials for the paper:

> **"Bivariate ExOW-POLO Regression with Cure Fraction and Bayesian Variable Selection: A Unified Framework for Paired Ophthalmic Survival Data"**
>
> *Statistical Methods in Medical Research*, 2026

The BEPRCF framework provides a unified approach for joint modeling of bilateral intraocular pressure (IOP) endpoints in longitudinal glaucoma trials, combining:

- **ExOW-POLO marginal distribution** (flexible five-parameter survival model)
- **Clayton copula** (inter-eye dependence)
- **Mixture cure model** (long-term IOP control)
- **Bayesian LASSO** (regularized variable selection)
- **Hamiltonian Monte Carlo** via Stan (efficient posterior computation)

## Repository Structure
