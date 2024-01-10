#install.packages("dplyr")
#install.packages("readxl")
#install.packages("ggplot2")

library(dplyr)
library(readxl)
library(ggplot2)
data <- read_excel("C:/Users/sano/Downloads/udemyProject/Course_info.xlsx")

aggregated_data <- aggregate(content_length_min ~ instructor_name, data, sum)
aggregated_data <- aggregated_data[order(-aggregated_data$content_length_min), ]
top_10_instructors <- head(aggregated_data, 10)

chart <- ggplot(top_10_instructors, aes(x = reorder(instructor_name, -content_length_min), y = content_length_min, fill = instructor_name)) +
  geom_bar(stat = "identity") +
  labs(title = "Top 10 Instructors by Content Length",
       x = "Instructor Name",
       y = "Total Content Length (minutes)") +
  scale_y_continuous(labels = scales::comma) +  
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

print(chart)
