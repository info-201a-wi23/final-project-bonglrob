library(shiny)
library(plotly)

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
          min = 1999,
          max = 2017,
          value = 2017
        )
      ),
    mainPanel(
      plotlyOutput("map_plot"),
      h1("About this Chart:"),
      p("Key Insights")
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
        plotlyOutput("line_plot")
      )
    )
  )
)


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
  #viz_death_categories_tab,
  conclusion_tab
)