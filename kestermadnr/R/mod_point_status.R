#' point_status UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_point_status_ui <- function(id){
  ns <- NS(id)
  tagList(

    shiny::h1(id)

  )
}

#' point_status Server Functions
#'
#' @noRd
mod_point_status_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

  })
}

## To be copied in the UI
# mod_point_status_ui("point_status_1")

## To be copied in the server
# mod_point_status_server("point_status_1")
