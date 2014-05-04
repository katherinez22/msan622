data <- read.csv("NamesOf50States.csv")

# Words Cloud
require(wordcloud) # word cloud

# Find the toal 10 counted words
indices <- which(data$State == "CA" & 
                 data$Year == 2002 &
                 data$Sex == "F")
cloud_df <- head(data[indices, ][sort.list(data[indices, ]$Number, decreasing=TRUE),], 100)

dev.new()
set.seed(375) # to make it reproducibles
# plot the word cloud
wordcloud(words = cloud_df$Name, freq = cloud_df$Number,
          scale = c(4, 0.2),      # size of words
          min.freq = 100,          # drop infrequent
          max.words = 100,         # max words in plot
          random.order = FALSE,   # plot by frequency
          rot.per = 0.15,          # percent rotated
          # set colors
          colors = brewer.pal(9, "GnBu"),
          #           colors = brewer.pal(12, "Paired"),
          # color random or by frequency
          random.color = TRUE,
          # use r or c++ layout
          use.r.layout = FALSE    
) # end wordcloud
dev.off()



# Starked Area Plot:
require(ggplot2)
new_data <- subset(data, grepl("^Kath", Name))
indices <- which(new_data$State == "CA" & new_data$Number>100,
                 new_data$Sex == "F")
new_data <- new_data[indices, -2]
new_data <- aggregate(Number ~ Sex+Year+Name, new_data, sum)
p <- ggplot(new_data)
p <- p+geom_area(aes(x=Year, y=Number, fill=Name, group=Name, label=Name), 
                 alpha=0.5, color="white", position="stack"
                 )
print(p)
p <- p+scale_y_continuous(labels=comma, limits=c(0, 4500))
# Select color palette.
# make it pretty
p <- p + xlab("Time")
p <- p + ylab("Death")
p <- p + theme_legend()
p <- p + scale_year()
p <- p + coord_fixed(ratio = 1 / 600)



