install.packages("dplyr")
install.packages("readxl")
install.packages("ggplot2")

library(dplyr)
library(readxl)
library(ggplot2)
courses_data <- read_excel("C:/Users/sano/Downloads/udemyProject/Course_info.xlsx")
aggregated_data <- courses_data %>%
  group_by(category, is_paid) %>%
  summarise(num_subscribers = sum(num_subscribers)) %>%
  group_by(category) %>%
  mutate(percent_paid = num_subscribers / sum(num_subscribers))

ggplot(aggregated_data, aes(x = category, y = num_subscribers, fill = is_paid)) +
  geom_bar(stat = "identity") +
  geom_text(aes(label = ifelse(is_paid, scales::percent(percent_paid), "")),
            position = position_stack(vjust = 0.5)) +
  labs(title = "Subscribers by Course Category and Payment Status",
       x = "Course Category", y = "Total Subscribers") +
  scale_fill_discrete(name = "Is Paid", labels = c("Free", "Paid")) +
  scale_y_continuous(labels = scales::comma) +  
  theme_minimal()