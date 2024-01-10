library(readxl)
library(tm)
library(wordcloud)


file_path <- "C:/Users/sano/Downloads/archive/Course_info.xlsx"  

data <- read.csv(file_path) 

corpus <- Corpus(VectorSource(data$headline))

corpus <- tm_map(corpus, content_transformer(tolower))
corpus <- tm_map(corpus, removePunctuation)
corpus <- tm_map(corpus, removeNumbers)
corpus <- tm_map(corpus, removeWords, stopwords("english"))

# custom_stopwords <- c("word1", "word2", "word3")
# corpus <- tm_map(corpus, removeWords, custom_stopwords)

tdm <- TermDocumentMatrix(corpus)
word_freq <- rowSums(as.matrix(tdm))
sorted_word_freq <- sort(word_freq, decreasing = TRUE)

valid_indices <- sorted_word_freq > 0

if (any(valid_indices)) {
  wordcloud(words = names(sorted_word_freq[valid_indices]),
            freq = sorted_word_freq[valid_indices],
            min.freq = 50,
            colors = brewer.pal(8, "Dark2"))
} else {
  cat("No valid words to display in the word cloud.")
}
