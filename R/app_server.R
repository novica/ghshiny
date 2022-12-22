#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {
  # Validate the token and get login+repos to populate menus in other modules
  config <- mod_tokenauth_server("tokenauth_1")

  mod_listrepos_server(id = "listrepos_1", config = config)
  mod_listcollabs_server("listcollabs_1", config = config)
  mod_updatedesc_server("updatedesc_1", config = config)
  mod_addcollab_server("addcollab_1", config = config)

}
