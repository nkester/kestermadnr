# This loads all of the data in the `data` directory.
{
  files<-list.files(path = "./data/",
                    full.names = TRUE)

  for(file in files){

    load(file = file)

  }
}

#' your_bracket UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList h1 fluidRow column h3
#' @importFrom collapsibleTree collapsibleTreeOutput
mod_your_bracket_ui <- function(id){
  ns <- NS(id)
  tagList(

    shiny::fluidRow(

      shiny::column(width = 5,

                    shiny::h3("West"),

                    collapsibleTree::collapsibleTreeOutput(outputId = ns('west_bracket'),
                                                           width = "90%")
      ),

      shiny::column(width = 5,
                    offset = 2,

                    shiny::h3("East"),

                    collapsibleTree::collapsibleTreeOutput(outputId = ns('east_bracket'),
                                                           width = "90%")

      )
    ),
    shiny::fluidRow(

      shiny::column(width = 5,

                    shiny::h3("South"),

                    collapsibleTree::collapsibleTreeOutput(outputId = ns('south_bracket'),
                                                           width = "90%")
      ),

      shiny::column(width = 5,
                    offset = 2,

                    shiny::h3("Midwest"),

                    collapsibleTree::collapsibleTreeOutput(outputId = ns('midwest_bracket'),
                                                           width = "90%")

      )
    )
  )
}

#' your_bracket Server Functions
#'
#' @noRd
#'
#' @importFrom collapsibleTree renderCollapsibleTree collapsibleTree
mod_your_bracket_server <- function(id){

  . <- NULL

  moduleServer( id, function(input, output, session){
    ns <- session$ns

    user_bracket <- fct_high_indvBracket(name = "neil",
                                         playerPicks = playerPicks[["neil"]],
                                         tournamentStandings = tournamentStandings,
                                         tournamentStructure = tournamentStructure)


    output$west_bracket <- collapsibleTree::renderCollapsibleTree(expr = {

      user_bracket[["West"]][["picks"]] %>%
        collapsibleTree::collapsibleTree(df = .,
                                         colnames(.[2:ncol(.)]),
                                         collapsed = FALSE,
                                         fill = user_bracket[["West"]][["colors"]])
    })

    output$east_bracket <- collapsibleTree::renderCollapsibleTree(expr = {

      user_bracket[["East"]][["picks"]] %>%
        collapsibleTree::collapsibleTree(df = .,
                                         colnames(.[2:ncol(.)]),
                                         collapsed = FALSE,
                                         fill = user_bracket[["East"]][["colors"]])
    })

    output$south_bracket <- collapsibleTree::renderCollapsibleTree(expr = {

      user_bracket[["South"]][["picks"]] %>%
        collapsibleTree::collapsibleTree(df = .,
                                         colnames(.[2:ncol(.)]),
                                         collapsed = FALSE,
                                         fill = user_bracket[["South"]][["colors"]])
    })

    output$midwest_bracket <- collapsibleTree::renderCollapsibleTree(expr = {

      user_bracket[["Midwest"]][["picks"]] %>%
        collapsibleTree::collapsibleTree(df = .,
                                         colnames(.[2:ncol(.)]),
                                         collapsed = FALSE,
                                         fill = user_bracket[["Midwest"]][["colors"]])
    })

  })
}

## To be copied in the UI
# mod_your_bracket_ui("your_bracket_1")

## To be copied in the server
# mod_your_bracket_server("your_bracket_1")
