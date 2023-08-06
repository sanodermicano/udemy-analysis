library(readxl)
library(dplyr)
library(ggplot2)

# Read the data
data <- read_excel("C:/Users/sano/Downloads/udemyProject/Course_info.xlsx")

# Separate the data by subscription type
free_courses <- data[data$is_paid == "FALSE", ]
paid_courses <- data[data$is_paid == "TRUE", ]

# Get the most popular topics for free courses
free_topics <- free_courses %>%
  count(topic) %>%
  top_n(10, wt = n)

# Get the most popular topics for paid courses
paid_topics <- paid_courses %>%
  count(topic) %>%
  top_n(10, wt = n)

# Combine the free and paid topics
all_topics <- rbind(free_topics, paid_topics)

# Add the is_paid column to the all_topics data frame
all_topics$is_paid <- c(rep("Free", nrow(free_topics)), rep("Paid", nrow(paid_topics)))

# Filter out rows with NA values in the "topic" column
all_topics <- all_topics %>%
  filter(!is.na(topic))

# Calculate the total count of each topic across both free and paid courses
topic_totals <- all_topics %>%
  group_by(topic) %>%
  summarise(total_count = sum(n)) %>%
  arrange(total_count)

# Reorder the levels of the "topic" factor based on the total count
all_topics$topic <- factor(all_topics$topic, levels = topic_totals$topic)

# Create a stacked bar chart
ggplot(all_topics, aes(x = topic, y = n, fill = is_paid)) +
  geom_bar(stat = "identity") +
  coord_flip() +
  labs(title = "Most Popular Topics (Free vs Paid)",
       x = "Subject",
       y = "Number of Courses")