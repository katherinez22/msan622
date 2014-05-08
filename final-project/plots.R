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
indices <- which(new_d$Sex == "F")
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



# Small multiples:
d <- read.csv("NamesOf50States.csv")
indices <- which(d$Division == "Pacific" & d$Sex == "F")
indices <- which(d$Division == "Pacific")
new_df <- d[indices, ]
new_df2 <- aggregate(Number ~ State+Year, d, sum)

# Label formatter for numbers in thousands.
k_formatter <- function(x) {
  return(sprintf("%gk", round(x / 1000)))
}
theme_legend_small <- function() {
  return(
    theme(
      panel.border = element_blank(),
      panel.background = element_rect(fill = NA),
      panel.grid.minor = element_blank(),
      panel.grid.major = element_line(color = "grey90", linetype = 3),
      axis.ticks.y = element_blank(), 
      axis.title = element_text(size = rel(1.2), face = "bold"),
      strip.background=element_rect(fill="white", size = rel(1.2))
    )
  )
}

ggplot(new_df2, aes(x=Year, y=Number))+
  geom_path(alpha=0.8, color="#386cb0", size=1.1)+
  geom_point(alpha=0.9, color="#984ea3", size=1.5)+
  facet_wrap(~State)+
  coord_polar(theta = "x", direction = -1) +
  scale_y_continuous(label = k_formatter) +
  theme_legend_small()


