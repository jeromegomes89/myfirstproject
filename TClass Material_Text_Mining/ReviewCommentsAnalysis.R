# Explicitely setting the working directory.
setwd("C:\\Users\\Biswajit\\Desktop\\Text_Mining_Class")

# Installing packages "SnowballC" & "tm" for performing text mining.
install.packages("SnowballC")
install.packages("tm")
library(SnowballC)
library(tm)

# Receiving the input from the dataset.
tm.data = read.csv("Review Comments.csv")
str(tm.data)

# Receiving a set of words with correct spelling for some of the misspelled and abbrevated words to demonstrate spell check.
correct.spelling = read.csv("spellchecker.csv" , header = F)
str(correct.spelling)

# Converting column Fedback to type character for further analysis.
tm.data$Fedback = as.character(tm.data$Fedback)

# Looping through the input and replacing some of the misspelled & abbrevated text.
for(i in 1:nrow(tm.data)) {
  temporary.data = tm.data[i,"Fedback"]
  for(j in 1:nrow(correct.spelling)) {
    temporary.data = gsub(as.character(correct.spelling$V1[j]), as.character(correct.spelling$V2[j]), temporary.data ,ignore.case=FALSE ,fixed = T )
  }
  tm.data[i,"Fedback"] = temporary.data
}

# Printing the object after processing. 
print(tm.data)

# Converting the input to a Corpus.
corpdata <- VCorpus(VectorSource(tm.data$Fedback))
inspect(corpdata)


# Removing whitespaces from the data.
corpdata_stripWhitespace <- tm_map(corpdata, stripWhitespace)
corpdata_stripWhitespace
inspect(corpdata_stripWhitespace)
writeLines(as.character(corpdata_stripWhitespace[[1]]))

# Fetching a list of common stopwords from the file "stopwords.csv".
own_stopwords = as.vector(as.matrix(read.csv(file="stopwords.csv")))
own_stopwords

# Removing common stopwords from the data.
corpdata_ownstop <- tm_map(corpdata_stripWhitespace, removeWords , own_stopwords)
writeLines(as.character(corpdata_ownstop[[1]]))

# Removing stopwords from the data.
corpdata_nostop <- tm_map(corpdata_ownstop, removeWords , stopwords("english"))
writeLines(as.character(corpdata_nostop[[1]]))

# Converting the data into lower case
corpdata_tolower = tm_map(corpdata_nostop , content_transformer(tolower))
writeLines(as.character(corpdata_tolower[[1]]))

# Removing punctuations from the data
corpdata_removepunctuation = tm_map(corpdata_tolower , content_transformer(function(data) {return (gsub("[[:punct:]]"," ", data))}))
writeLines(as.character(corpdata_removepunctuation[[1]]))

# Removing numbers from the data
corpdata_removenumbers = tm_map(corpdata_removepunctuation , content_transformer(removeNumbers))
writeLines(as.character(corpdata_removenumbers[[1]]))

# Performing Stemming on the data
corpdata_stemData = tm_map(corpdata_removenumbers , content_transformer(stemDocument) )
writeLines(as.character(corpdata_stemData[[1]]))

# Preparing the Term Document Matrix 
corpdata_tdm <- TermDocumentMatrix(corpdata_stemData , control= list(wordLengths=c(0,Inf)))
corpdata_tdm
inspect(corpdata_tdm)

# Display the terms with frequency between 3 & Inf
freqWords1 = findFreqTerms(corpdata_tdm,lowfreq=3,highfreq=Inf)
freqWords1
# Display the terms with frequency between 5 & Inf
freqWords2 = findFreqTerms(corpdata_tdm,lowfreq=5,highfreq=Inf)
freqWords2

# Display association among the given & other words 
findAssocs(corpdata_tdm,"idiots",0.6)
findAssocs(corpdata_tdm,"reading",0.5)

# Installing the packages to display the wordcloud
install.packages("wordcloud")
install.packages("RColorBrewer")
library("wordcloud")
library("RColorBrewer")

# Representing the Term Document Matrix data in the form of a Matrix 
matrix.data = as.matrix(corpdata_tdm)
head(matrix.data)

# Sorting the result after Summing the data across all columns / documents
word_freqs = sort(rowSums(matrix.data), decreasing = TRUE)
word_freqs

# Creating a data frame with words and their frequencies
wc.data = data.frame(word = names(word_freqs), freq = word_freqs)
str(wc.data)

# Creating a wordcloud
wordcloud(wc.data$word , wc.data$freq,  max.words=100 , random.order = T ,colors=brewer.pal(8, "Dark2") , scale=c(5,0.5))


# Performing sentiment analysis on the above data.

# Installing the packages to perform string manipulation
install.packages("stringr")
library(stringr)

# Receiving a list of Positive & Negative words from the disk
positive.words = as.vector(as.matrix(read.csv(file="positive_words.csv")))
positive.words
negative.words = as.vector(as.matrix(read.csv(file="negative_words.csv")))
negative.words


corpusT.data = NULL
# Tokenizing the words present in each sentense and creating a data frame.
for(i in 1:length(corpdata_stemData)) {
  corpusT.data[[i]] = unlist(lapply(as.character(corpdata_stemData[[i]]), scan_tokenizer))
}

# Function to calculate sentiment score at each document level.
calculateSentiment <- function (x) {
  
  # Finding the positive matches between the data
  positive.matches = match(x, positive.words)
  positive.matches
  # Finding the negative matches between the data
  negative.matches = match(x, negative.words)
  negative.matches
  
  # Calculating the positive & negative words count
  positive.count = sum(!is.na(positive.matches))
  positive.count
  negative.count = sum(!is.na(negative.matches))
  negative.count
  
  # Calculating the final score
  score = positive.count - negative.count
  score
}

# Calling the user defined function to return a sentiment score for each document.
sentiment.score = sapply(corpusT.data , calculateSentiment)
sentiment.score
# Calculating the aggregate score.
aggregate.score = sum(sentiment.score)
aggregate.score

# Calculating the positive & negative score.
positive.score = abs(sum(sentiment.score[which(sentiment.score >= 0)]))
negative.score = abs(sum(sentiment.score[which(sentiment.score < 0)]))

# Using a pie chart to plot the sentiments
pie(c(positive.score,negative.score),border="brown",col=c("green","red") , labels = c("Positive","Negative"))
