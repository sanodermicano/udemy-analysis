#install.packages(tm)
#install.packages(wordcloud)

library(tm)
library(wordcloud)
library(readxl)

data <- read_excel("C:/Users/sano/Downloads/udemyProject/Course_info.xlsx")

#corpus <- Corpus(VectorSource(data$title))
corpus <- Corpus(VectorSource(data$headline))

corpus <- tm_map(corpus, removePunctuation)
corpus <- tm_map(corpus, removeNumbers)
corpus <- tm_map(corpus, tolower)
corpus <- tm_map(corpus, removeWords, stopwords("english"))
corpus <- tm_map(corpus, removeWords, stopwords("spanish"))
corpus <- tm_map(corpus, removeWords, stopwords("french"))
corpus <- tm_map(corpus, removeWords, stopwords("russian"))
corpus <- tm_map(corpus, removeWords, stopwords("swedish"))
courseStopWords <- c("course", "courses", "lot", "die", "good", "great", "can", 
                     "thank", "thanks", "excellent", "curso", "muito", "like", 
                     "super", "bem", "learning", "way", "love", "bein", "things",
                     "best", "nice", "need", "awesome", "instructor", "instructors",
                     "recommend", "much", "found", "need", "really", "far", "bom",
                     "ive", "com", "kurs", "get", "feel", "first", "und", "life",
                     "excelente", "now", "bad", "terrible", "horrible", "teacher",
                     "amazing", "better", "will", "bir", "looking", "der", "video",
                     "make", "many", "point", "sehr", "ich", "also", "content", "yes",
                     "no", "çok", "learn", "highly", "help", "use", "videos", "want", 
                     "even", "time", "bien", "corso", "gut", "take", "one", 
                     "teaching", "well", "buena", "just", "mas", "buen", "every",
                     "udemy", "material", "class", "cours", "definitely", "makes",
                     "gracias", "très", "für", "ist", "concepts", "concept", "done",
                     "going", "go", "gone", "per", "das", "start", "got", "liked", ",",
                     "uma", "ser", "etc", "seems", "still", "however", "falta")
corpus <- tm_map(corpus, removeWords, courseStopWords)

wordcloud(corpus, max.words = 75, random.order = FALSE, colors = brewer.pal(8, "Dark2"), 
          width = 1280, height = 720, min.font.size = 8, scale = c(3, 1))
png("wordcloud_packages.png", width=12,height=8, units='in', res=300)
