#death rates for the top three categories

library("dplyr")
library("ggplot2")
library("plotly")
library("tidyverse")

line_plot <- function(data, input) {
  death_rates_2017 <- data %>%
    filter(Year == 2017) %>%
    filter(State == "United States") %>%
    filter(Cause.Name != "All causes") %>% 
    select(Cause.Name, Age.adjusted.Death.Rate)
  
  # Select the top 3 causes of death
  top_3_causes <- death_rates_2017 %>%
    arrange(desc(Age.adjusted.Death.Rate)) %>%
    slice_head(n = 3) %>%
    pull(Cause.Name)
  
  # Filter the data for the top 3 causes of death
  top_3_death_rates <- data %>%
    filter(Cause.Name %in% top_3_causes) %>% 
    filter(State == "United States") %>% 
    filter(Year <= input)
    
  
  # Create the line graph
  plot <- ggplot(top_3_death_rates, aes(x = Year, y = Age.adjusted.Death.Rate, color = Cause.Name)) +
    geom_line() +
    labs(title = "Age-Adjusted Death Rates for Top 3 Leading Causes of Death in the US",
         x = "Year",
         y = "Death Rate (per 100,000 population)") +
    scale_y_continuous(labels = scales::comma_format()) +
    theme_bw()
  
  return(ggplotly(plot))
}
