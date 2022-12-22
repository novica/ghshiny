#' updatedesc UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_updatedesc_ui <- function(id){
  ns <- NS(id)
  tagList(
    shiny::selectInput(
      inputId = ns("repo"),
      label = "Repository",
      selected = NULL,
      choices = NULL),
    shiny::textAreaInput(inputId = ns("desc"), label = "Description"),
    shiny::actionButton(inputId = ns("updatedesc"), label = "Update repo description",  class = "btn-warning")
  )
}

#' updatedesc Server Functions
#'
#' @noRd
mod_updatedesc_server <- function(id, config) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    # Update the repo dropdown based on user's repos
    shiny::observe({

      shiny::updateSelectInput(
        inputId = "repo",
        choices = config$repos$name,
        selected = NULL
      )
    }) |> shiny::bindEvent(config$repos)

    shiny::observe({
      shiny::req(config$login)
      shiny::req(config$repos$name)
      shiny::req(input$desc)

      tryCatch({
        response <-
          ghapi::update_desc(
            token = config$token,
            user = config$login,
            repo = input$repo,
            desc = input$desc
          )
      }, error = function(e) {
        logger::log_error(e$message)
        shiny::showNotification("Could not connect to the API.")
      })


      if (isTRUE(response$status_code == 200)) {
        shiny::showNotification(ui = "Update complete!", type = "message")
      } else {
        shiny::showNotification(ui = "Could not complete update request!", type = "error")
      }

    }) |>
      shiny::bindEvent(input$updatedesc)

  })
}

## To be copied in the UI
# mod_updatedesc_ui("updatedesc_1")

## To be copied in the server
# mod_updatedesc_server("updatedesc_1")
