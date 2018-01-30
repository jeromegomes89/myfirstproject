###Text Analysis###

rm(list = ls()) ## Remove Data Sets in R
.libPaths("D:/R/library")
.libPaths()
getwd()
setwd("D:/R")

# Required packages for text analysis - The following are the required packages for text analysis each which will be explaind later on
install.packages("plyr", lib="D:/R/library")
install.packages("ggplot2", lib="D:/R/library") # data visualization libraries
install.packages("wordcloud", lib="D:/R/library") # for making wordcloud visualizations
install.packages("RColorBrewer", lib="D:/R/library")
install.packages("tm", lib="D:/R/library") # framework for text mining applications
install.packages("SnowballC", lib="D:/R/library") # text stemming library
install.packages("RSentiment", lib="D:/R/library") # sentiment analysis
install.packages("sentimentr", lib="D:/R/library") # sentiment analysis
install.packages("biclust", lib="D:/R/library")
install.packages("cluster", lib="D:/R/library")
install.packages("igraph", lib="D:/R/library")
install.packages("fpc", lib="D:/R/library")
install.packages("Syuzhet", lib="D:/R/library") # sentiment analysis
install.packages("quanteda", lib="D:/R/library") # N-grams

# Require the Packages
library("plyr", lib="D:/R/library")
library("ggplot2", lib="D:/R/library")
library("wordcloud", lib="D:/R/library")
library("RColorBrewer", lib="D:/R/library")
library("tm", lib="D:/R/library")
library("SnowballC", lib="D:/R/library")
library("RSentiment", lib="D:/R/library")
library("sentimentr", lib="D:/R/library")
library("biclust", lib="D:/R/library")
library("cluster", lib="D:/R/library")
library("igraph", lib="D:/R/library")
library("fpc", lib="D:/R/library")


## Source
https://rstudio-pubs-static.s3.amazonaws.com/265713_cbef910aee7642dc8b62996e38d2825d.html
cname <- ("D:/R/texts")
cname
dir("D:/R/texts")
dir(cname)

library(tm,lib="D:/R/library")
docs <- VCorpus(DirSource(cname))
summary(docs)
# For details about documents in the corpus, use the inspect(docs) command.
inspect(docs[2])
# read your documents in the R terminal
writeLines(as.character(docs[1]))

# Preprocessing of Data
# After each step of cleaning check the document if it worked or not.
# 1. Removing Punctuations
docs <- tm_map(docs,removePunctuation)
#you can remove special characters as an when according to the analysis Need
for (j in seq(docs)) {
  docs[[j]] <- gsub("/", " ", docs[[j]])
  docs[[j]] <- gsub("@", " ", docs[[j]])
  docs[[j]] <- gsub("\\|", " ", docs[[j]])
  docs[[j]] <- gsub("\u2028", " ", docs[[j]])  # This is an ascii character that did not translate, so it had to be removed.
}

# 2. Removing Numbers
docs <- tm_map(docs, removeNumbers)

# 3. Converting to lowercase
# we want a word to appear exactly the same every time it appears. We therefore change everything to lowercase.
docs <- tm_map(docs, tolower)
docs <- tm_map(docs, PlainTextDocument)
DocsCopy <- docs

# 4. Removing "stopwords" (common words) that usually have no analytic value.(a, and, also, the, etc.)
# For a list of the stopwords, see:   
length(stopwords("english"))   
stopwords("english") 
docs <- tm_map(docs, removeWords, stopwords("english"))
docs <- tm_map(docs, PlainTextDocument)

# 5. Removing particular words
#If you find that a particular word or two appear in the output, but are not of value to your particular analysis.
docs <- tm_map(docs, removeWords, c("syllogism", "tautology"))

# 6. Combining words that should stay together
# If you wish to preserve a concept is only apparent as a collection of two or more words, then you can combine them or reduce them to a meaningful acronym before you begin the analysis.
for (j in seq(docs))
{
  docs[[j]] <- gsub("fake news", "fake_news", docs[[j]])
  docs[[j]] <- gsub("inner city", "inner-city", docs[[j]])
  docs[[j]] <- gsub("politically correct", "politically_correct", docs[[j]])
}
docs <- tm_map(docs, PlainTextDocument)
writeLines(as.character(docs[1])) # Check to see if it worked.

# 7. Stripping unnecesary whitespace
docs <- tm_map(docs, stripWhitespace)
docs <- tm_map(docs, PlainTextDocument) # Finish the preprocessing stage with this function.

# 8. Stemming
#Stemming is the procedure of converting words to their base or root form. For example, playing, played, plays, etc, will be converted to play.
# Currently the "stem completion" function is currently problemmatic, and stemmed words are often annoying to read.
library(SnowballC)
docs_st <- tm_map(docs, stemDocument)
docs_st <- tm_map(docs_st, PlainTextDocument)
writeLines(as.character(docs_st[1])) # Check to see if it worked.
#   the stemCompletion function not being currently operational.
# Note: This code was not run for this particular example either.
#   Read it as a potential how-to.
docs_stc <- tm_map(docs_st, stemCompletion, dictionary = DocsCopy, lazy=TRUE)
docs_stc <- tm_map(docs_stc, PlainTextDocument)
writeLines(as.character(docs_stc[1])) # Check to see if it worked.

# After we get the clean corpus we need to change it into
# TermDocumentMatrix -- TDM has each corpus word represented as a row with documents as columns
# DocumentTermMatrix -- DTM has each document represented as a row with word as columns. A document term matrix (DTM) depicts the frequency of a word in its respective document.In this matrix, the rows are represented by documents and the columns are represented by words.

## Stage the Data
dtm <- DocumentTermMatrix(docs)
dtm # The summary of our DTM states that there are 11 documents and 3698 unique words. Hence, let's give a matrix with the dimensions of 11×3698, in which 79% of the rows have value 0.
inspect(dtm[1:5, 1:20]) #first 5 docs & first 20 terms
dim(dtm)

tdm <- TermDocumentMatrix(docs)
tdm

m <- as.matrix(dtm)
dim(m)
m1 <- as.data.frame(m)

freq <- colSums(as.matrix(dtm)) 
freq_tbl <- as.data.frame(freq)
head(freq_tbl)
length(freq)
ord <- order(freq)

## Focus - focusing on just the interesting stuff.
# The 'removeSparseTerms()' function will remove the infrequently used words, leaving only the most well-used words in the corpus.
dtms <- removeSparseTerms(dtm, 0.2) # This makes a matrix that is 20% empty space, maximum.
freq <- colSums(as.matrix(dtm))
head(table(freq), 20)

freq <- colSums(as.matrix(dtms))
freq <- sort(colSums(as.matrix(dtm)), decreasing=TRUE)   
head(freq, 14)
#Another Way
# This will identify all terms that appear frequently (in this case, 50 or more times).
findFreqTerms(dtm, lowfreq=50)
#Another Way
wf <- data.frame(word=names(freq), freq=freq)   
head(wf)  

## Plot Word Frequencies
library(ggplot2)
p <- ggplot(subset(wf, freq>50), aes(x = reorder(word, -freq), y = freq)) +
  geom_bar(stat = "identity") + 
  theme(axis.text.x=element_text(angle=45, hjust=1))
p

## Relationships Between Terms - Term Correlations
#If you have a term in mind that you have found to be particularly meaningful to your analysis, then you may find it helpful to identify the words that most highly correlate with that term.
findAssocs(dtm, c("country" , "american"), corlimit=0.85) # specifying a correlation limit of 0.85


## Word Clouds!
#Word Cloud is another way of representing the frequency of terms in a document. Here, the size of a word indicates its frequency in the document corpus.
set.seed(142)
wordcloud(names(freq), freq, min.freq=25)

wordcloud(names(freq), freq, max.words=100)

wordcloud(names(freq), freq, min.freq=20, scale=c(5, .1), colors=brewer.pal(6, "Dark2"))

## Clustering by Term Similarity - 
dtmss <- removeSparseTerms(dtm, 0.15)
library(cluster, lib="D:/R/library")
d <- dist(t(dtmss), method="euclidian")
d
fit <- hclust(d=d, method = "complete")
fit
plot(fit, hang = -1)
#To get a better idea of where the groups are in the dendrogram, you can also ask R to help identify the clusters. Here, I have arbitrarily chosen to look at five clusters, as indicated by the red boxes.
groups <- cutree(fit, k=6)   # "k=" defines the number of clusters you are using
rect.hclust(fit, k=6, border="red") # draw dendogram with red borders around the 6 clusters


## K-means clustering
library(fpc,lib="D:/R/library")
d <- dist(t(dtmss), method="euclidian")   
kfit <- kmeans(d, 2) 
clusplot(as.matrix(d), kfit$cluster, color=T, shade=T, labels=2, lines=0)

text analysis in r - https://www.springboard.com/blog/text-mining-in-r/
