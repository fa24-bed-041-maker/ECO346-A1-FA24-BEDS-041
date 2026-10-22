# ECO346 Assignment 1 - PSLM 2019-20 Data Analysis.
**Registration Number:** FA24-BEDS-041  
**Variant:** Punjab Urban  

## Overview
This repository contains the replication files, analysis scripts, and generated figures for examining annual earnings distribution and its relationship with age using the PSLM 2019-20 dataset for Urban Punjab.

## Key Findings

### 1. Earnings Distribution (Question 2)
* **Sample Size:** 3,743 earners (aged 15-64 in Urban Punjab after filtering valid earnings and excluding 25 outliers outside the Rs 10k–10m range).
* **Weighted Median Annual Earnings:** PKR 300,000
* **Weighted 90/10 Earnings Ratio:** 6.88 (indicating substantial earnings inequality within urban areas).

### 2. Age-Earnings Profile (Question 3)
* **Peak Earnings Band:** Age group **55-59** with a weighted mean annual earning of PKR 533,751.
* **Trend:** Earnings rise steadily through prime working age cohorts (reflecting accumulation of experience and skill) before declining near the retirement phase.

## Repository Structure
* `data/`: Contains filtered subset CSV files (`pslm_person_subset.csv`, `pslm_hh_subset.csv`).
* `scripts/`: Contains R scripts (`01_distribution.R`, `02_relationship.R`, `03_default.R`).
* `figures/`: Contains generated SVG visualizations (`distribution.svg`, `relationship.svg`, `default.svg`).
* `slides/`: Presentation slides.

## Makeover Explanation ( question 4 )
* The redesign transforms a cluttered scatter plot into an actionable analytical visual through three core principles:
# Overplotting Mitigation & Data Transparency:
*  Replacing solid black points with semi-transparent, horizontally jittered points reduces overplotting, making data density visible across age groups.
# Logarithmic Scaling:
Applying a $\log_{10}$ scale to annual earnings normalizes the heavily right-skewed income distribution, improving the perceptual ranking of high-earning observations.
# Conditional Summarization & Data-Ink Ratio: 
Adding weighted mean age-band markers joined by a line highlights the macro conditional age-earnings profile, maximizing relevant data-ink without visual noise.
# Trade-off:
While the redesign emphasizes overall trends and conditional means, it hides individual extreme earnings outliers and specific micro-level dispersion within each age band that were visible in the unsummarized default scatter plot.
