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
        # Insert widget here (Time Slider)
      )
    ),
    
    mainPanel(
      # Insert viz
    )
  )
)

conclusion_tab <- tabPanel(
  "Conclusion",
  fluidPage(
    insertMarkdown("conclusion.Rmd")
  )
)

ui <- navbarPage(
  "US Deaths",
  intro_tab,
  viz_map_tab,
  viz_death_rates_tab,
  viz_death_categories_tab,
  conclusion_tab
)