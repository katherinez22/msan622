library(ggplot2)
library(shiny)

# Objects defined outside of shinyServer() are visible to
# all sessions. Objects defined instead of shinyServer()
# are created per session. 

# Note: Formatting is such that code can easily be shown
# on the projector.

# Loads global data to be shared by all sessions.
loadData <- function() {
  data("movies", package = "ggplot2")
  
  # Filter out any rows that do not have a valid budget value greater than 0.
  movies <- movies[-which(is.na(movies$budget) == TRUE), ]
  movies <- movies[-which(movies$budget <= 0), ]
  # Filter out any rows that do not have a valid MPAA rating in the mpaa column.
  movies <- movies[-which(movies$mpaa == ""), ]
  # Add a genre column to the movies dataset
  movies$genre <- rep(NA, nrow(movies))
  count <- rowSums(movies[, 18:24])
  movies$genre[which(count > 1)] = "Mixed"
  movies$genre[which(count < 1)] = "None"
  movies$genre[which(count == 1 & movies$Action == 1)] = "Action"
  movies$genre[which(count == 1 & movies$Animation == 1)] = "Animation"
  movies$genre[which(count == 1 & movies$Comedy == 1)] = "Comedy"
  movies$genre[which(count == 1 & movies$Drama == 1)] = "Drama"
  movies$genre[which(count == 1 & movies$Documentary == 1)] = "Documentary"
  movies$genre[which(count == 1 & movies$Romance == 1)] = "Romance"
  movies$genre[which(count == 1 & movies$Short == 1)] = "Short"
  
  return(movies)
}

# Label formatter for numbers in thousands.
million_formatter <- function(x) {
  return(sprintf("%gm", round(x / 1000000)))
}

# Create plotting function.
getPlot <- function(localFrame, mpaaRating, movieGenres, colorScheme, dotSize, dotAlpha) {
  
  # Filter the data.
  if (mpaaRating == "All" && length(movieGenres) == 0) {
    localFrame <- localFrame
  }
  else if (mpaaRating == "All" && length(movieGenres) != 0) {
    index <- c()
    for (i in movieGenres) {
      index <- c(index, which(localFrame$genre == i))
    }
    localFrame <- localFrame[index,]
  }
  else if (mpaaRating != "All" && length(movieGenres) == 0) {
    localFrame <- localFrame[which(localFrame$mpaa == mpaaRating),]
  }
  else if (mpaaRating != "All" && length(movieGenres) != 0) {
    index <- c()
    for (i in movieGenres) {
      index <- c(index, which(localFrame$mpaa == mpaaRating & localFrame$genre == i))
    }
    localFrame <- localFrame[index,]    
  }
  
  if (nrow(localFrame) == 0) {
    return("There is no data within this MPAA Rating and Movie Genre combination")
  }
  else {
    # Create base plot.
    localPlot <- ggplot(localFrame, aes(x = budget, y = rating, color = mpaa)) +
      geom_point(alpha = dotAlpha, size = dotSize) +
      scale_x_continuous(expand = c(0, 500), label = million_formatter, limits=c(1000000, 200000000)) +
      xlab("Budget") + 
      ylab("IMDb Rating") +
      ylim(0.0, 10.0) +
      labs(color="MPAA") +
      theme(panel.grid.major.x = element_blank()) +
      theme(panel.grid.major.y = element_blank()) +
      theme(axis.text.x = element_text(size = rel(1.2))) +
      theme(axis.text.y = element_text(size = rel(1.2))) +
      theme(axis.title.x = element_text(size = rel(1.2))) +
      theme(axis.title.y = element_text(size = rel(1.2))) +
      theme(legend.title = element_text(size = rel(1.2), face = "italic")) +
      theme(legend.text = element_text(face = "italic")) +
      theme(legend.position = "bottom")
    
    # Select color palette.
    if (colorScheme == "Default") {
      localPlot <- localPlot
    }
    else {
      localPlot <- localPlot +
        scale_color_brewer(palette = colorScheme)
    }
    return(localPlot)
  }
}

# Create a table function.
getTable <- function(localFrame, mpaaRating, movieGenres) {
  # Create a new data frame showing the MPAA Raint, Movie Genres and associated Number of Movies
  if (mpaaRating == "All" && length(movieGenres) == 0) {
    newFrame <- data.frame(matrix(NA, nrow = 1, ncol = 3))
    colnames(newFrame) <- c("MPAA Rating", "Movie Genre", "Number of Movies")
    newFrame$"MPAA Rating" <- mpaaRating
    newFrame$"Movie Genre" <- "All"
    newFrame$"Number of Movies" <- nrow(localFrame)
  }
  else if (mpaaRating == "All" && length(movieGenres) != 0) {
    newFrame <- data.frame(matrix(NA, nrow = length(movieGenres), ncol = 3))
    colnames(newFrame) <- c("MPAA Rating", "Movie Genre", "Number of Movies")
    newFrame$"MPAA Rating" <- mpaaRating
    newFrame$"Movie Genre" <- movieGenres
    count <- c()
    for (i in movieGenres) {
      count <- c(count, nrow(localFrame[which(localFrame$genre == i),]))
    }
    newFrame$"Number of Movies" <- count
  }
  else if (mpaaRating != "All" && length(movieGenres) == 0) {
    newFrame <- data.frame(matrix(NA, nrow = 1, ncol = 3))
    colnames(newFrame) <- c("MPAA Rating", "Movie Genre", "Number of Movies")
    newFrame$"MPAA Rating" <- mpaaRating
    newFrame$"Movie Genre" <- "All"
    newFrame$"Number of Movies" <- nrow(localFrame[which(localFrame$mpaa == mpaaRating),])
  }
  else if (mpaaRating != "All" && length(movieGenres) != 0) {
    newFrame <- data.frame(matrix(NA, nrow = length(movieGenres), ncol = 3))
    colnames(newFrame) <- c("MPAA Rating", "Movie Genre", "Number of Movies")
    newFrame$"MPAA Rating" <- mpaaRating
    newFrame$"Movie Genre" <- movieGenres
    count <- c()
    for (i in movieGenres) {
      count <- c(count, nrow(localFrame[which(localFrame$mpaa == mpaaRating & localFrame$genre == i),]))
    }
    newFrame$"Number of Movies" <- count
  }
  return(newFrame)
}

##### GLOBAL OBJECTS #####

# Shared data
globalData <- loadData()

##### SHINY SERVER #####

# Create shiny server. Input comes from the UI input
# controls, and the resulting output will be displayed on
# the page.
shinyServer(function(input, output) {
  
  cat("Press \"ESC\" to exit...\n")
  
  # Copy the data frame (don't want to change the data
  # frame for other viewers)
  localFrame <- globalData
  
  # select color scheme
  filterColor <- reactive({
    switch(input$colorScheme,
           "Default" = "Default",
           "Accent" = "Accent",
           "Set1" = "Set1",
           "Set2" = "Set2",
           "Set3" = "Set3",
           "Dark2" = "Dark2",
           "Pastel1" = "Pastel1",
           "Pastel2" = "Pastel2"
    )
  })
    

  # Output filtered scatter plot.
  # Should update every time sort or color criteria changes.
  output$scatterPlot <- renderPlot(
    {
      # Use the function to generate the plot.
      scatterPlot <- getPlot(
        localFrame, input$mpaaRating, input$movieGenres, filterColor(), input$dotSize, input$dotAlpha
      )
      # Output the plot
      print(scatterPlot)
    }
    )
  
  output$table <- renderTable(
    {
      # Use the function to generate the plot.
      table <- getTable(localFrame, input$mpaaRating, input$movieGenres)
      # Output the plot
      print(table)
    }
    )
})