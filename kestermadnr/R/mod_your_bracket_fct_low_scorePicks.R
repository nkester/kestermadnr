#' fct_low_scorePicks
#'
#' @return tibble
#'
#' @param region A string of one of four of the regions in the tournament
#' @param standings Test
#' @param picks Test
#' @param nodeColors Test
#' @param structure Test
#'
#' @importFrom dplyr mutate left_join select arrange
#' @importFrom magrittr %>%
fct_low_scorePicks <- function(region, standings, picks, nodeColors, structure){

  . <- `color-act` <- `color-player` <- played <- name <- NULL

  playerColors <- standings[[region]][['gatheredInput']] %>%
    dplyr::mutate(color = nodeColors$unplayed) %>%
    dplyr::left_join(x = .,
                     y = dplyr::mutate(.data = picks[[region]][['gatheredInput']],
                                       color = nodeColors$won),
                     by = c("Region",
                            "name",
                            "value"),
                     suffix = c("-act","-player")) %>%
    dplyr::mutate(color = dplyr::case_when(
      !is.na(`color-player`) ~ `color-player`,
      !is.na(`color-act`) ~ `color-act`
    )) %>%
    dplyr::select(-`color-act`,-`color-player`) %>%
    dplyr::left_join(x = .,
                     y = dplyr::mutate(.data = structure[[region]][['gatheredInput']],
                                       played = "unplayed"),
                     by = c("Region",
                            "name",
                            "value")) %>%
    dplyr::mutate(color = dplyr::case_when(
      (is.na(`played`) & color != nodeColors$won) ~ nodeColors$lost,
      TRUE ~ color
    )) %>%
    dplyr::select(-played) %>%
    dplyr::mutate(name = ordered(x = name,c("Regional Champ",
                                            "Regional Final",
                                            "Regional Semifinals",
                                            "Second Round",
                                            "First Round"))) %>%
    dplyr::arrange(name)

  return(playerColors)

}
