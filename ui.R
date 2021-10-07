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
            bs4TabItems(
                # inicio ------------------------------------------------------------------
                bs4TabItem(
                    tabName = "inicio",
                    fluidRow(
                        box(
                            highchartOutput("mapainicio", height = 600),
                            width = 12
                            ),
                        box(
                            title = "Controls",
                            sliderInput("mapaslider", "Number of observations:", 1960, 2018, 2018)
                            )
                        )
                    )

                )
        )
)
