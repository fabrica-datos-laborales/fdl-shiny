input <- list(
    mapaslider = 1990
)

shinyServer(function(input, output, session) {

    output$mapainicio <- renderHighchart({

        ictwss <- readRDS(url("https://github.com/fabrica-datos-laborales/fdl-data/blob/main/output/data/proc/ictwss.rds?raw=true"))

        dmap <- ictwss %>%
            filter(!is.na(UD)) %>%
            group_by(iso3c, country) %>%
            filter(year == max(year)) %>%
            select(iso3 = iso3c, year, country, UD) %>%
            ungroup()

        dmap

        label <- ictwss %>%
            select(UD) %>%
            pull() %>%
            attr("label")

        label

        color_stops_index <- color_stops(colors = c("white", PARS$color_main), n = 10)

        # fuente:
        # https://github.com/jbkunst/highcharter/blob/main/pkgdown/index.Rmd#L84
        pmap  <- hcmap(
            "custom/world-robinson-lowres",
            id = "data",
            data = dmap,
            name = label,
            value = "UD",
            borderWidth = 1,
            joinBy = c("iso-a3", "iso3"),
            nullColor = "#D8D8D8"
        ) %>%
            hc_colorAxis(stops = color_stops_index, type = "logarithmic") %>%
            hc_legend(symbolWidth = 500, align = "center", verticalAlign = "bottom") %>%
            hc_mapNavigation(enabled = TRUE) %>%
            hc_credits(enabled = FALSE, text = "Fuente: Una importante institución") %>%
            hc_tooltip(
                valueDecimals = 2,
                pointFormat = "{point.country}: <b>{point.value}%</b> (year: {point.year})<br/>"
                )

        pmap


    })

    # observeEvent(input$mapaslider, {
    #
    #     dmap <- ictwss %>%
    #         select(iso3 = iso3c, year, country, UD) %>%
    #         group_by(iso3, country) %>%
    #         tidyr::fill(UD, .direction = "downup")
    #
    #     dmap <- dmap %>%
    #         filter(year == input$mapaslider) %>%
    #         ungroup()
    #
    #     message(input$mapaslider)
    #
    #     print(dmap)
    #
    #     highchartProxy("mapainicio") %>%
    #         hcpxy_update_series(
    #             id = "data",
    #             data = list_parse(dmap),
    #             joinBy = c("iso-a3", "iso3")
    #         )
    #
    # })

})
