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
                    text = "WDI",
                    tabName = "wdi",
                    # icon =  "tachometer-alt",
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
                        box(plotOutput("plot1", height = 250)),
                        box(
                            title = "Controls",
                            sliderInput("slider", "Number of observations:", 1, 100, 50)
                            )
                        )
                    )

                )
        )
)
