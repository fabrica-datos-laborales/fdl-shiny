input <- list(
    mapaslider = 1990
)

ictwss <- readRDS(url("https://github.com/fabrica-datos-laborales/fdl-data/blob/main/output/data/proc/ictwss.rds?raw=true"))

shinyServer(function(input, output, session) {

  output$mapainicio <- renderHighchart({

    dmap <- ictwss %>%
      filter(!is.na(UD)) %>%
      group_by(iso3c, country) %>%
      filter(year == max(year)) %>%
      select(iso3 = iso3c, year, country, UD) %>%
      ungroup() %>%
      rename(value = UD)

    # summarise(dmap, min(value), max(value))

    # dmap

    label <- ictwss %>%
      select(UD) %>%
      pull() %>%
      attr("label")

    label

    color_stops_index <- color_stops(colors = c("white", PARS$color_main), n = 10)

    pmap  <- highchart(type = "map") %>%
      hc_chart(map = JS("Highcharts.maps['custom/world-robinson-highres']")) %>%
      hc_add_series(
        id = "data",
        name = label,
        data = list_parse(dmap)
        ) %>%
      hc_plotOptions(map = list(joinBy = c("iso-a3", "iso3"))) %>%
      hc_colorAxis(stops = color_stops_index, type = "logarithmic", min = 1, max = 100) %>%
      hc_legend(symbolWidth = 500, align = "center", verticalAlign = "bottom") %>%
      # hc_mapNavigation(enabled = TRUE) %>%
      hc_credits(enabled = FALSE, text = "Fuente: Una importante institución") %>%
      hc_tooltip(
        valueDecimals = 2,
        pointFormat = "{point.country}: <b>{point.value}%</b> (year: {point.year})<br/>"
        )

    pmap

  })

  observeEvent(input$mapaslider, {

    message(str_c("observeEvent(input$mapaslider: ", input$mapaslider))

    dmap <- ictwss %>%
      select(iso3 = iso3c, year, country, UD) %>%
      group_by(iso3, country) %>%
      tidyr::fill(UD, .direction = "downup") %>%
      filter(year == input$mapaslider) %>%
      ungroup() %>%
      rename(value = UD)

    highchartProxy("mapainicio") %>%
      hcpxy_update_series(id = "data", data = list_parse(dmap))

    })

})
