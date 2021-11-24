dashboardPage(
  title = "FDL",
  dark = NULL,

  dashboardHeader(disable = FALSE),

  dashboardSidebar(
    bs4DashSidebar(
      title = NULL,
      expand_on_hover = TRUE,
      fixed = FALSE,
      skin = "light",
      bs4SidebarMenu(
        id = "current_tab",
        bs4SidebarMenuItem(
          text = "Inicio",
          tabName = "inicio",
          icon = shiny::icon("globe")
          ),
        bs4SidebarMenuItem(
          text = "WDI",
          tabName = "wdi",
          icon = shiny::icon("globe")
          ),
        bs4SidebarMenuItem(
          text = "OECD",
          tabName = "oecd",
          icon = shiny::icon("flag")
          )
        )
      )
    ),
  dashboardBody(
    tags$head(tags$link(rel = "stylesheet", type = "text/css", href = "css/fdl.css")),
    tags$script(src = "https://code.highcharts.com/mapdata/custom/world-robinson-highres.js"),
    bs4TabItems(
      # inicio ------------------------------------------------------------------
      bs4TabItem(
        tabName = "inicio",
        fluidRow(
          box(
            sliderInput(inputId = "mapaslider", label = NULL, min = 1960, max = 2018, value = 2018, animate = TRUE, sep = ""),
            highchartOutput("mapainicio", height = 600),
            width = 12
            )
          )
        )
      )
    )
  )
