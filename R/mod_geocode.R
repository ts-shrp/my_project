#' geocode UI Function
#'
#' @description A shiny Module to geocode a location and set a radius.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
mod_geocode_ui <- function(id) {
  ns <- NS(id)
  tagList(
    textInput(ns("location"), "Enter Location", placeholder = "e.g., Tokyo, Japan"),
    actionButton(ns("geocode_btn"), "Geocode"),
    tags$div(style = "margin-bottom: 20px;"),
    numericInput(ns("radius"), "Radius (km)", value = 50, min = 1),
    checkboxInput(ns("radius_toggle"), "Filter by Radius", value = FALSE)
  )
}

#' geocode Server Functions
#'
#' @noRd
mod_geocode_server <- function(input, output, session) {
  geocoded_location <- reactiveVal(NULL)

  observeEvent(input$geocode_btn, {
    req(input$location)
    location_data <- tidygeocoder::geo(input$location, method = 'osm', full_results = TRUE)
    if (!is.null(location_data) && nrow(location_data) > 0) {
      geocoded_location(list(lon = as.numeric(location_data$long), lat = as.numeric(location_data$lat)))
    } else {
      showNotification("Location not found, please try again.", type = "error")
    }
  })

  return(list(
    location = geocoded_location,
    radius = reactive(input$radius),
    radius_toggle = reactive(input$radius_toggle)
  ))
}
