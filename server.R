library("dplyr")
library("ggplot2")
library("plotly")
library("tidyverse")
library("markdown")

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
      filter(Year == 2008) %>% # Change to dynamic input/output
      group_by(state_name) %>%
      filter(Cause.Name != "All causes") %>%
      filter(Deaths == max(Deaths, na.rm = TRUE)) %>%
      select(Year, Cause.Name, Deaths, state_name)
    
    View(deaths_state_data)
    
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
        fill = Cause.Name
      ), color = "black") +
      scale_fill_brewer(palette = "Reds") +
      coord_map() +
      labs(
        title = "Leading Cause of Death in US in 2017",
        fill = "Cause") +
      blank_theme
    
    
    return(ggplotly(map_plot))
  })
  
  output$line_plot <- renderPlotly({
    return(line_plot(deaths, input$obs))
  })
  
}