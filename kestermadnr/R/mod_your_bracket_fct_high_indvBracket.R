#' fct_high_indvBracket
#'
#' @description Here
#'
#' @return Here
#'
#'
#' @param name A character string of the name of the player
#' @param regions A character vector of the region names in the tourney
#' @param nodeColors A named list of colors. List names are: "root", "unplayed", "won", "lost"
#' @param scoring This is a place holder for a named list to be used to score players
#' @param playerPicks A named list containing the picks of every player in the pool
#' @param tournamentStructure A tibble with the tournament structure and placeholders
#' @param tournamentStandings A tibble of the current standings overlaid on top of the structure
#' @param collapsed Boolean of whether the graph should start expanded or collapsed.
#'
#'
fct_high_indvBracket <- function(name,
                                 regions = c("West",
                                             "East",
                                             "South",
                                             "Midwest"),
                                 nodeColors = list("root" = "white",
                                                   "unplayed" = "black",
                                                   "won" = "green",
                                                   "lost" = "red"),
                                 scoring = 1,
                                 playerPicks,
                                 tournamentStandings,
                                 tournamentStructure,
                                 collapsed = FALSE){

  lst_regionStandings <- list()

  for(region in regions){

    standings <- fct_low_prepBracket(input = tournamentStandings,
                                     region = region)

    lst_regionStandings[region] <- list(standings)

  }

  lst_playerPicks <- list()

  for(region in regions){

    picks <- fct_low_prepBracket(input = playerPicks,
                                 region = region)

    lst_playerPicks[region] <- list(picks)

  }

  lst_structure <- list()

  for(region in regions){

    structure <- fct_low_prepBracket(input = tournamentStructure,
                                     region = region)

    lst_structure[region] <- list(structure)
  }

  lst_brackets <- list()

  for(region in regions){

    testInfo <- list(region,
                     lst_regionStandings,
                     lst_playerPicks,
                     lst_structure,
                     nodeColors)

    scoredRegion <- fct_low_scorePicks(region = region,
                                       standings = lst_regionStandings,
                                       picks = lst_playerPicks,
                                       structure = lst_structure,
                                       nodeColors = nodeColors)

    lst_brackets[[region]] <- list("picks" = lst_regionStandings[[region]][["input"]],
                                   "colors" = c(nodeColors$root,
                                                scoredRegion$color))

  }

  return(lst_brackets)

}
