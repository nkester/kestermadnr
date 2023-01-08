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

        shiny::tabPanel(title = "Tab 1",

                        shiny::h1("Test tab 1")

                        ),

        shiny::tabPanel(title = "Tab 2",

                        shiny::h1("Test tab 2")

                        ) # tabPanel

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
    )
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert()
  )
}
