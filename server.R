
options(shiny.maxRequestSize=30*1024^2)
library(shiny)
library(leaflet)
library(dplyr)
library(plotly)

# Define server that analyzes the patterns of crimes in DC
shinyServer(function(input, output) {
  
  # Create an output variable for problem description
  output$text <- renderText({
    
    "This project uses the dataset 'Reportable Rail Equipment Accidents'. 
    The dataset contains information for Rail Equipment Accidents Nationalwide from 1975 to 2016.
    The data including Accident type, inckey, fatality, # of injuries, track damage, equipment damage,county,calender year,time,type of track, state name, and location.
    Since the dataset is very large, for this project, I focused on only analyze the state Texas.
    Question: How Do the Patterns of Railroad accidents in Texas vary by year, time slot, type of track accident is on, and how is the damage and injury look like?
    To answer this question, we analyze the types of accident, the types of track, and report its frequency at different time and year, and create a map for visualization.
    This question is a great interest to department of transportation for future development and renovation on railroad and trains."
    
  })
  
  
  # Create a descriptive table for different type of accident 
  output$table1 <- renderPrint({
    
    # Connect to the sidebar of file input
    inFile <- input$file
    
    if(is.null(inFile))
      return("Please Upload A File For Analysis")
    
    # Read input file
    mydata <- read.csv(inFile$datapath)
    attach(mydata)
    
    
    # Filter the data for different year and different state
    target1 <- c(input$Year)
    target2 <- c(input$Time)
    target3 <- c(input$Track)
    accident_df <- filter(mydata, calendar %in% target1 & cat %in% target2 & TYPE_OF_TRACK %in% target3)
    
    # Create a table for type of accident
    table(accident_df$AccidentType)
    
  })
  
  # Create a descriptive table for different type of track
  output$table2 <- renderPrint({
    
    # Connect to the sidebar of file input
    inFile <- input$file
    
    if(is.null(inFile))
      return("Please Upload A File For Analysis")
    
    # Read input file
    mydata <- read.csv(inFile$datapath)
    attach(mydata)
    
    # Filter the data for different year and different states
    target1 <- c(input$Year)
    target2 <- c(input$Time)
    target3 <- c(input$Track)
    track_df <- filter(mydata, calendar %in% target1 & cat %in% target2 & TYPE_OF_TRACK %in% target3)
    
    # Create a table for accident type 
    table(track_df$TYPE_OF_TRACK)
    
  })
  
  # Create a descriptive table for different county
  output$table3 <- renderPrint({
    
    # Connect to the sidebar of file input
    inFile <- input$file
    
    if(is.null(inFile))
      return("Please Upload A File For Analysis")
    
    # Read input file
    mydata <- read.csv(inFile$datapath)
    attach(mydata)
    
    # Filter the data for different year and different states
    target1 <- c(input$Year)
    target2 <- c(input$Time)
    target3 <- c(input$Track)
    track_df <- filter(mydata, calendar %in% target1 & cat %in% target2 & TYPE_OF_TRACK %in% target3)
    
    # Create a table for accident type 
    table(track_df$County)
    
  })
  
  
  ################################################################
  # Create a plot for different type of track vs accident type 
  output$plot1 <- renderPlotly({
    
    # Connect to the sidebar of file input
    inFile <- input$file
    
    if(is.null(inFile))
      return("Please Upload A File For Analysis")
    
    # Read input file
    mydata <- read.csv(inFile$datapath)
    attach(mydata)
    
    # Filter the data for different year and different time
    target1 <- c(input$Year)
    target2 <- c(input$Time)
    target3 <- c(input$Track)
    track_df <- filter(mydata, calendar %in% target1 & cat %in% target2 & TYPE_OF_TRACK %in% target3)
    
    # Create a plot for accident type 
      plot_ly(track_df, x = ~TYPE_OF_TRACK, y = ~AccidentType)
    })
    
  # Create a plot for different accident type vs injuries 
  output$plot2 <- renderPlotly({
    
    # Connect to the sidebar of file input
    inFile <- input$file
    
    if(is.null(inFile))
      return("Please Upload A File For Analysis")
    
    # Read input file
    mydata <- read.csv(inFile$datapath)
    attach(mydata)
    
    # Filter the data for different year and different time
    target1 <- c(input$Year)
    target2 <- c(input$Time)
    target3 <- c(input$Track)
    track_df <- filter(mydata, calendar %in% target1 & cat %in% target2 & TYPE_OF_TRACK %in% target3)
    
    # Create a plot for accident type and  
    plot_ly(track_df, x = ~AccidentType, y = ~Injuries)
  })

  # Create a plot for different accident type vs demage 
  output$plot3 <- renderPlotly({
    
    # Connect to the sidebar of file input
    inFile <- input$file
    
    if(is.null(inFile))
      return("Please Upload A File For Analysis")
    
    # Read input file
    mydata <- read.csv(inFile$datapath)
    attach(mydata)
    
    # Filter the data for different year and different time
    target1 <- c(input$Year)
    target2 <- c(input$Time)
    target3 <- c(input$Track)
    track_df <- filter(mydata, calendar %in% target1 & cat %in% target2 & TYPE_OF_TRACK %in% target3)
    
    # Create a plot for accident type and  
    plot_ly(track_df, x = ~AccidentType, y = ~EquipmentDamage)
  })


  
  #############################################################
  
  
  # Create a map output variable
  output$map <- renderLeaflet({
    
    # Connect to the sidebar of file input
    inFile <- input$file
    
    if(is.null(inFile))
      return(NULL)
    
    # Read input file
    mydata <- read.csv(inFile$datapath)
    attach(mydata)
    
    # Filter the data for different time slots and different districts
    target1 <- c(input$Year)
    target2 <- c(input$Time)
    target3 <- c(input$Track)
    map_df <- filter(mydata, calendar %in% target1 & cat %in% target2 & TYPE_OF_TRACK %in% target3)
    
    # Create colors with a categorical color function
    color <- colorFactor(rainbow(13), map_df$AccidentType)
    
    # Create the leaflet function for data
    leaflet(map_df) %>%
      
      # Set the default view
      setView(lng = -97.727798, lat = 31.117119 ,zoom =6) %>%
      
      # Provide tiles
      addProviderTiles(providers$OpenStreetMap.Mapnik,options = providerTileOptions(noWrap = TRUE)) %>%
     
      # Add circles
      addCircleMarkers(
        radius = 5,
        lng= map_df$longitude,
        lat= map_df$latitude,
        stroke= FALSE,
        fillOpacity=0.5,
        color=color(AccidentType)
      ) %>%
      
      # Add legends for different types of crime
      addLegend(
        "bottomleft",
        pal=color,
        values=AccidentType,
        opacity=0.5,
        title="Type of Accident Happened"
      )
  })
  
})
