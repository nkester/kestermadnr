#' your_bracket UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_your_bracket_ui <- function(id){
  ns <- NS(id)
  tagList(

    shiny::h1(id)

  )
}

#' your_bracket Server Functions
#'
#' @noRd
mod_your_bracket_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

  })
}

## To be copied in the UI
# mod_your_bracket_ui("your_bracket_1")

## To be copied in the server
# mod_your_bracket_server("your_bracket_1")
