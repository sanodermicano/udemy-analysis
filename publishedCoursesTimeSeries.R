#install.packages("magrittr")
library(readxl)
library(ggplot2)
library(dplyr)
library(magrittr)

# Read the Excel file
data <- read_excel("C:/Users/sano/Downloads/udemyProject/Course_info.xlsx")

# Convert published_time column to proper date format
data$published_time <- as.Date(data$published_time)

# Extract the year from the published_time column
data$year <- format(data$published_time, "%Y")

# Aggregate data by year and calculate the sum of num_subscribers
agg_data <- data %>%
  group_by(year) %>%
  summarise(total_subscribers = sum(num_subscribers))

# Print the aggregated data
print(agg_data)

# Create the time series-based chart using ggplot2
chart <- ggplot(agg_data, aes(x = year, y = total_subscribers, fill = year)) +
  geom_col() +
  labs(title = "Time Series Chart of Total Subscribers by Year",
       x = "Published Year",
       y = "Total Subscribers") +
  scale_y_continuous(labels = scales::comma) + 
  theme_minimal()

# Print the chart
print(chart)