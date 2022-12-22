#' listcollabs UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_listcollabs_ui <- function(id) {
  ns <- NS(id)
  shiny::div(
    class = "container gy-3",
    shiny::selectInput(
      inputId = ns("repo"),
      label = "Repository",
      selected = NULL,
      choices = NULL
    ),
    shiny::selectInput(
      inputId = ns("aff"),
      label = "Affiliation",
      choices = c("outside",
                  "direct",
                  "all"),
      selected = "all",
    ),
    shiny::actionButton(
      inputId = ns("fetchcollabs"),
      label = "Fetch collaborators",
      class = "btn-warning"
    ),
    shiny::br(),
    DT::DTOutput(outputId = ns("collabtable"))
  )
}

#' listcollabs Server Functions
#'
#' @noRd
mod_listcollabs_server <- function(id, config) {
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

    collabs_list <- shiny::reactive({
      shiny::req(config$token)
      shiny::validate(shiny::need(shiny::isTruthy(input$repo), message = "Please enter GitHub repository."))
      shiny::validate(shiny::need(shiny::isTruthy(input$aff), message = "Please select GitHub affiliation."))

      shiny::withProgress(
        ghapi::list_collabs(
          token = config$token,
          owner = config$login,
          repo = input$repo,
          affiliation = input$aff
        ),
        value = 0.5,
        message = "Fetching collaborators. Please wait."
      )
    }) |>
      shiny::bindEvent(input$fetchcollabs)

    output$collabtable <- DT::renderDT({
      collabs_list()
    })
  })
}

## To be copied in the UI
# mod_listcollabs_ui("listcollabs_1")

## To be copied in the server
# mod_listcollabs_server("listcollabs_1")
