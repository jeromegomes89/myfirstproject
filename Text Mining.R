## Text Mining ##
# http://obamaspeeches.com/
# http://mittromneycentral.com/speeches/
# Future project on Hillary And trump

# Pseudo Code to text analysis - Aplan of code to the approch.Pseudo means not genuine, sham or pretentious or insincere.
# Step 1: Initialize my invironment- i.e. what tare the libraries and directories that i will be using for thi project.
install.packages("tm")
install.packages("plyr")
library(tm)
vignette("tm")
library(plyr)
library(class)

options(stringsAsFactors = FALSE) # When we read text data into R it usually like to convert it from text to string character into nominal or categorival variable but we do not want to do this


# Step 2: Clean Text
# Corpus = is a collection of documents, we do all the clean of of the text at corpus level
# Function to clean corpus at one go instead of writing function again and again
# The first step in processing text data involves creating a corpus, which is a collection of text documents.

VCorpus() # refers to a volatile corpus-volatile as it is stored in memory
PCorpus() # refers to a permanent corpus-being stored on disk
VectorSource() # reader function to create a source object from the existing vector
readerControl() # a parameter to VCorpus() function which offers functionality to import text from sources such as PDFs and Microsoft Word files
inspect() # to get summary of specific messages
tolower() # converts to lower case
content_transformer() # transforms the content
getTransformations()
stopwords() # to see the list of all stop words
?stopwords #  to see the other languages and options available
removeWords() # removes the words
removePunctuation() # removes punctuation
stripWhitespace() # 
stemDocument #
# The final step is to split the messages into individual components through a process called tokenization. A token is a single element of a text string; in this case, the tokens are words.


CleanCorpus<- function(corpus) {
  corpus.
  
  
}


# Step 3: Build Term Document Matrix,TDM _converting text into a quantitative format that we can analyse


# Step 4: Attach Name to the matrix

# Step 5: Stack the matrixes on top of each other

# Step 6: Hold out Sample _Traning and Test data

# Step 7: Model Development _KNN

# Step 8: Accuracy
