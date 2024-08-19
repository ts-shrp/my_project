library(shiny)
library(leaflet)
library(plotly)
library(ggplot2)
library(dplyr)
library(geosphere)
library(tidygeocoder)
library(shinythemes)

#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {
  geocode_data <- callModule(mod_geocode_server, "geocode")

  filtered_data <- reactive({
    req(input$date_range, input$magnitude)
    data <- earthquake_data %>%
      filter(time >= input$date_range[1] & time <= input$date_range[2],
             mag >= input$magnitude[1] & mag <= input$magnitude[2])

    if (geocode_data$radius_toggle()) {
      req(geocode_data$location())
      loc <- geocode_data$location()

      if (!is.null(loc$lon) && !is.null(loc$lat)) {
        data <- data %>%
          filter(
            geosphere::distHaversine(matrix(c(loc$lon, loc$lat), ncol = 2),
                                     matrix(c(longitude, latitude), ncol = 2)) / 1000 <= geocode_data$radius()
          )
      }
    }

    return(data)
  })

  callModule(mod_map_server, "map", data = filtered_data, geocode_data = geocode_data)
  callModule(mod_chart_server, "chart", data = filtered_data)
}
