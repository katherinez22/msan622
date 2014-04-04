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
  movies$mpaa <- droplevels(movies$mpaa)
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
    # create an empty plot.
    localPlot <- ggplot(localFrame) + 
      geom_point() + 
      scale_x_continuous(expand = c(0, 0), label = million_formatter, limits=c(0, 220000000)) +
      xlab("Budget") + 
      ylab("IMDb Rating") +
      ylim(0.0, 10.0) +
      labs(color="MPAA") +
      theme(panel.grid.major = element_line(color = "grey90", linetype = 3)) +
      theme(panel.grid.minor = element_blank()) +
      theme(panel.background = element_rect(fill = NA)) +
      theme(panel.border = element_blank()) + 
      theme(legend.key = element_rect(fill = NA)) +
      theme(axis.text.x = element_text(size = rel(1.2))) +
      theme(axis.text.y = element_text(size = rel(1.2))) +
      theme(axis.title.x = element_text(size = rel(1.2))) +
      theme(axis.title.y = element_text(size = rel(1.2))) +
      theme(legend.title = element_text(size = rel(1.2), face = "italic")) +
      theme(legend.text = element_text(face = "italic")) +
      theme(legend.direction = "vertical") +
      theme(legend.justification = c(1, 0)) +
      theme(legend.position = c(0.9, 0)) +
      theme(legend.background = element_blank()) 
  }
  else {
    # Create base plot.
    localPlot <- ggplot(localFrame, aes(x = budget, y = rating, color = mpaa)) +
      geom_point(alpha = dotAlpha, size = dotSize) +
      scale_x_continuous(expand = c(0, 0), label = million_formatter, limits=c(0, 220000000)) +
      xlab("Budget") + 
      ylab("IMDb Rating") +
      ylim(0.0, 10.0) +
      labs(color="MPAA") +
      theme(panel.grid.major = element_line(color = "grey90", linetype = 3)) +
      theme(panel.grid.minor = element_blank()) +
      theme(panel.background = element_rect(fill = NA)) +
      theme(panel.border = element_blank()) + 
      theme(axis.text = element_text(size = rel(1.2))) +
      theme(axis.title = element_text(size = rel(1.2))) +
      theme(legend.key = element_rect(fill = NA)) +
      theme(legend.title = element_text(size = rel(1.2), face = "italic")) +
      theme(legend.text = element_text(face = "italic")) +
      theme(legend.direction = "vertical") +
      theme(legend.justification = c(1, 0)) +
      theme(legend.position = c(0.9, 0)) +
      theme(legend.background = element_blank()) 
      
    # Select color palette.
    if (colorScheme == "Default") {
      localPlot <- localPlot + scale_colour_discrete(limits = levels(localFrame$mpaa)) 
    }
    else {
      localPlot <- localPlot +
        scale_color_brewer(type = "qual", palette = colorScheme, limits = levels(localFrame$mpaa))
    }
  }
  return(localPlot)
}

# Create a table function.
getTable <- function(localFrame, mpaaRating, movieGenres) {
  # Create a new data frame showing the MPAA Raint, Movie Genres and associated Number of Movies
  if (mpaaRating == "All" && length(movieGenres) == 0) {
    newFrame <- data.frame(matrix(NA, nrow = 1, ncol = 5))
    colnames(newFrame) <- c("MPAA Rating", "Movie Genre", "Number of Movies", "Minimum Budget", "Maximum Budget")
    newFrame$"MPAA Rating" <- mpaaRating
    newFrame$"Movie Genre" <- "All"
    newFrame$"Number of Movies" <- formatC(nrow(localFrame), format="d", big.mark=",")
    newFrame$"Minimum Budget" <- formatC(min(localFrame$budget), format="d", big.mark=",")
    newFrame$"Maximum Budget" <- formatC(max(localFrame$budget), format="d", big.mark=",")
  }
  else if (mpaaRating == "All" && length(movieGenres) != 0) {
    newFrame <- data.frame(matrix(NA, nrow = length(movieGenres), ncol = 5))
    colnames(newFrame) <- c("MPAA Rating", "Movie Genre", "Number of Movies", "Minimum Budget", "Maximum Budget")
    newFrame$"MPAA Rating" <- mpaaRating
    newFrame$"Movie Genre" <- movieGenres
    count <- c()
    min_budget <- c()
    max_budget <- c()
    for (i in movieGenres) {
      count <- c(count, nrow(localFrame[which(localFrame$genre == i),]))
      min_budget <- c(min_budget, min(localFrame[which(localFrame$genre == i), "budget"]))
      max_budget <- c(max_budget, max(localFrame[which(localFrame$genre == i), "budget"]))
    }
    newFrame$"Number of Movies" <- formatC(count, format="d", big.mark=",")
    newFrame$"Minimum Budget" <- formatC(min_budget, format="d", big.mark=",")
    newFrame$"Maximum Budget" <- formatC(max_budget, format="d", big.mark=",")
  }
  else if (mpaaRating != "All" && length(movieGenres) == 0) {
    newFrame <- data.frame(matrix(NA, nrow = 1, ncol = 5))
    colnames(newFrame) <- c("MPAA Rating", "Movie Genre", "Number of Movies", "Minimum Budget", "Maximum Budget")
    newFrame$"MPAA Rating" <- mpaaRating
    newFrame$"Movie Genre" <- "All"
    newFrame$"Number of Movies" <- formatC(nrow(localFrame[which(localFrame$mpaa == mpaaRating),]), format="d", big.mark=",")
    newFrame$"Minimum Budget" <- formatC(min(localFrame[which(localFrame$mpaa == mpaaRating), "budget"]), format="d", big.mark=",")
    newFrame$"Maximum Budget" <- formatC(max(localFrame[which(localFrame$mpaa == mpaaRating), "budget"]), format="d", big.mark=",")
  }
  else if (mpaaRating != "All" && length(movieGenres) != 0) {
    newFrame <- data.frame(matrix(NA, nrow = length(movieGenres), ncol = 5))
    colnames(newFrame) <- c("MPAA Rating", "Movie Genre", "Number of Movies", "Minimum Budget", "Maximum Budget")
    newFrame$"MPAA Rating" <- mpaaRating
    newFrame$"Movie Genre" <- movieGenres
    count <- c()
    min_budget <- c()
    max_budget <- c()
    for (i in movieGenres) {
      count <- c(count, nrow(localFrame[which(localFrame$mpaa == mpaaRating & localFrame$genre == i),]))
      min_budget <- c(min_budget, min(localFrame[which(localFrame$mpaa == mpaaRating & localFrame$genre == i), "budget"]))
      max_budget <- c(max_budget, max(localFrame[which(localFrame$mpaa == mpaaRating & localFrame$genre == i), "budget"]))
    }
    newFrame$"Number of Movies" <- formatC(count, format="d", big.mark=",")
    newFrame$"Minimum Budget" <- formatC(min_budget, format="d", big.mark=",")
    newFrame$"Maximum Budget" <- formatC(max_budget, format="d", big.mark=",")
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