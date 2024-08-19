#' map UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_map_ui <- function(id) {
  ns <- NS(id)
  leafletOutput(ns("map"), height = "600px", width = "100%")
}

#' map Server Functions
#'
#' @noRd
mod_map_server <- function(input, output, session, data, geocode_data) {
  output$map <- renderLeaflet({
    map <- leaflet() %>%
      addTiles()

    if (geocode_data$radius_toggle()) {
      req(geocode_data$location())
      loc <- geocode_data$location()

      if (!is.null(loc$lon) && !is.null(loc$lat)) {
        map <- map %>%
          addCircles(
            lng = loc$lon, lat = loc$lat,
            radius = geocode_data$radius() * 1000,
            color = "green",
            fillColor = "green",
            fillOpacity = 0.2,
            stroke = TRUE,
            layerId = "radius_circle",
            group = "radius"
          )
      }
    }

    if (nrow(data()) > 0) {
      pal <- colorNumeric(
        palette = c("blue", "red"),
        domain = data()$mag
      )

      map <- map %>%
        addCircleMarkers(
          data = data(),
          lng = ~longitude, lat = ~latitude,
          radius = ~mag * 0.5,
          color = ~pal(mag),
          fillOpacity = 0.7,
          popup = ~paste("<strong>Location:</strong>", place, "<br>",
                         "<strong>Magnitude:</strong>", mag, "<br>",
                         "<strong>Depth:</strong>", depth, "km<br>",
                         "<strong>Date:</strong>", as.Date(time)),
          label = ~paste("Magnitude:", mag, "| Depth:", depth, "km"),
          labelOptions = labelOptions(noHide = FALSE, direction = 'auto'),
          options = markerOptions(zIndexOffset = 1000)
        )

      if (!is.null(pal)) {
        map <- map %>%
          addLegend(
            "bottomright",
            pal = pal,
            values = data()$mag,
            title = "Magnitude",
            opacity = 1
          )
      }
    } else {
      showNotification("No earthquake data within the selected radius and date range.", type = "warning")
    }

    return(map)
  })
}

## To be copied in the UI
# mod_map_ui("map_1")

## To be copied in the server
# mod_map_server("map_1")
