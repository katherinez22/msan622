require(ggplot2)
require(shiny)
require(RColorBrewer)
require(scales)
require(wordcloud) # word cloud

# Load the dataset
loadData <- function() {
  df <- read.csv("NamesOf50StatesSub.csv")
  return(df)
}

# Plot the Stacked Area Plot
getAreaPlot <- function(df, reaction){
  nameSearch = reaction$nameSearch
  stateName = reaction$stateName
  yearRange = reaction$yearRange
  sexChoose = reaction$sexChoose
  print(nameSearch)
  new_df <- subset(df, grepl(nameSearch, Name))
  indices <- which(new_df$State == stateName & 
                     new_df$Number > 100,
                   new_df$Sex == sexChoose)
  new_df <- new_df[indices, -2]
  new_df <- aggregate(Number ~ Sex+Year+Name, new_df, sum)
  p <- ggplot(new_df)
  p <- p+geom_area(aes(x=Year, y=Number, fill=Name), 
                   alpha=0.5, color="white", position="stack")
  return(p)
}





# Plot the word cloud
getWordCloud <- function(df, reaction){
  stateName = reaction$stateName
  yearRange = reaction$yearRange
  sexChoose = reaction$sexChoose
  indices <- which(df$State == stateName & 
                     (df$Year >= yearRange[1] & df$Year <= yearRange[2]) & 
                     df$Sex == sexChoose)
  cloud_df <- head(df[index, ][sort.list(df[index, ]$Number, decreasing=TRUE),], 100)
  print(cloud_df)
  set.seed(375) # to make it reproducibles
  # plot the word cloud
  show(wordcloud(words = cloud_df$Name, freq = cloud_df$Number,
                 scale = c(4, 0.2),      # size of words
                 min.freq = 100,          # drop infrequent
                 max.words = 100,         # max words in plot
                 random.order = FALSE,   # plot by frequency
                 rot.per = 0.15,          # percent rotated
                 # set colors
                 colors = brewer.pal(9, "GnBu"),
                 # color random or by frequency
                 random.color = TRUE,
                 # use r or c++ layout
                 use.r.layout = FALSE    
  )) # end show
} # end getWordCloud





##### GLOBAL OBJECTS #####

# Shared data
globalData <- loadData()

##### SHINY SERVER #####
# Create shiny server.
shinyServer(function(input, output) {
  cat("Press \"ESC\" to exit...\n")
  # Copy the data frame 
  localFrame <- globalData
  
  getReaction1 <- reactive({
    return(list(nameSearch = input$nameSearch, 
                stateName = input$stateName,
                yearRange = input$yearRange,
                sexChoose = input$sexChoose
    ))
  }) # getReaction1
  
  getReaction2 <- reactive({
    return(list(stateName = input$stateName,
                yearRange = input$yearRange,
                sexChoose = input$sexChoose
    ))
  }) # getReaction1
  
  # Output Plots.
  output$areaPlot <- renderPlot({print(getAreaPlot(localFrame, getReaction1()))}) # output areaPlot
  output$wordCloud <- renderPlot({print(getWordCloud(localFrame, getReaction2()))}) # output wordCloud
}) # shinyServer