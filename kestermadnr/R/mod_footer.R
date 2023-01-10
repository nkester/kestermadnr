#' footer UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_footer_ui <- function(id){
  ns <- shiny::NS(id)
  shiny::tagList(

    # Include a footer element on the left for the package version and build time
    shiny::HTML(
      sprintf(
        r"{<div class="fixed-footer" style="text-align:left;padding-left:10px">
        <p>
        Version: %s, Built at: %s
        </p>
        </div>}",
        paste0("kestmadnr-",as.character(golem::get_golem_options("version"))),
        paste0(
          system(
            command = r"{TZ="America/New_York" date +"%H:%M %m-%d-%Y"}",
            intern = TRUE),
          " EST")
      )
    ),

    # Set center footer with the author's name
    shiny::HTML(
      r"{<div class="fixed-footer" style="text-align:center">
      <p>
      By: Neil Kester
      </p>
      </div>}"),

    # Set right footer with the short commit SHA
    shiny::HTML(
      sprintf(
        r"{<div class="fixed-footer" style="text-align:right;padding-right:10px">
        <p>
        Commit: %s
        </p>
        </div>}",
        Sys.getenv("CI_COMMIT_SHORT_SHA")
      )
    )
  )

}

#' footer Server Functions
#'
#' @noRd
mod_footer_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

  })
}

## To be copied in the UI
# mod_footer_ui("footer_1")

## To be copied in the server
# mod_footer_server("footer_1")
