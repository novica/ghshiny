#' ui helpers
#' @noRd
bs5_card <- function(title, subtitle, body) {
  shiny::div(
    class = "card", style = "padding-bottom: 30px;",
    shiny::div(
      class = "card-body",
      shiny::div(class = "card-title", shiny::h4(title)),
      shiny::div(class = "card-subtitle", shiny::div(class = "text-muted", subtitle)),
      shiny::br(),
      body
    ))
}
