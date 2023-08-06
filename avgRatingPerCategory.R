library(dplyr)
library(ggplot2)
library(readxl)

# Read the data
data <- read_excel("C:/Users/sano/Downloads/udemyProject/Course_info.xlsx")

# Calculate the average rating for each subcategory
average_ratings <- data %>%
  group_by(subcategory) %>%
  summarize(average_rating = mean(avg_rating)) %>%
  arrange(desc(average_rating))

# Create a horizontal bar chart of the average ratings
ggplot(average_ratings, aes(x = average_rating, y = reorder(subcategory, -average_rating), fill = subcategory)) +
  geom_bar(stat = "identity", orientation = "y") +
  labs(title = "Average Rating by SubCategory",
       x = "Average Rating",
       y = "SubCategory") + 
  theme(axis.text.y = element_text(hjust = 0))  # Adjusts the horizontal alignment of y-axis labels

