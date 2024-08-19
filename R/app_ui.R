#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_ui <- function(request) {
  fluidPage(
    shinythemes::themeSelector(),

    titlePanel("Earthquake Data"),
    sidebarLayout(
      sidebarPanel(
        tags$h3("Location and Radius"),
        mod_geocode_ui("geocode"),
        hr(),

        tags$h3("Date Range Filter"),
        dateRangeInput("date_range", "Date Range",
                       start = min(earthquake_data$time),
                       end = max(earthquake_data$time)),
        hr(),

        tags$h3("Magnitude Filter"),
        sliderInput("magnitude", "Magnitude",
                    min = min(earthquake_data$mag),
                    max = max(earthquake_data$mag),
                    value = range(earthquake_data$mag)),
        hr(),

        width = 3
      ),
      mainPanel(
        tabsetPanel(
          tabPanel("Map", mod_map_ui("map")),
          tabPanel("Chart", mod_chart_ui("chart"))
        ),
        width = 9
      )
    )
  )
}

#' Add external Resources to the Application
#'
#' This function is internally used to add external
#' resources inside the Shiny application.
#'
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
golem_add_external_resources <- function() {
  add_resource_path(
    "www",
    app_sys("app/www")
  )

  tags$head(
    favicon(),
    bundle_resources(
      path = app_sys("app/www"),
      app_title = "earthquake"
    )
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert()
  )
}
