#
# https://docs.google.com/spreadsheets/d/1aw_byhiC4b_0XPcTDtsCpCeJHabK38i4pCmkHshYMB8/edit#gid=1674849507
#
# paquetes ----------------------------------------------------------------
library(shiny)
library(bs4Dash)          # remotes::install_github("RinteRface/bs4Dash", force = TRUE)
library(tidyverse)
library(highcharter)      # remotes::install_github("jbkunst/highcharter", force = TRUE)
library(tradestatistics)
library(haven)

# parámetros --------------------------------------------------------------
PARS <- list(
  # color pricipal, main color
  color_main = "#EC1E28",
  verbose    = FALSE,
  hcheight   = 500,
  url_data   = "https://github.com/fabrica-datos-laborales/fdl-data/blob/main/output/data/proc/"
)

# opciones ----------------------------------------------------------------
options(
  # highcharter.lang = newlang_opts,
  # highcharter.google_fonts = FALSE,
  highcharter.theme =
    hc_theme_smpl(
      tooltip = list(
        valueDecimals = 2
      ),
      plotOptions = list(
        series = list(
          animation = list(duration = 0),
          marker = list(symbol = "circle", enabled = FALSE)
        )
      )
    )
)


# data --------------------------------------------------------------------
TABLAS <- list(
  ictwss   = readRDS(url(file.path(PARS$url_data, "ictwss.rds?raw=true"))),
  wdi      = readRDS(url(file.path(PARS$url_data, "wdi.rds?raw=true"))),
  oecd     = readRDS(url(file.path(PARS$url_data, "oecd.rds?raw=true"))),
  ilo      = readRDS(url(file.path(PARS$url_data, "ilo-stat.rds?raw=true"))),
  dpi      = readRDS(url(file.path(PARS$url_data, "dpi.rds?raw=true"))),
  iloeplex = readRDS(url(file.path(PARS$url_data, "iloeplex.rds?raw=true")))
)

TABLAS <- TABLAS %>%
  map(tibble) %>%
  # map(~ .x %>% mutate(across(where( ~ "labelled" %in% class(.x)), as.character))) %>%
  map(~ .x %>% mutate(across(matches("year"), as.numeric))) %>%
  map(rename_all, str_to_lower)

ots_countries <- tradestatistics::ots_countries %>%
  as_tibble() %>%
  mutate(iso3c = str_to_upper(country_iso))

glimpse(ots_countries)

# choices -----------------------------------------------------------------
PAISES_OPCIONES <- TABLAS$wdi %>%
    # select(value = iso3c, name = country) %>%
    select(country, iso3c) %>%
    filter(complete.cases(.)) %>%
    distinct() %>%
    deframe()


# helpers -----------------------------------------------------------------
get_name_from_iso <- function(iso3c) {
  names(PAISES_OPCIONES[PAISES_OPCIONES == iso3c])
}

grafico_anio_tbl_iso_vars <- function(tbl = "wdi", iso = "USA", vars = c("gini_in_wdi"), verbose = PARS$verbose){

  if(verbose) {
    message("grafico_anio_tbl_iso_vars:")
    message(str_glue("\ttbl {tbl}\n\tiso {iso}\n\tvars: {vars}"))
  }

  df <- TABLAS[[tbl]]

  df <- df %>%
    filter(iso3c == iso) %>%
    select(x = year, all_of(vars))

  df <- df %>%
    gather(group, y, -x) %>%
    arrange(x, group) %>%
    filter(complete.cases(.))

  if(length(vars) == 1) {
    df <- df %>%
      mutate(group = get_name_from_iso(iso))
  }

  highchart() %>%
    hc_legend(layout = "proximate", align = "right") %>%
    hc_add_series(df, "line", hcaes(x, y, group = group))

}


