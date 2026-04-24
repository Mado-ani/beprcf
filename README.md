# BEPRCF: Bivariate ExOW-POLO Regression with Cure Fraction



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
