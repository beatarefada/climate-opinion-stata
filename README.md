# Climate Opinion Analysis (Stata)

## Overview
This repository contains an independent exploratory data analysis (EDA) using the dataset provided by Howe et al. (2015). The project investigates the "Value-Action Gap" in the Northeast United States—specifically analyzing why high belief in climate change does not always correlate with support for policy interventions like Renewable Portfolio Standards (RPS).

## Data Source
* **Primary Data:** Howe, P. D., Mildenberger, M., Marlon, J. R., & Leiserowitz, A. (2015). "Geographic variation in opinions on climate change at state and local scales in the USA." *Nature Climate Change*.
* **Access:** The script pulls the raw survey data directly from the public source URL.

## Analysis Goals
This script demonstrates Stata proficiency through:
1.  **Data Cleaning:** Importing raw CSVs, handling missing values, and standardizing string variables.
2.  **Regional Segmentation:** Grouping US states into 5 macro-regions using `replace` and `inlist` logic.
3.  **Hypothesis Testing:** Running OLS regressions with robust standard errors to estimate the relationship between social discussion (family/friends) and policy support.

## File Structure
* `analysis.do`: The complete Stata script (data import to regression output).

## Usage
To run the analysis:
1. Open Stata.
2. Open `analysis.do`.
3. Run the script (Ctrl+D). No local file downloads are required.
