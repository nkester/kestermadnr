#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @importFrom shiny tagList fluidPage navbarPage div img tabPanel p
#' @importFrom shinipsum random_text
#' @importFrom shinyalert useShinyalert
#' @importFrom shinythemes shinytheme
#' @noRd
app_ui <- function(request) {
  shiny::tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),

    # Your application UI logic
    shiny::fluidPage(

      shiny::navbarPage(
        title = shiny::div(
          shiny::div(
            id = "title-icon",
            shiny::img(src = "www/favicon.png",
                       height = "50px")
          ),
          "KWS March Madness"
        ), # close shiny title div
        theme = shinythemes::shinytheme(theme = "flatly"),
        windowTitle = "KWS March Madness",
        lang = "en",

        shiny::tabPanel(title = "Home",

                        shiny::p(shinipsum::random_text(nwords = 50)),

                        mod_home_ui("home_1")

        ), # close Introduction tabPanel

        shiny::tabPanel(title = "Point Status",

                        shiny::p(shinipsum::random_text(nwords = 50)),

                        mod_your_bracket_ui("your_bracket_1")

        ), # close Point Status tabPanel

        shiny::tabPanel(title = "Your Bracket",

                        shiny::p(shinipsum::random_text(nwords = 50)),

                        mod_point_status_ui("point_status_1")

        ) # close Your Bracket tabPanel

      ) # close navbarPage

    ) # close fluidPage

  ) # close tagList

} # close app_ui function

#' Add external Resources to the Application
#'
#' This function is internally used to add external
#' resources inside the Shiny application.
#'
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
golem_add_external_resources <- function() {
  add_resource_path(
    "www",
    app_sys("app/www")
  )

  tags$head(
    favicon(ext = 'png'),
    bundle_resources(
      path = app_sys("app/www"),
      app_title = "kesterMadnr"
    ),

    shinyalert::useShinyalert(force = TRUE)

  )
}
