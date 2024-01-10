library(readxl)
library(dplyr)
library(ggplot2)

data <- read_excel("C:/Users/sano/Downloads/udemyProject/Course_info.xlsx")

free_courses <- data[data$is_paid == "FALSE", ]
paid_courses <- data[data$is_paid == "TRUE", ]

free_topics <- free_courses %>%
  count(topic) %>%
  top_n(10, wt = n)

paid_topics <- paid_courses %>%
  count(topic) %>%
  top_n(10, wt = n)

all_topics <- rbind(free_topics, paid_topics)

all_topics$is_paid <- c(rep("Free", nrow(free_topics)), rep("Paid", nrow(paid_topics)))

all_topics <- all_topics %>%
  filter(!is.na(topic))

topic_totals <- all_topics %>%
  group_by(topic) %>%
  summarise(total_count = sum(n)) %>%
  arrange(total_count)

all_topics$topic <- factor(all_topics$topic, levels = topic_totals$topic)

ggplot(all_topics, aes(x = topic, y = n, fill = is_paid)) +
  geom_bar(stat = "identity") +
  coord_flip() +
  labs(title = "Most Popular Topics (Free vs Paid)",
       x = "Subject",
       y = "Number of Courses")
