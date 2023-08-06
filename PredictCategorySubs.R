library(dplyr)
library(ggplot2)
library(readxl)
library(lubridate)

# Read the data
data <- read_excel("C:/Users/sano/Downloads/udemyProject/Course_info.xlsx")

# Convert published_time to Date type
data$published_time <- as.Date(data$published_time)

# Sort data by published_time (optional, to ensure chronological order)
data <- data %>% arrange(published_time)

# Create a sequence for future projections based on published_time
max_published_time <- max(data$published_time)
future_dates <- seq(max_published_time + days(1), length.out = 60, by = "months")
projection_data <- data.frame(published_time = future_dates)

# Add month_seq for linear regression to both data and projection_data
data$month_seq <- seq_along(data$published_time)
projection_data$month_seq <- seq_along(projection_data$published_time)

# Perform linear regression
lm_model <- lm(num_subscribers ~ month_seq, data = data)

# Perform the projection using the linear regression model
projection_data$num_subscribers <- predict(lm_model, newdata = projection_data)

# Combine the original data with the projection data
combined_data <- bind_rows(data, projection_data)

# Create the line chart
ggplot(combined_data, aes(x = published_time, y = num_subscribers)) +
  geom_line() +
  labs(title = "Number of Subscribers Over Time",
       x = "Published Time",
       y = "Number of Subscribers") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
