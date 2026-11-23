#2024 NOAA Storm Events Analysis — Syeda Rahmani

##Project Overview

This project analyzes severe weather events recorded in the United States during 2024 using data from the National Oceanic and Atmospheric Administration (NOAA) Storm Events Database.

The purpose of this project is to examine how different types of severe weather affected population health, how weather events varied across states and months, and which events caused the greatest estimated property damage.

##Research Questions

1. Which weather event types caused the greatest number of deaths and injuries?
2. Which weather events were most frequently recorded in different states?
3. Which weather events were most common during different months?
4. Which weather event types caused the greatest estimated property damage?

##Dataset

The project uses three NOAA Storm Events datasets for 2024:

- Storm Events Details
- Storm Events Fatalities
- Storm Events Locations

The datasets were joined using the `EVENT_ID` variable. The event details dataset was used for event-level analysis to avoid duplicate counting.

Data source: https://www.ncei.noaa.gov/pub/data/swdi/stormevents/csvfiles/

## ools and Libraries

The analysis was completed in RStudio using R and the following libraries:

- `dplyr`
- `readr`
- `ggplot2`
- `knitr`
- `rmarkdown`

##Project Files

- `NOAA_Analysis_RAHMANI.R` — R script for data loading, cleaning, analysis, and visualizations.
- `NOAA_Analysis_RAHMANI.Rmd` — R Markdown report containing the analysis and findings.
- `StormEvents_joined_data.csv` — Combined NOAA dataset.
- `storm data/` — Original NOAA CSV files.
- `results/` — Generated summary tables and figures.

##Key Findings

- Tornadoes caused the highest combined number of deaths and injuries.
- Thunderstorm wind was the most frequently recorded event type in many states.
- Winter weather was common during colder months, while thunderstorm wind was frequently recorded during spring and summer.
- Hurricanes and typhoons caused the greatest estimated property damage.

##Reproducing the Analysis

1. Download the three 2024 NOAA Storm Events CSV files.
2. Place them inside the `storm data` folder.
3. Open the project in RStudio.
4. Install the required R packages if needed.
5. Run `NOAA_Analysis_RAHMANI.R` to generate the analysis results.
6. Open `NOAA_Analysis_RAHMANI.Rmd` and knit the report to HTML.

The R script uses relative file paths, so the working directory must be configured to match the folder structure.

##Report

RPubs report: https://rpubs.com/rahmanis/NOAA-Storm-Events-2024-DAT11

##Author

Syeda Rahmani

DAT 511 — Storm Data Analysis Final Project
