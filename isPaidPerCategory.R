#install.packages("dplyr")
#install.packages("readxl")
#install.packages("ggplot2")

library(readxl)
library(ggplot2)
library(dplyr)


file_path <- "C:/Users/sano/Downloads/archive/Course_info.xlsx"  
data <- read_excel(file_path)

agg_data <- data %>%
  group_by(category, is_paid) %>%
  summarise(count = n()) %>%
  arrange(category, is_paid)

ggplot(agg_data, aes(x = category, y = count, fill = factor(is_paid))) +
  geom_bar(stat = "identity") +
  #geom_text(aes(label = count, vjust = ifelse(is_paid, -0.5, 1.5)), size = 3) +
  labs(y = "Total Count", fill = "Is Paid") +
  theme_minimal()
