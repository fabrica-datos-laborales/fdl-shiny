# input <- list(
#   iso = "USA",
#   mapaslider = 1990
# )

shinyServer(function(input, output, session) {

  output$mapainicio <- renderHighchart({

    dmap <- TABLAS$ictwss %>%
      filter(!is.na(ud)) %>%
      group_by(iso3c, country) %>%
      filter(year == max(year)) %>%
      select(iso3 = iso3c, year, country, ud) %>%
      ungroup() %>%
      rename(value = ud)

    # summarise(dmap, min(value), max(value))

    # dmap

    label <- TABLAS$ictwss %>%
      select(ud) %>%
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

    dmap <- TABLAS$ictwss %>%
      select(iso3 = iso3c, year, country, ud) %>%
      group_by(iso3, country) %>%
      tidyr::fill(ud, .direction = "downup") %>%
      filter(year == input$mapaslider) %>%
      ungroup() %>%
      rename(value = ud)

    highchartProxy("mapainicio") %>%
      hcpxy_update_series(id = "data", data = list_parse(dmap))

    })

# ictwss ------------------------------------------------------------------
  output$ictwss_anio_ud_fem_ud_male <- renderHighchart({

    grafico_anio_tbl_iso_vars(tbl = "ictwss", iso = input$iso, vars = c("ud_fem", "ud_male"))

  })

# wdi ---------------------------------------------------------------------
  output$wdi_anio_gini <- renderHighchart({

    grafico_anio_tbl_iso_vars(tbl = "wdi", iso = input$iso, vars = "gini_in_wdi")

  })

# oecd --------------------------------------------------------------------
  output$oecd_anio_rmw <- renderHighchart({

    grafico_anio_tbl_iso_vars(tbl = "oecd", iso = input$iso, vars = "rmw")

  })

# ilo ---------------------------------------------------------------------
# dpi ---------------------------------------------------------------------
  output$oecd_anio_rmw <- renderHighchart({
    # TABLAS$dpi$dhondt
    # TABLAS$dpi$prop
    # TABLAS$dpi$dhondt
    # grafico_anio_tbl_iso_vars(tbl = "dpi", iso = input$iso, vars = "rmw")

  })
# ilo2 --------------------------------------------------------------------
  output$ilo2_anio_nstrikes_isic31_total <- renderHighchart({

    grafico_anio_tbl_iso_vars(tbl = "ilo", iso = input$iso, vars = "nstrikes_isic31_total")

  })
# iloeplex ----------------------------------------------------------------
  # output$ilo2_anio_nstrikes_isic31_total <- renderHighchart({
  #   # TABLAS$iloeplex$spd_wrep
  #   # grafico_anio_tbl_iso_vars(tbl = "ilo", iso = input$iso, vars = "nstrikes_isic31_total")
  #
  # })

# issp --------------------------------------------------------------------
# vws ---------------------------------------------------------------------
# vdem --------------------------------------------------------------------
# latinobarometro ---------------------------------------------------------

})
