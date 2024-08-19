#' chart UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_chart_ui <- function(id) {
  ns <- NS(id)
  plotlyOutput(ns("chart"), height = "600px", width = "100%")
}

#' chart Server Functions
#'
#' @noRd
mod_chart_server <- function(input, output, session, data) {
  output$chart <- renderPlotly({
    req(data())

    p <- ggplot(data(), aes(x = as.Date(time), y = mag, text = paste(
      "Location:", place, "<br>",
      "Magnitude:", mag, "<br>",
      "Depth:", depth, "km<br>",
      "Date:", as.Date(time)
    ))) +
      geom_jitter(color = "red", size = 2, width = 0.1, alpha = 0.6) +
      labs(title = "Earthquake Magnitude Over Time", x = "Date", y = "Magnitude") +
      scale_y_continuous(limits = c(4.5, 8.5)) +
      theme_minimal() +
      theme(
        plot.title = element_text(size = 18, face = "bold"),
        axis.title.x = element_text(size = 14),
        axis.title.y = element_text(size = 14),
        axis.text.x = element_text(size = 12),
        axis.text.y = element_text(size = 12)
      )

    ggplotly(p, tooltip = "text") %>%
      layout(
        hoverlabel = list(bgcolor = "white", font = list(color = "black")),
        title = list(text = "Earthquake Magnitude Over Time"),
        margin = list(t = 50, b = 50, l = 50, r = 50)
      )
  })
}

## To be copied in the UI
# mod_chart_ui("chart_1")

## To be copied in the server
# mod_chart_server("chart_1")
