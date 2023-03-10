library(shiny)
library(plotly)
library(bslib)
library(httr)

my_theme <- bs_theme(
  bg = "#cfe2f3",
  fg = "#191919",
  primary = "white"
)

intro_tab <- tabPanel(
  "Introduction",
  fluidPage(
    includeMarkdown("introduction.Rmd")
  )
)

year_slider <- sliderInput(
  inputId = "range",
  label = "Years",
  min = 1999,
  max = 2017,
  value = 2000
)


viz_map_tab <- tabPanel(
  "Map",
  fluidPage(
    titlePanel("Leading Causes of Death Across States"),
    
    sidebarLayout(
      sidebarPanel(
        sliderInput(
          inputId = "year",
          label = "Years",
          min = 2000,
          max = 2017,
          value = 2017
        )
      ),
    mainPanel(
      plotlyOutput("map_plot"),
      h1("About this Map:"),
      p("This visualization shows a map of the United States and the leading cause of death for each state of that particular year. Leading cause of death is calculated by most deaths for a disease in the year. The purpose of this map is to showcase if there is any correlation of certain regions of the United States that are known for a certain type of death."),
      h2("Key Insights"),
      p("At a first glance, heart disease and cancer are the main causes of death as other causes of death cannot top the number of cases these 2 have. Dominantly, heart disease tops the chart. Washington state consistently has their main cause of death be cancer. One possible reason for this is that due to Fred Hutchinson Cancer Research Center being located there."),
    )
  )
))

viz_death_rates_tab <- tabPanel(
  "Line Graph",
  fluidPage(
    titlePanel("Age-Adjusted Death Rates for Top 3 Leading Causes of Death in the US"),
    
    sidebarLayout(
      sidebarPanel(
        sliderInput(
          inputId = "obs",
          label = "Years",
          min = 1999,
          max = 2017,
          value = 2010
        )
      ),
      mainPanel(
        plotlyOutput("line_plot"),
        h1("About this graph:"),
        p("This visualization displays the top three leading causes of death and their death rates for any specific year chosen within the given range. The purpose of this map is to show how the death rates for these leading causes may fluctuate over time. This can be useful in considering what may be contributors to these causes, when events of the corresponding years can be tracked back to them."),
        h2("Key Insights"),
        p("We are able to see from the line graphs that each of the three leading causes fluctuate throughout the years. In a broader sense, it is less difficult to compare whether or not one leading cause affects the United States population more than another leading cause."),
      )
    )
))
viz_death_categories_tab <- tabPanel(
  "Bar Graph",
  fluidPage(
    titlePanel("Top 10 Causes of Death in the US"),
  
  
  sidebarLayout(
    sidebarPanel(
      sliderInput(
        inputId = "Year",
        label = "Years",
        min = 1999,
        max = 2017,
        value = 2017
      )
    ),
    mainPanel(
      plotlyOutput("bargraph_plot"),
      h1("About this Bar Chart:"),
      p("This Visualization displays a bar chart of the top ten leading causes of death in the united states depending on the year chosen from the given range between 1999 and 2017. The purpose of this bar chart is to show the changes in the number of deaths for each cause throughout the years."),
      h1("Key Insights"),
      p("Over the years, we can see how heart disease continues to be the leading cause of death, followed by cancer. But, we can also see how the other causes slowly increase their number of deaths."),
    )
  )
))

conclusion_tab <- tabPanel(
  "Conclusion",
  fluidPage(
    includeMarkdown("conclusion.Rmd")
  )
)

ui <- navbarPage(
  theme = my_theme,
  "US Deaths",
  intro_tab,
  viz_map_tab,
  viz_death_rates_tab,
  viz_death_categories_tab,
  conclusion_tab
)