library(shiny)

# Create a simple shiny page.
shinyUI(
  # We will create a page with a sidebar for input.
  pageWithSidebar(  
    # Add title panel.
    titlePanel("Movie Rating VS. Budget"),
    
    # Setup sidebar widgets.
    sidebarPanel(
      
      # Add radio buttons that allow the user to filter which MPAA ratings to view.
      # Can only select one radio button at a time.
      radioButtons(
        "mpaaRating", 
        "MPAA Rating:",
        c("All", "NC-17", "PG", "PG-13", "R"),
        selected = "All"
      ),
      
      # Add a little bit of space between widgets.
      br(),
      
      # Add a checkbox group that allows the user to filter which movie genres to view. 
      checkboxGroupInput(
        "movieGenres", 
        "Movie Genres:", 
        c("Action", "Animation", "Comedy", "Drama", "Documentary", "Romance", "Short"),
        selected = NULL
      ),
      
      # Add a little bit of space between widgets.
      br(),
      
      # Add a drop-down box that allows the user to change color schemes
      selectInput(
        "colorScheme", 
        "Color Scheme:", 
        c("Default", "Accent", "Set1", "Set2", "Set3", "Dark2", "Pastel1", "Pastel2"),
        selected = "Default"
      ),
      
      # Add a slider input from 1 to 10 that controls the size of the dots in the scatterplot.
      sliderInput(
        "dotSize", 
        "Dot Size", 
        min = 1, 
        max = 10, 
        value = 3, 
        step = 1),
      
      # Add a slider input from 0.1 to 1.0 that steps by 0.1 and controls the alpha value.
      sliderInput(
        "dotAlpha", 
        "Dot Alpha", 
        min = 0.1, 
        max = 1, 
        value = 0.5, 
        step = 0.1),
      
      # Add a little bit of space between widgets.
      br(),
      
      # Add a download link
      HTML("<p align=\"center\">[ <a href=\"https://github.com/katherinez22/msan622/tree/master/homework2\">download source</a> ]</p>")
    ),
    
    # Setup main panel.
    mainPanel(
      # Create a tab panel.
      tabsetPanel(
        # Add a tab for displaying the histogram.
        tabPanel("Scatter Plot", plotOutput("scatterPlot",
                                            width = "750px", 
                                            height = "600px")),
        
        # Add a tab for displaying the table (will be sorted).
        tabPanel("Table", tableOutput("table"))
      )
    )  
  )
)
