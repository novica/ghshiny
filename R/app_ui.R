#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_ui <- function(request) {
  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),
    # Your application UI logic
    shiny::navbarPage(
      id = "navbar",
      title = "SHINY GITHUB API",
      theme = bslib::bs_theme(version = 5, bootswatch = "zephyr"),
      shiny::tabPanel(
        title = "Authentication",
        value = "auth",
        shiny::div(class = "container-fluid gx-3 gy-3",
                   shiny::div(
                     class = "row",
                     shiny::column(
                       width = 4,
                       bs5_card(
                         title = "GitHub Authentication",
                         subtitle = "Set your GitHub personal access token to access the API",
                         body = mod_tokenauth_ui("tokenauth_1")
                       )
                     )
                   ))
      ),
      shiny::tabPanel(
        title = "Repositories",
        value = "repos",
        shiny::div(
          class = "container-fluid gx-3 gy-3",
          shiny::div(
            class = "row",
            shiny::column(
              width = 6,
              bs5_card(
                title = "Repositories",
                subtitle = "Retrieve a list of all repositories associated with the GitHub token",
                body = mod_listrepos_ui("listrepos_1")
              )
            ),
            shiny::column(
              width = 6,
              bs5_card(
                title = "Update description",
                subtitle = "Update the description of a given repository",
                body = mod_updatedesc_ui("updatedesc_1")
              )
            )
          )
        )
      ),
      shiny::tabPanel(
        title = "Collaborators",
        value = "collab",
        shiny::div(
          class = "container-fluid gx-3 gy-3",
          shiny::div(
            class = "row",
            shiny::column(
              width = 6,
              bs5_card(
                title = "Collaborators",
                subtitle = "Retrieve a list of collaborators associated with an owner and repository",
                body = mod_listcollabs_ui("listcollabs_1")
              )
            ),
            shiny::column(
              width = 6,
              bs5_card(
                title = "Add collaborator",
                subtitle = "Add a collaborator to repository",
                mod_addcollab_ui("addcollab_1")
              )
            )
          )
        )
      ),
      shiny::tabPanel(
        title = "About",
        value = "about",
        shiny::div(class = "container-fluid gx-3 gy-3",
                   shiny::column(
                     width = 6,
                     shiny::includeMarkdown(app_sys("app/www/info.md"))
                   ))
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
  add_resource_path("www",
                    app_sys("app/www"))

  tags$head(favicon(),
            bundle_resources(path = app_sys("app/www"),
                             app_title = "ghshiny")
            # Add here other external resources
            # for example, you can add shinyalert::useShinyalert()
            )
            }
