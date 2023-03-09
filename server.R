library("dplyr")
library("ggplot2")
library("plotly")
library("tidyverse")
library("markdown")
library("bslib")
library("maps")
library("mapproj")


# Source files
source("rates_analysis.R")

# Load data
deaths <- read.csv("us-deaths.csv", stringsAsFactors = FALSE)

server <- function(input, output) {
  
  output$map_plot <- renderPlotly({
    
    # Load State map data
    state_shape <- map_data("state")
    
    # Filter all leading causes deaths per state
    deaths_state_data <- deaths %>%
      mutate(state_name = tolower(State)) %>%
      filter(state_name != "united states") %>%
      filter(Year == input$year) %>%
      group_by(state_name) %>%
      filter(Cause.Name != "All causes") %>%
      filter(Deaths == max(Deaths, na.rm = TRUE)) %>%
      select(Year, Cause.Name, Deaths, state_name)
    
    # Join shapefile with deaths data
    state_shape_data <- left_join(state_shape, deaths_state_data, by = c("region" = "state_name"))
    
    # Change theme
    blank_theme <- theme_bw() +
      theme(
        axis.line = element_blank(),
        axis.text = element_blank(),
        axis.ticks = element_blank(),
        axis.title = element_blank(),
        plot.background = element_blank(),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.border = element_blank()
      )
    
    map_plot <- ggplot(data = state_shape_data) +
      geom_polygon(mapping = aes(
        x = long,
        y = lat,
        group = group,
        fill = Cause.Name,
        text = paste(region, ":", Deaths, "Deaths")
      ), color = "black") +
      scale_fill_brewer(palette = "Reds") +
      coord_map() +
      labs(
        title = paste("Leading Cause of Death per State in", input$year) ,
        fill = "Cause") +
      blank_theme
    
    
    return(ggplotly(map_plot, tooltip=c("text")))
  })
  
  output$line_plot <- renderPlotly({
    return(line_plot(deaths, input$obs))
  })
  
  output$bargraph_plot <- renderPlotly({
   
     # Filter for top causes
    bardata_new <- deaths%>%
      filter(Year == input$Year)%>%
      filter(State == "United States")%>%
      filter(Cause.Name != "All causes")
    
    bargraph_plot <- ggplot(bardata_new,aes(x=`Cause.Name`, y= Deaths, fill= `Cause.Name`)) +
      geom_bar(stat = "identity") +
      labs(title = "Top 10 Leading Causes of Deaths in the US" ,
           x = "Cause of Death",
           y = "Number of Deaths") +
      scale_y_continuous(labels = function(x) format(x, scientific = FALSE))+
      theme(axis.text.x = element_text(size = 8, angle = 90, hjust = .5))
    
    return(ggplotly(bargraph_plot))
  })
  
}
