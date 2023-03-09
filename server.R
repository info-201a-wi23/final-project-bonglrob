library("dplyr")
library("ggplot2")
library("plotly")
library("tidyverse")
library("markdown")
library("bslib")
library("DT")


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
    
    death_rates_2017 <- deaths %>%
      filter(Year == input$range) %>%
      filter(State == "United States") %>%
      filter(Cause.Name != "All causes") %>% 
      select(Cause.Name, Age.adjusted.Death.Rate)
    
    # Select the top 3 causes of death
    top_3_causes <- death_rates_2017 %>%
      arrange(desc(Age.adjusted.Death.Rate)) %>%
      slice_head(n = 3) %>%
      pull(Cause.Name)
    
    # Filter the data for the top 3 causes of death
    top_3_death_rates <- deaths %>%
      filter(Cause.Name %in% top_3_causes) %>% 
      filter(State == "United States")
    
    # Create the line graph
    line_plot <- ggplot(top_3_death_rates, aes(x = Year, y = Age.adjusted.Death.Rate, color = Cause.Name)) +
      geom_line() +
      labs(title = "Age-Adjusted Death Rates for Top 3 Leading Causes of Death in the US",
           x = "Year",
           y = "Death Rate (per 100,000 population)") +
      scale_y_continuous(labels = scales::comma_format()) +
      theme_bw()
    
    return(ggplotly(line_plot))
  })
  
}