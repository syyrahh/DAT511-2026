#2024 NOAA Storm Database Final Project - Syeda Rahmani

#Loading Libraries
library(dplyr)
library(readr)
library(ggplot2)

#Set project folder
folder_path <- "."
data_path <- file.path(folder_path, "storm data")

#Finding the three 2024 CSV files automatically
find_storm_file <- function(type) {
  pattern <- paste0(
    "^StormEvents_", type,
    "-ftp_v1[.]0_d2024_c[0-9]{8}[.]csv$"
  )
  
  files <- list.files(
    data_path,
    pattern = pattern,
    full.names = TRUE
  )
  
  if (length(files) != 1) {
    stop(paste("Expected one", type,
               "file. Found:", length(files)))
  }
  
  files
}

details_file <- find_storm_file("details")
fatalities_file <- find_storm_file("fatalities")
locations_file <- find_storm_file("locations")

#Checking that all three have the same creation date
creation_dates <- sub(
  ".*_c([0-9]{8})[.]csv$", "\\1",
  basename(c(details_file, fatalities_file, locations_file))
)

stopifnot(length(unique(creation_dates)) == 1)

#Loading raw data
details <- read_csv(details_file, show_col_types = FALSE)
fatalities <- read_csv(fatalities_file, show_col_types = FALSE)
locations <- read_csv(locations_file, show_col_types = FALSE)

cat("Details rows:", nrow(details), "\n")
cat("Fatalities rows:", nrow(fatalities), "\n")
cat("Locations rows:", nrow(locations), "\n")

#Combine the files using EVENT_ID
#First keep a unique event-level reference from details.
#The full join will be saved separately for inspection.

joined_data <- details %>%
  left_join(
    locations,
    by = "EVENT_ID",
    relationship = "many-to-many"
  ) %>%
  left_join(
    fatalities,
    by = "EVENT_ID",
    relationship = "many-to-many"
  )

write_csv(
  joined_data,
  file.path(folder_path, "StormEvents_joined_data.csv")
)


stopifnot(!anyDuplicated(details$EVENT_ID))

#Preparing the event-level analysis data
storm <- details %>%
  mutate(
    BEGIN_DATE = as.Date(
      as.character(BEGIN_DATE_TIME),
      tryFormats = c(
        "%d-%b-%y %H:%M:%S",
        "%m/%d/%Y %H:%M:%S",
        "%m/%d/%Y"
      )
    ),
    
    MONTH = as.integer(format(BEGIN_DATE, "%m")),
    
    MONTH_NAME = factor(
      month.abb[MONTH],
      levels = month.abb
    ),
    
    DEATHS_DIRECT = coalesce(DEATHS_DIRECT, 0),
    DEATHS_INDIRECT = coalesce(DEATHS_INDIRECT, 0),
    
    INJURIES_DIRECT = coalesce(INJURIES_DIRECT, 0),
    INJURIES_INDIRECT = coalesce(INJURIES_INDIRECT, 0),
    
    TOTAL_FATALITIES =
      DEATHS_DIRECT + DEATHS_INDIRECT,
    
    TOTAL_INJURIES =
      INJURIES_DIRECT + INJURIES_INDIRECT
  )

#NOAA damage amounts may contain K, M, or B suffixes - Converting them into dollars.

convert_damage <- function(x) {
  x <- toupper(trimws(as.character(x)))
  number <- suppressWarnings(
    as.numeric(sub("([KMB])$", "", x))
  )
  
  suffix <- ifelse(
    grepl("[KMB]$", x),
    sub(".*([KMB])$", "\\1", x),
    ""
  )
  
  multiplier <- case_when(
    suffix == "K" ~ 1000,
    suffix == "M" ~ 1000000,
    suffix == "B" ~ 1000000000,
    TRUE ~ 1
  )
  
  number * multiplier
}

storm <- storm %>%
  mutate(
    PROPERTY_DAMAGE_USD = convert_damage(DAMAGE_PROPERTY)
  )

#Question 1 - Population health
health_results <- storm %>%
  group_by(EVENT_TYPE) %>%
  summarise(
    Fatalities = sum(TOTAL_FATALITIES, na.rm = TRUE),
    Injuries = sum(TOTAL_INJURIES, na.rm = TRUE),
    Total_Harm = Fatalities + Injuries,
    .groups = "drop"
  ) %>%
  arrange(desc(Total_Harm))

print(head(health_results, 10))

plot1 <- health_results %>%
  slice_max(Total_Harm, n = 10) %>%
  ggplot(aes(
    x = reorder(EVENT_TYPE, Total_Harm),
    y = Total_Harm
  )) +
  geom_col(fill = "steelblue") +
  coord_flip() +
  labs(
    title = "Top 10 Weather Events by Deaths and Injuries",
    x = "Weather Event Type",
    y = "Total Deaths and Injuries",
    caption = "Source: NOAA Storm Events Database, 2024"
  ) +
  theme_minimal()

print(plot1)

#Question 2 - Events by state
state_results <- storm %>%
  count(STATE, EVENT_TYPE, name = "Event_Count") %>%
  arrange(STATE, desc(Event_Count), EVENT_TYPE)

top_state_events <- state_results %>%
  group_by(STATE) %>%
  slice_max(Event_Count, n = 1, with_ties = FALSE) %>%
  ungroup()

print(top_state_events, n = 60)

#Showing the most frequently recorded events nationwide
national_frequency <- storm %>%
  count(EVENT_TYPE, sort = TRUE)

plot2 <- national_frequency %>%
  slice_head(n = 10) %>%
  ggplot(aes(
    x = reorder(EVENT_TYPE, n),
    y = n
  )) +
  geom_col(fill = "darkorange") +
  coord_flip() +
  labs(
    title = "Most Frequently Recorded Weather Events",
    x = "Weather Event Type",
    y = "Number of Events",
    caption = "Source: NOAA Storm Events Database, 2024"
  ) +
  theme_minimal()

print(plot2)

#Question 3 - Events by month
monthly_results <- storm %>%
  filter(!is.na(MONTH_NAME)) %>%
  count(MONTH_NAME, EVENT_TYPE, name = "Event_Count")

top_month_events <- monthly_results %>%
  group_by(MONTH_NAME) %>%
  slice_max(Event_Count, n = 1, with_ties = FALSE) %>%
  ungroup()

print(top_month_events, n = 12)

#Heatmap of top 10 nationwide event types by month
top_types <- national_frequency %>%
  slice_head(n = 10) %>%
  pull(EVENT_TYPE)

plot3 <- monthly_results %>%
  filter(EVENT_TYPE %in% top_types) %>%
  ggplot(aes(
    x = MONTH_NAME,
    y = EVENT_TYPE,
    fill = Event_Count
  )) +
  geom_tile(color = "white") +
  scale_fill_gradient(
    low = "lightyellow",
    high = "darkred"
  ) +
  labs(
    title = "Weather Event Frequency by Month",
    x = "Month",
    y = "Weather Event Type",
    fill = "Events",
    caption = "Source: NOAA Storm Events Database, 2024"
  ) +
  theme_minimal()

print(plot3)

#Question 4 - Property damage
damage_results <- storm %>%
  group_by(EVENT_TYPE) %>%
  summarise(
    Total_Damage = sum(
      PROPERTY_DAMAGE_USD,
      na.rm = TRUE
    ),
    .groups = "drop"
  ) %>%
  arrange(desc(Total_Damage))

print(head(damage_results, 10))

plot4 <- damage_results %>%
  slice_max(Total_Damage, n = 10) %>%
  ggplot(aes(
    x = reorder(EVENT_TYPE, Total_Damage),
    y = Total_Damage / 1e9
  )) +
  geom_col(fill = "seagreen") +
  coord_flip() +
  labs(
    title = "Top 10 Weather Events by Property Damage",
    x = "Weather Event Type",
    y = "Estimated Property Damage (Billions USD)",
    caption = "Source: NOAA Storm Events Database, 2024"
  ) +
  theme_minimal()

print(plot4)

#Save results and figures
results_path <- file.path(folder_path, "results")
dir.create(results_path, showWarnings = FALSE)

write_csv(health_results,
          file.path(results_path, "health_results.csv"))
write_csv(top_state_events,
          file.path(results_path, "top_state_events.csv"))
write_csv(top_month_events,
          file.path(results_path, "top_month_events.csv"))
write_csv(damage_results,
          file.path(results_path, "damage_results.csv"))

ggsave(file.path(results_path, "figure1_health.png"),
       plot1, width = 9, height = 6)
ggsave(file.path(results_path, "figure2_frequency.png"),
       plot2, width = 9, height = 6)
ggsave(file.path(results_path, "figure3_months.png"),
       plot3, width = 9, height = 6)
ggsave(file.path(results_path, "figure4_damage.png"),
       plot4, width = 9, height = 6)

message("NOAA analysis completed!")

