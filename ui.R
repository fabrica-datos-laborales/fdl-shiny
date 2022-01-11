dashboardPage(
  title = "FDL",
  dark = NULL,

  dashboardHeader(disable = FALSE),

  dashboardSidebar(
    bs4DashSidebar(
      title = "FDL",
      collapsed = FALSE,
      fixed = TRUE,
      minified = FALSE,
      expand_on_hover = FALSE,
      bs4SidebarMenu(
        id = "current_tab",
        selectInput(inputId = "iso", label = NULL, choices = PAISES_OPCIONES, selected = "USA"),
        bs4SidebarMenuItem(
          text = "Inicio",
          tabName = "inicio",
          icon = shiny::icon("home")
          ),
        bs4SidebarMenuItem(
          text = "ICTWSS",
          tabName = "ictwss"
          ),
        bs4SidebarMenuItem(
          text = "WDI",
          tabName = "wdi"
          ),
        bs4SidebarMenuItem(
          text = "OECD",
          tabName = "oecd"
          ),
        bs4SidebarMenuItem(
          text = "ILO",
          tabName = "ilo"
          ),
        bs4SidebarMenuItem(
          text = "DPI",
          tabName = "dpi"
          ),
        bs4SidebarMenuItem(
          text = "ILO2",
          tabName = "ilo2"
          ),
        bs4SidebarMenuItem(
          text = "ILOEPLEX",
          tabName = "iloeplex"
          ),
        bs4SidebarMenuItem(
          text = "ISSP",
          tabName = "issp"
          ),
        bs4SidebarMenuItem(
          text = "VWS",
          tabName = "vws"
          ),
        bs4SidebarMenuItem(
          text = "VDEM",
          tabName = "vdem"
          ),
        bs4SidebarMenuItem(
          text = "Latinobarometro",
          tabName = "latinobarometro"
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
            highchartOutput("mapainicio", height = PARS$hcheight),
            width = 12
            )
          )
        ),
      # ictwss ---------------------------------------------------------------------
      bs4TabItem(
        tabName = "ictwss",
        fluidRow(
          box(width = 12, highchartOutput("ictwss_anio_ud_fem_ud_male", height = PARS$hcheight)),
          box(width =  6, highchartOutput("ictwss_anio_art", height = PARS$hcheight)),


        )
      ),
      # wdi ---------------------------------------------------------------------
      bs4TabItem(
        tabName = "wdi",
        fluidRow(
          box(width = 6, highchartOutput("wdi_anio_gini", height = PARS$hcheight))
          )
        ),
      # oecd --------------------------------------------------------------------
      bs4TabItem(
        tabName = "oecd",
        fluidRow(
          box(width = 6, highchartOutput("oecd_anio_rmw", height = PARS$hcheight))
          )
        ),

      # ilo ---------------------------------------------------------------------
      # dpi ---------------------------------------------------------------------
      bs4TabItem(
        tabName = "dpi",
        fluidRow(
          box(width = 6, highchartOutput("dpi_anio_rmw", height = PARS$hcheight))
        )
      ),
      # ilo2 --------------------------------------------------------------------
      bs4TabItem(
        tabName = "ilo2",
        fluidRow(
          box(width = 6, highchartOutput("ilo2_anio_nstrikes_isic31_total", height = PARS$hcheight))
        )
      ),
      # iloeplex ----------------------------------------------------------------
      bs4TabItem(
        tabName = "iloeplex",
        fluidRow(
          # box(width = 6, highchartOutput("ilo2_anio_nstrikes_isic31_total", height = PARS$hcheight))
        )
      )
      # issp --------------------------------------------------------------------
      # vws ---------------------------------------------------------------------
      # vdem --------------------------------------------------------------------
      # latinobarometro ---------------------------------------------------------




      )
    )
  )
