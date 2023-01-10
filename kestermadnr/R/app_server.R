#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {

  mod_footer_server("footer_1")

  mod_home_server("home_1")

  mod_your_bracket_server("your_bracket_1")

  mod_point_status_server("point_status_1")

}
