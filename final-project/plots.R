<<<<<<< HEAD
require(ggplot2)
require(shiny)
require(RColorBrewer)
require(scales)
require(wordcloud)
require(Hmisc)
require(ggmap)
require(maptools)
require(plyr)

# Customize the theme
theme_legend <- function() {
  return(
    theme(
      legend.background = element_blank(),
      legend.title = element_text(size=12,face = "bold"),
      legend.text = element_text(size=10),
      panel.border = element_blank(),
      panel.background = element_rect(fill = NA),
      panel.grid.minor = element_blank(),
      panel.grid.major = element_blank(),
      axis.ticks.x = element_blank(),
      axis.ticks.y = element_blank(),
      axis.title.x = element_blank(),
      axis.title.y = element_blank(),
      axis.text.x = element_blank(),
      axis.text.y = element_blank()
    )
  )
}

d <- read.csv("NamesOf50States.csv")
new_d <- subset(d, grepl("^Kate", Name))
indices <- which(new_d$Sex == "F" & new_d$Year == 2012)
new_d <- new_d[indices,]
us_state_map <- map_data('state')
map_d <- merge(new_d, us_state_map, by = 'region')
map_d <- arrange(map_d, order)
states <- data.frame(state.center, state.abb)

p <- ggplot(data = map_d, aes(x = long, y = lat, group = group))
p <- p + geom_polygon(aes(fill = cut_number(Number, 5)))
p <- p + geom_path(colour = 'gray', linestyle = 2)
p <- p + scale_fill_brewer("Number of Baby Names", palette='PuRd')
p <- p + geom_text(data=states, aes(x=x, y=y, label=state.abb, group = NULL), size = 3)
p <- p + facet_wrap(~ Name, ncol=3)
p <- p + theme_legend()
print(p)

p <- ggplot(data = us_state_map, aes(x = long, y = lat, group = group))
p <- p + geom_polygon(fill = "white")
p <- p + geom_path(colour = 'grey', linestyle = 2)
p <- p + scale_fill_brewer("Number of Baby Names", palette='PuRd')
p <- p + geom_text(data=states, aes(x=x, y=y, label=state.abb, group = NULL), size = 3)
p <- p + theme_legend()
print(p)




=======
data <- read.csv("NamesOf50States.csv")
>>>>>>> FETCH_HEAD

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



<<<<<<< HEAD
# Stacked Area Plot:
require(ggplot2)
new_df <- subset(d, grepl("^Kath", Name))
# indices <- which(new_df$Division == "Pacific" & 
#                    new_df$Sex == "F")
# new_df <- new_df[indices, -c(1,3,4)]
new_df2 <- aggregate(Number ~ Sex+Year+Name, new_df, sum)
p <- ggplot(new_df2)
p <- p+geom_area(aes(x=Year, y=Number, fill=Name))
p <- p+geom_point(aes(x=Year, y=Number, color=Name, size=Number))
p <- p + facet_wrap(~ State, ncol=3)
=======
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
>>>>>>> FETCH_HEAD
print(p)
p <- p+scale_y_continuous(labels=comma, limits=c(0, 4500))
# Select color palette.
# make it pretty
p <- p + xlab("Time")
p <- p + ylab("Death")
p <- p + theme_legend()
p <- p + scale_year()
p <- p + coord_fixed(ratio = 1 / 600)



