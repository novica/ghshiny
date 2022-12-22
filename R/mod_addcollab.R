#' addcollab UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_addcollab_ui <- function(id) {
  ns <- NS(id)
  tagList(
    shiny::uiOutput(outputId = ns("login_info")),
    shiny::selectInput(
      inputId = ns("repo"),
      label = "Repository",
      selected = NULL,
      choices = NULL),
    shiny::textInput(inputId = ns("user"), label = "User"),
    shiny::selectInput(
      inputId = ns("perm"),
      label = "Persmission",
      choices = c("pull", "triage", "push", "maintain", "admin"),
      selected = "admin"
    ),
    shiny::actionButton(
      inputId = ns("addcollab"),
      label = "Add repo collaborator",
      class = "btn-warning"
    )
  )
}

#' addcollab Server Functions
#'
#' @noRd
mod_addcollab_server <- function(id, config) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    # Render some info for the user
    output$login_info <- shiny::renderUI({
      shiny::div(class = "alert alert-info", sprintf("Current user: %s", config$login))
    }) |> shiny::bindEvent(config$login)

    # Update the repo dropdown based on user's repos
    shiny::observe({

      shiny::updateSelectInput(
        inputId = "repo",
        choices = config$repos$name,
        selected = NULL
      )
    }) |> shiny::bindEvent(config$repos)

    shiny::observe({
      shiny::req(config$token)
      shiny::req(config$login)
      shiny::req(input$user)
      shiny::req(input$perm)

      tryCatch({
        response <-
          ghapi::add_collabs(
            token = config$token,
            owner = config$login,
            repo = input$repo,
            user = input$user,
            permission = input$perm
          )
      }, error = function(e) {
        logger::log_error(e$message)
        shiny::showNotification("Could not connect to the API.")
        })

      if (isTRUE(response$status_code == 201)) {
        shiny::showNotification(ui = "Update complete!", type = "message")
      } else {
        shiny::showNotification(ui = "Could not complete update request!", type = "error")
      }
    }) |>
      shiny::bindEvent(input$addcollab)

  })
}

## To be copied in the UI
# mod_addcollab_ui("addcollab_1")

## To be copied in the server
# mod_addcollab_server("addcollab_1")
