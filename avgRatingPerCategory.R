library(dplyr)
library(ggplot2)
library(readxl)

data <- read_excel("C:/Users/sano/Downloads/udemyProject/Course_info.xlsx")

average_ratings <- data %>%
  group_by(subcategory) %>%
  summarize(average_rating = mean(avg_rating)) %>%
  arrange(desc(average_rating))

ggplot(average_ratings, aes(x = average_rating, y = reorder(subcategory, -average_rating), fill = subcategory)) +
  geom_bar(stat = "identity", orientation = "y") +
  labs(title = "Average Rating by SubCategory",
       x = "Average Rating",
       y = "SubCategory") + 
  theme(axis.text.y = element_text(hjust = 0))

