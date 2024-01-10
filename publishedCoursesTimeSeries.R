#install.packages("magrittr")
library(readxl)
library(ggplot2)
library(dplyr)
library(magrittr)

data <- read_excel("C:/Users/sano/Downloads/udemyProject/Course_info.xlsx")
data$published_time <- as.Date(data$published_time)
data$year <- format(data$published_time, "%Y")

agg_data <- data %>%
  group_by(year) %>%
  summarise(total_subscribers = sum(num_subscribers))

print(agg_data)
chart <- ggplot(agg_data, aes(x = year, y = total_subscribers, fill = year)) +
  geom_col() +
  labs(title = "Time Series Chart of Total Subscribers by Year",
       x = "Published Year",
       y = "Total Subscribers") +
  scale_y_continuous(labels = scales::comma) + 
  theme_minimal()

print(chart)
