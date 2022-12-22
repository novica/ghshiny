#' tokenauth UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_tokenauth_ui <- function(id) {
  ns <- NS(id)
  tagList(
    shiny::passwordInput(inputId = ns("token"), label = "GitHub Personal Access Token"),
    shiny::actionButton(
      inputId = ns("settoken"),
      label = "Set token",
      class = "btn-warning"
    )
  )
}

#' tokenauth Server Functions
#'
#' @noRd
mod_tokenauth_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    # Reactive values to store data
    config_rct <- shiny::reactiveValues(
      token = NULL,
      login = NULL,
      repos = NULL
    )

    # Main observer to populate reactive with config data
    shiny::observe({
      # validate the token
      tryCatch({
        token <- shiny::withProgress(
          ghapi::get_gh_pat(gh_pat = input$token),
          value = 0.8,
          message = "Validating token. Please wait."
        )

        config_rct$token <- token
        shiny::showNotification(ui = "The supplied GitHub PAT validated and set successfully", type = "message")
      }, error = function(x) {
        shiny::showNotification(ui = "The supplied GitHub PAT does not seem to be valid", type = "error")
      })

      # get the login name
      tryCatch({
        login <- shiny::withProgress(
          ghapi::get_gh_login(gh_pat = config_rct$token),
          value = 0.8,
          message = "Getting user login name. Please wait."
        )

        config_rct$login <- login
        shiny::showNotification(ui = sprintf("Fetched login name `%s`", login),
                                type = "message")
      },
      error = function(x) {
        shiny::showNotification(ui = "Could not fetch login name for the supplied token", type = "error")
      })

      # get all repos to populate menus in other repos
      # filter them for visibility the user in repos module
      tryCatch({
        repos <- shiny::withProgress(
          ghapi::list_repositories(visibility = "all", token = config_rct$token),
          value = 0.5,
          message = "Fetching repositories associated with this token. Please wait."
        )
        config_rct$repos <- repos
        shiny::showNotification(ui = sprintf("Fetched repositories for login name `%s`", login),
                                type = "message")
      }, error = function(x) {
        shiny::showNotification(ui = "Could not fetch repositories for this token.", type = "error")
      })

    }) |> shiny::bindEvent(input$settoken)

    # Return to be used in other modules
    return(config_rct)
  })

}

## To be copied in the UI
# mod_tokenauth_ui("tokenauth_1")

## To be copied in the server
# mod_tokenauth_server("tokenauth_1")
