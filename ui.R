intro_tab <- tabPanel(
  "Introduction",
  fluidPage(
    includeMarkdown("introduction.Rmd")
  )
)

viz_map_tab <- tabPanel(
  "Map",
  fluidPage(
    titlePanel("Leading Causes of Death Across States"),
    
    sidebarLayout(
      sidebarPanel(
        sliderInput(
          inputId = "range",
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


conclusion_tab <- tabPanel(
  "Conclusion",
  fluidPage(
    includeMarkdown("conclusion.Rmd")
  )
)

ui <- navbarPage(
  "US Deaths",
  intro_tab,
  viz_map_tab,
  #viz_death_rates_tab,
  #viz_death_categories_tab,
  conclusion_tab
)