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
tbls <- c("ictwss", "wdi", "oecd", "ilo-stat",
          "dpi", "iloeplex", "issp", "wvs", "vdem", "latino")

if(!file.exists("data/tablas.rds")) {

  TABLAS <- tbls %>%
    map(str_c, ".rds?raw=true") %>%
    map(~ file.path(PARS$url_data, .x)) %>%
    map(url) %>%
    map(readRDS) %>%
    map(as_tibble) %>%
    map(~ .x %>% mutate(across(matches("year"), as.numeric))) %>%
    map(rename_all, str_to_lower) %>%
    set_names(tbls)

  rm(tbls)

  saveRDS(TABLAS, "data/tablas.rds")

} else {

  TABLAS <- readRDS("data/tablas.rds")

}

ots_countries <- tradestatistics::ots_countries %>%
  as_tibble() %>%
  mutate(iso3c = str_to_upper(country_iso))

glimpse(ots_countries)


dcodigos <- read_csv("data/libro-codigos-fdl-variables.csv")
dcodigos <- janitor::clean_names(dcodigos)
dcodigos <- dcodigos %>%
  mutate(definicion = coalesce(definicion_en_espanol, definicion_en_ingles))
#
# dcodigos %>%
#   filter(str_detect(nombre_de_variable, "ud_male"))

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


  # tbl = "ictwss"
  # iso = "USA"
  # vars = c("ud_fem", "ud_male")

  # tbl = "wdi"
  # iso = "USA"
  # vars = "gini_in"

  dcodigos2 <- dcodigos %>%
    # select(nombre_de_variable, definicion) %>%
    filter(str_detect(nombre_de_variable, str_c(vars, collapse = "|"))) %>%
    mutate(
      nombre_de_variable = str_remove(nombre_de_variable, str_c("_", tbl)),
      nombre_de_variable = str_trim(nombre_de_variable)
      )

  glimpse(dcodigos2)

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

  # if(length(vars) == 1) {
  #   df <- df %>%
  #     mutate(group = get_name_from_iso(iso))
  # } else {

    df <- df %>%
      left_join(dcodigos2 %>% select(nombre_de_variable, definicion), by = c("group" = "nombre_de_variable")) %>%
      select(-group) %>%
      rename(group = definicion)
#
#   }

  highchart() %>%
    hc_legend(align = "left", verticalAlign = "top") %>%
    hc_tooltip(table = TRUE) %>%
    hc_add_series(df, "line", hcaes(x, y, group = group))

}


