require(tm)        # corpus
require(SnowballC) # stemming

data_source <- DirSource(
  # indicate directory
  directory = file.path("data"),
  encoding = "UTF-8",     # encoding
  pattern = "*.txt",      # filename pattern
  recursive = FALSE,      # visit subdirectories?
  ignore.case = FALSE)    # ignore case in pattern?

data_corpus <- Corpus(
  data_source, 
  readerControl = list(reader = readPlain, language = "en"))   

# Convert to lower case
data_corpus <- tm_map(data_corpus, tolower)
# Remove punctuation
data_corpus <- tm_map(data_corpus, removePunctuation, preserve_intra_word_dashes = TRUE)
# Remove numbers
data_corpus <- tm_map(data_corpus, removeNumbers)
# Remove white space
data_corpus <- tm_map(data_corpus, stripWhitespace)
# Remove URLs
removeURL <- function(x) gsub("http[[:alnum:]]*", "", x)
data_corpus <- tm_map(data_corpus, removeURL)
# Remove Hyphens
removeHyphen <- function(x) gsub("*-*", "", x)
data_corpus <- tm_map(data_corpus, removeHyphen)
# Add two extra stop words: "available" and "via"
myStopwords <- c(stopwords('english'), stopwords('portuguese'))
# Remove stopwords from corpus
data_corpus <- tm_map(data_corpus, removeWords, myStopwords)
# Remove specific words
data_corpus <- tm_map(data_corpus, removeWords, 
                      c("two","on", "will", "can", "get", "that", "year", "let", "time",
                        "said", "like", "man", "first", "one", "look", "come", "make",
                        "thing", "old", "see", "person", "still", "also", "told", "kind"))
# Stem words
data_corpus <- tm_map(data_corpus, stemDocument, lang = "porter")

# Calculate Frequencies
# Control the number of letters is greater or equal to 4
data_tdm <- TermDocumentMatrix(data_corpus, control = list(wordLengths=c(4,Inf)))
# Convert TermDocumentMatrix to a matrix
data_matrix <- as.matrix(data_tdm)

data_df <- data.frame(
  word = rownames(data_matrix), 
  # necessary to call rowSums if have more than 1 document
  freq = rowSums(data_matrix),
  stringsAsFactors = FALSE)

# Sort by frequency
data_df <- data_df[with(
  data_df, 
  order(freq, decreasing = TRUE)), ]

# Do not need the row names anymore
rownames(data_df) <- NULL

# Check out final data frame
# View(data_df)



