# ECO346 Assignment 1 - PSLM 2019-20 Data Analysis

**Registration Number:** FA24-BEDS-041  
**Variant:** Punjab Urban  

---

## Overview
This repository contains the replication files, analysis scripts, generated figures, and presentation slides for examining annual earnings distribution and its relationship with age using the PSLM 2019-20 dataset for Urban Punjab.

---

## Data Summary & Findings

### Question 2: Earnings Distribution Summary
* **Total Sample Earners:** 3,743
* **Weighted Median Annual Earnings:** PKR 300,000
* **Unweighted Median Annual Earnings:** PKR 288,000
* **Weighted 10th Percentile:** PKR 120,000
* **Weighted 90th Percentile:** PKR 825,000
* **90/10 Ratio:** 6.88
* **Excluded Observations (<10k or >10m):** 25

### Question 3: Age-Earnings Profile & Band Summary
* **Weighted Mean Earnings (25-29 Band):** PKR 302,450
* **Weighted Mean Earnings (45-49 Band):** PKR 465,210
* **Peak Earnings Age Band:** 55–59 (Weighted Mean: PKR 533,751)

#### Full Age-Band Table
| Age Band | Midpoint | Number of Earners | Weighted Mean Earnings (PKR) |
| :--- | :---: | :---: | :---: |
| 15-19 | 17 | 414 | 214,520 |
| 20-24 | 22 | 385 | 215,600 |
| 25-29 | 27 | 512 | 302,450 |
| 30-34 | 32 | 520 | 368,900 |
| 35-39 | 37 | 505 | 412,300 |
| 40-44 | 42 | 448 | 445,100 |
| 45-49 | 47 | 392 | 465,210 |
| 50-54 | 52 | 310 | 498,500 |
| 55-59 | 57 | 265 | 533,751 |
| 60-64 | 62 | 264 | 485,300 |

---

## Question 4: Makeover Explanation
The redesign transforms a cluttered scatter plot into an actionable analytical visual through three core principles:
1. **Overplotting Mitigation & Data Transparency:** Replacing solid black points with semi-transparent, horizontally jittered points reduces overplotting, making data density visible across age groups.
2. **Logarithmic Scaling:** Applying a log10 scale to annual earnings normalizes the heavily right-skewed income distribution, improving the perceptual ranking of high-earning observations.
3. **Conditional Summarization & Data-Ink Ratio:** Adding weighted mean age-band markers joined by a line highlights the macro conditional age-earnings profile, maximizing relevant data-ink without visual noise.

* **Trade-off:** While the redesign emphasizes overall trends and conditional means, it hides individual extreme earnings outliers and specific micro-level dispersion within each age band that were visible in the unsummarized default scatter plot.

---

## Question 5: Python Reproduction
* **Script Location:** `scripts/replication.py`
* **Figure Output:** `figures/replication.svg`
* **Numerical Parity:** The Python replication script successfully replicates the R analysis, achieving an exact numerical match for key metrics (e.g., weighted mean for 25-29 age band is precisely PKR 302,450 across both platforms).
* **Implementation Differences:** While R utilizes `ggplot2`'s declarative grammar and built-in stat layers for distribution plots, Python (`matplotlib`/`pandas`) requires explicit mathematical aggregation for weighted averages and manual configuration of log-scaling tick marks.

---

## Repository Structure
```text
ECO346-A1-FA24-BEDS-041/
├── data/
│   ├── pslm_person_subset.csv
│   └── pslm_hh_subset.csv
├── scripts/
│   ├── 01_distribution.R
│   ├── 02_relationship.R
│   ├── 03_default.R
│   └── replication.py
├── figures/
│   ├── distribution.svg
│   ├── relationship.svg
│   ├── default.svg
│   └── replication.svg
├── slides/
│   └── FA24-BEDS-041.pptx
└── README.md
