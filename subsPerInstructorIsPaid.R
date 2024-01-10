#install.packages("forcats")

library(readxl)
library(dplyr)
library(ggplot2)
library(forcats)

df <- read_excel("C:/Users/sano/Downloads/udemyProject/Course_info.xlsx")

agg_data <- df %>%
  group_by(instructor_name, is_paid) %>%
  summarize(total_subscribers = sum(num_subscribers)) %>%
  arrange(instructor_name, desc(is_paid))

top_10_instructors <- agg_data %>%
  group_by(instructor_name) %>%
  summarize(total_subscribers = sum(total_subscribers)) %>%
  arrange(desc(total_subscribers)) %>%
  top_n(10)

agg_data <- agg_data %>%
  filter(instructor_name %in% top_10_instructors$instructor_name)

agg_data$instructor_name <- fct_reorder(agg_data$instructor_name, -agg_data$total_subscribers)

agg_data <- agg_data %>%
  group_by(instructor_name) %>%
  mutate(percentage_paid = sum(total_subscribers[is_paid == TRUE]) / sum(total_subscribers))

ggplot(agg_data, aes(x = instructor_name, y = total_subscribers, fill = is_paid)) +
  geom_bar(stat = "identity", position = "stack") +
  geom_text(aes(label = paste0(round(percentage_paid * 100), "%")),
            position = position_stack(vjust = 0.5), color = "white", size = 4, show.legend = FALSE) +
  scale_fill_manual(values = c("TRUE" = "purple", "FALSE" = "pink"), guide = guide_legend(title = "Is Paid")) +
  labs(title = "Top 10 Instructors by Subscribers (Paid vs. Free)",
       x = "Instructor Names",
       y = "Total Subscribers",
       fill = "Is Paid") +
  scale_y_continuous(labels = scales::comma) +  
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
