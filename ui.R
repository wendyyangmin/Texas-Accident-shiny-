library(shiny)
library(leaflet)
library(shinythemes)
library(plotly)

# Define UI for application that analyzes the patterns of crimes in DC
shinyUI(fluidPage(
  
  # Change the theme to flatly
  theme = shinytheme("united"),
  
  # Application title
  titlePanel("Railroad Accident in Texas"),
  
  # Three sidebars for uploading files, selecting year and state
  sidebarLayout(
    sidebarPanel(
      
      # Create a file input
      fileInput("file","Choose A CSV File Please",
                multiple = TRUE,
                accept = c("text/csv",
                           "text/comma-separated-values,text/plain",
                           ".csv")),
      
      
      
      # Create a multiple checkbox input for time 
      checkboxGroupInput("Time",
                         "Time:",
                         c( "Morning","Afternoon","Evening","Midnight"  )
      ),
      
      hr(),
      helpText("Please Select The Time You Want To Analyze For Accident Patterns"),
      helpText("You Can Choose More Than One"),
      
      # Create a slider input for year
      sliderInput("Year",label =("Year Range"),
                  min = 1975,
                  max = 2016,
                  value = c(1975,2016)
                  ),
      # Create a muptiple checkbox input for type of track
      checkboxGroupInput("Track",
                     "Type of Track:",
      c( "MAIN","YARD","INDUSTRY","SIDING")
    ),
    
    hr(),
    helpText("This is for plot analysis"),
    helpText("Please Select The Type of Track You Want To Analyze For Accident Patterns"),
    helpText("You Can Choose More Than One"),
    
    hr(),
    hr()
    
      ),
    

    
    # Make the sidebar on the right of the webpage
    position = "right",
    fluid = TRUE,
    
    
    
    # Create four tabs
    mainPanel(
      hr(),
      tabsetPanel(type="tabs",
                  
                  #Add a tab for problem description
                  tabPanel("Problem Description", textOutput("text")),
                  
                  #Add a tab for decriptive table
                  tabPanel("Descriptive Analysis",
                           
                           #Add two subtabs
                           tabsetPanel(
                             tabPanel("Accident Type",verbatimTextOutput("table1")),
                             tabPanel("Type of Track",verbatimTextOutput("table2")),
                             tabPanel("County Location",verbatimTextOutput("table3"))
                          
                           )
                  ),
                  
                  
                  #Tab for the Leaflet Map
                  tabPanel("Map", leafletOutput("map", height=630)),
                  
                  #Tab for plot
                  tabPanel("Plot",
                            #Add two subtabs
                            tabsetPanel(
                              tabPanel("Type of accident vs. Type of track",plotlyOutput("plot1")),
                              tabPanel("Injuries for different type of accident",plotlyOutput("plot2")),
                              tabPanel("Damage for different type of accident",plotlyOutput("plot3"))
                            
                            )
                  )
                  
      )
    )
  )
))

