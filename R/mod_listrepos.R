#' listrepos UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_listrepos_ui <- function(id) {
  ns <- NS(id)
  shiny::div(
    class = "container gy-3",
    shiny::selectInput(
      inputId = ns("vis"),
      label = "Visibility",
      choices = c("private",
                  "public",
                  "all"),
      selected = "all",
    ),
    shiny::actionButton(
      inputId = ns("fetchrepos"),
      label = "Show repositories",
      class = "btn-warning"
    ),
    DT::DTOutput(outputId = ns("repotable"))
  )
}

#' listrepos Server Functions
#'
#' @noRd
mod_listrepos_server <- function(id, config) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    output$repotable <- DT::renderDT({
      shiny::req(config$repos)
      shiny::req(input$vis)

      visibility <-
        switch(input$vis,
               "private" = TRUE,
               "public" = FALSE,
               "all" = c(TRUE, FALSE))

      config$repos[config$repos$private %in% visibility, ]
    }) |> shiny::bindEvent(input$fetchrepos)
  })
}

## To be copied in the UI
# mod_listrepos_ui("listrepos_1")

## To be copied in the server
# mod_listrepos_server("listrepos_1")
