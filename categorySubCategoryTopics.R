#install.packages("dplyr")
#install.packages("readxl")
#install.packages("ggplot2")
#install.packages("sunburstR")
#install.packages("tm")
#install.packages("wordcloud")

library(readxl)
library(tm)
library(wordcloud)


file_path <- "C:/Users/sano/Downloads/archive/Course_info.xlsx"  

data <- read.csv(file_path)  # Use appropriate function for reading CSV, Excel, etc., based on your data format

# Create a corpus from the 'headline' column
corpus <- Corpus(VectorSource(data$headline))

# Preprocessing: Convert to lowercase, remove punctuation, numbers, and common English stopwords
corpus <- tm_map(corpus, content_transformer(tolower))
corpus <- tm_map(corpus, removePunctuation)
corpus <- tm_map(corpus, removeNumbers)
corpus <- tm_map(corpus, removeWords, stopwords("english"))

# Remove additional custom stopwords if needed
# custom_stopwords <- c("word1", "word2", "word3")
# corpus <- tm_map(corpus, removeWords, custom_stopwords)

# Create a term-document matrix
tdm <- TermDocumentMatrix(corpus)

# Get word frequencies
word_freq <- rowSums(as.matrix(tdm))

# Sort words by frequency in descending order
sorted_word_freq <- sort(word_freq, decreasing = TRUE)

valid_indices <- sorted_word_freq > 0

# Create a word cloud using the most common words
if (any(valid_indices)) {
  # Create a word cloud using the most common words
  wordcloud(words = names(sorted_word_freq[valid_indices]),
            freq = sorted_word_freq[valid_indices],
            min.freq = 50,  # Minimum frequency for a word to appear in the word cloud
            colors = brewer.pal(8, "Dark2"))
} else {
  cat("No valid words to display in the word cloud.")
}