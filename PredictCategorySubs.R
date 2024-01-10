library(dplyr)
library(ggplot2)
library(readxl)
library(lubridate)

data <- read_excel("C:/Users/sano/Downloads/udemyProject/Course_info.xlsx")

data$published_time <- as.Date(data$published_time)

data <- data %>% arrange(published_time)

max_published_time <- max(data$published_time)
future_dates <- seq(max_published_time + days(1), length.out = 60, by = "months")
projection_data <- data.frame(published_time = future_dates)

data$month_seq <- seq_along(data$published_time)
projection_data$month_seq <- seq_along(projection_data$published_time)

lm_model <- lm(num_subscribers ~ month_seq, data = data)

projection_data$num_subscribers <- predict(lm_model, newdata = projection_data)

combined_data <- bind_rows(data, projection_data)

ggplot(combined_data, aes(x = published_time, y = num_subscribers)) +
  geom_line() +
  labs(title = "Number of Subscribers Over Time",
       x = "Published Time",
       y = "Number of Subscribers") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
