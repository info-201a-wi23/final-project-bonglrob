library("ggplot2")
library("tidyverse")
library("dplyr")
library("plotly")



#Load data
deaths <- read.csv("~/Downloads/NCHS_-_Leading_Causes_of_Death__United_States.csv")

# Filter for top causes
bardata_new <- deaths%>%
  filter(Year == 2017)%>%
  filter(State == "United States")%>%
  filter(Cause.Name != "All causes")

#create bar graph 
bargraph_plot <- ggplot(bardata_new,aes(x=`Cause.Name`, y= Deaths, fill= `Cause.Name`)) +
  geom_bar(stat = "identity") +
  labs(title = "Top 10 Leading Causes of Deaths in the US" ,
       x = "Cause of Death",
       y = "Number of Deaths") +
  scale_y_continuous(labels = function(x) format(x, scientific = FALSE))+
  theme(axis.text.x = element_text(size = 8, angle = 90, hjust = .5))

ggplotly(bargraph_plot)
