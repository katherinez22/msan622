require(ggplot2)
require(shiny)
require(RColorBrewer)
require(scales)
require(wordcloud)
require(Hmisc)
require(ggmap)
require(maptools)
require(plyr)

# Load the dataset
loadData <- function() {
  df <- read.csv("NamesOf50States.csv")
  return(df)
}

# Customize the theme
theme_legend_map <- function() {
  return(
    theme(
      legend.background = element_blank(),
      legend.title = element_text(size=15,face = "bold"),
      legend.text = element_text(size=13),
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

# Plot the word cloud
getWordCloud <- function(df, reaction){
  stateName = reaction$stateName
  year = reaction$year
  wordNumber = reaction$wordNumber
  if (reaction$sexChoose == "Female"){
    sexChoose = "F"
  }
  else {sexChoose = "M"}
  if (stateName == "All"){
    indices <- which(df$Year == year & df$Sex == sexChoose)
  }
  else {
    indices <- which(df$State == stateName & df$Year == year & df$Sex == sexChoose)
  }
  cloud_df <- head(df[indices, ][sort.list(df[indices, ]$Number, decreasing=TRUE),], wordNumber)
  set.seed(375) # to make it reproducibles
  # plot the word cloud
  return(wordcloud(words = cloud_df$Name, freq = cloud_df$Number,
            scale = c(5, 0.3),    
            random.order = FALSE,
            rot.per = 0.15,        
            colors = brewer.pal(8, "Dark2"),
            random.color = TRUE,
            use.r.layout = FALSE    
  )) # end return
} # end getWordCloud


# Plot the Map
getMap <- function(df, reaction){
  nameSearch = capitalize(tolower(reaction$nameSearch))
  year = reaction$year
  colorScheme = reaction$colorScheme
  if (reaction$sexChoose == "Female"){
    sexChoose = "F"
  }
  else {sexChoose = "M"}
  indices <- which(df$Name == nameSearch & df$Year == year & df$Sex == sexChoose)
  new_df <- df[indices,]
  us_state_map <- map_data('state')
  map_df <- merge(new_df, us_state_map, by = 'region')
  map_df <- arrange(map_df, order)
  states <- data.frame(state.center, state.abb)
  p <- ggplot(data = us_state_map, aes(x = long, y = lat, group = group))
  p <- p + geom_polygon(fill = "white")
  p <- p + geom_path(colour = 'grey', linestyle = 2)
  p <- p + geom_text(data=states, aes(x=x, y=y, label=state.abb, group = NULL), size = 5)
  p <- p + theme_legend_map()
  if (length(unique(map_df$Name)) > 0) {
    p <- p + geom_polygon(data = map_df, aes(fill = cut_number(Number, 5)))
    p <- p + geom_path(colour = 'grey', linestyle = 2)
    p <- p + scale_fill_brewer("Number of Names", type = "seq", palette=colorScheme)
    p <- p + geom_text(data=states, aes(x=x, y=y, label=state.abb, group = NULL), size = 5)
  }
  return(p)
}

# Get small multiples
getSmall <- function(df, reaction){
  nameSearch = capitalize(tolower(reaction$nameSearch))
  division = reaction$division
  if (reaction$sexChoose == "Female"){
    sexChoose = "F"
  }
  else {sexChoose = "M"}
  new_df <- subset(df, grepl(nameSearch, Name))
  indices <- which(new_df$Division == division & new_df$Sex == sexChoose)
  new_df <- new_df[indices, -c(1,3,4)]
  new_df2 <- aggregate(Number ~ State+Year+Name, new_df, sum)
  p <- ggplot(new_df2)
  p <- p+geom_point(aes(x=Year, y=Number, color=Name, size=Number))
  p <- p + facet_wrap(~ State, ncol=3)
  return(p)
}


# Get raw data
getTable <- function(df, reaction){
  nameSearch = capitalize(tolower(reaction$nameSearch))
  new_df <- subset(df, grepl(nameSearch, Name))
  year = reaction$year
  indices <- which((new_df$Year >= year[1] & new_df$Year <= year[2]))
  new_df <- new_df[indices,-1]
  new_df$region <- toupper(new_df$region)
  colnames(new_df) <- c("State Abb.", "State Name", "Division", "Gender", "Year", "Baby Name", "Frequency")
  return(new_df)
}



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
    return(list(stateName = input$stateName1,
                year = input$year1,
                sexChoose = input$sexChoose1,
                wordNumber = input$wordNumber1
    ))
  }) # getReaction1
  
  getReaction2 <- reactive({
    return(list(nameSearch = input$nameSearch2,
                year = input$year2,
                sexChoose = input$sexChoose2,
                colorScheme = input$colorScheme2
    ))
  }) # getReaction2
  
  getReaction3 <- reactive({
    return(list(nameSearch = input$nameSearch3,
                division = input$division3,
                sexChoose = input$sexChoose3
    ))
  }) # getReaction3
  
  getReaction4 <- reactive({
    return(list(nameSearch = input$nameSearch4,
                year = input$year4
    ))
  }) # getReaction4
  
  # Output Plots.
  output$table <- renderDataTable({print(getTable(localFrame, getReaction4()))},
                                  options = list(sPaginationType = "two_button",
                                                 sScrollY = "400px",
                                                 bScrollCollapse = 'true')) # output table
  output$wordCloud <- renderPlot({print(getWordCloud(localFrame, getReaction1()))},width=1000,height=800) # output wordCloud
  output$map <- renderPlot({print(getMap(localFrame, getReaction2()))},width=1200,height=800) # output map
  output$small <- renderPlot({print(getSmall(localFrame, getReaction3()))},width=1000,height=800) # output areaPlot 
}) # shinyServer