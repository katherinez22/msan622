library(shiny)

shinyUI(navbarPage("Baby Names of 50 States",
                   tabPanel("Stacked Area",sidebarLayout(
                     sidebarPanel(width=3,
                                  textInput("nameSearch", "Baby Name Search: ", ""),
                                  br(),
                                  selectInput("stateName","State: ",
                                              c("AK", "AL", "AR", "AZ", "CA", "CO", "CT", "DC", "DE", "FL", "GA", "HI", "IA", "ID", "IL", "IN", "KS", "KY", "LA", "MA", "MD",
                                                "ME", "MI", "MN", "MO", "MS", "MT", "NC", "ND", "NE", "NH", "NJ", "NM", "NV", "NY", "OH", "OK", "OR", "PA", "RI", "SC", "SD",
                                                "TN", "TX", "UT", "VA", "VT", "WA", "WI", "WV", "WY"),
                                              selected="CA"),
                                  br(), 
                                  sliderInput("yearRange", "Year Range:", min=1992, max=2012, value=c(1992, 2012), step=1, format='####'),
                                  br(), 
                                  radioButtons("sexChoose", "Sex:", c("Female", "Male"),
                                               selected = c("Female")),
                                  br(),
                                  selectInput("colorScheme", "Color Scheme:", 
                                              c("Default", "Accent", "Set1", "Set2", "Set3", "Dark2", "Pastel1", "Pastel2"),
                                              selected = "Default"),
                                  # Add a download link
                                  HTML("<p align=\"center\">[ <a href=\"https://github.com/katherinez22/msan622/tree/master/project-prototype\">download source</a> ]</p>")
                     ), #end of sidebarPanel
                     mainPanel(
                       plotOutput("areaPlot",width="100%",height="100%")
                     ) # end of main panel
                   ) # end of sidebarLayout 
                   ), # end tabpanel                
                   tabPanel("Word Cloud",sidebarLayout(
                     sidebarPanel(width=3,
                                  selectInput("stateName","State: ",
                                              c("AK", "AL", "AR", "AZ", "CA", "CO", "CT", "DC", "DE", "FL", "GA", "HI", "IA", "ID", "IL", "IN", "KS", "KY", "LA", "MA", "MD",
                                                "ME", "MI", "MN", "MO", "MS", "MT", "NC", "ND", "NE", "NH", "NJ", "NM", "NV", "NY", "OH", "OK", "OR", "PA", "RI", "SC", "SD",
                                                "TN", "TX", "UT", "VA", "VT", "WA", "WI", "WV", "WY"),
                                              selected="CA"),
                                  br(), 
                                  sliderInput("yearRange", "Year Range:", min=1992, max=2012, value=c(1992, 2012), step=1, format='####'),
                                  br(), 
                                  radioButtons("sexChoose", "Sex:", c("Female", "Male"),
                                               selected = c("Female")),
                                  br(),
                                  selectInput("colorScheme", "Color Scheme:", 
                                              c("Default", "Accent", "Set1", "Set2", "Set3", "Dark2", "Pastel1", "Pastel2"),
                                              selected = "Default"),
                                  # Add a download link
                                  HTML("<p align=\"center\">[ <a href=\"https://github.com/katherinez22/msan622/tree/master/project-prototype\">download source</a> ]</p>")
                     ), #end sidebarPanel
                     mainPanel(
                       plotOutput("wordCloud",width="100%",height="100%")
                     ) # end main panel
                   ) # end sidebarLayout 
                   ), # end tabpanel
                   tabPanel("Map",sidebarLayout(
                     sidebarPanel(width=3,
                                  textInput("nameSearch", "Baby Name Search: ", ""),
                                  br(),
                                  selectInput("stateName","State: ",
                                              c("AK", "AL", "AR", "AZ", "CA", "CO", "CT", "DC", "DE", "FL", "GA", "HI", "IA", "ID", "IL", "IN", "KS", "KY", "LA", "MA", "MD",
                                                "ME", "MI", "MN", "MO", "MS", "MT", "NC", "ND", "NE", "NH", "NJ", "NM", "NV", "NY", "OH", "OK", "OR", "PA", "RI", "SC", "SD",
                                                "TN", "TX", "UT", "VA", "VT", "WA", "WI", "WV", "WY"),
                                              selected="CA"),
                                  br(), 
                                  sliderInput("yearRange", "Year Range:", min=1992, max=2012, value=c(1992, 2012), step=1, format='####'),
                                  br(), 
                                  radioButtons("sexChoose", "Sex:", c("Female", "Male"),
                                               selected = c("Female")),
                                  br(),
                                  selectInput("colorScheme", "Color Scheme:", 
                                              c("Default", "Accent", "Set1", "Set2", "Set3", "Dark2", "Pastel1", "Pastel2"),
                                              selected = "Default"),
                                  # Add a download link
                                  HTML("<p align=\"center\">[ <a href=\"https://github.com/katherinez22/msan622/tree/master/project-prototype\">download source</a> ]</p>")
                     ), #end of sidebarPanel
                     mainPanel(
                       plotOutput("areaPlot",width="100%",height="100%")
                     ) # end of main panel
                   ) # end of sidebarLayout 
                   ) # end tabpanel
)# end navbar page
) #end shiny UI
