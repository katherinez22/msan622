require(wordcloud) # word cloud
source("data.r")   # get data

# Create Wordcloud
png(file.path("data_cloud.png"), width = 800, height = 600)

# Find the toal 50 counted words
cloud_df <- head(data_df, 50)

dev.new()
set.seed(375) # to make it reproducibles
# plot the word cloud
wordcloud(words = cloud_df$word, freq = cloud_df$freq,
          scale = c(5, 1.5),      # size of words
          min.freq = 100,          # drop infrequent
          max.words = 50,         # max words in plot
          random.order = FALSE,   # plot by frequency
          rot.per = 0.3,          # percent rotated
          # set colors
          colors = brewer.pal(9, "GnBu"),
#           colors = brewer.pal(12, "Paired"),
          # color random or by frequency
          random.color = TRUE,
          # use r or c++ layout
          use.r.layout = FALSE    
) # end wordcloud
dev.off()
