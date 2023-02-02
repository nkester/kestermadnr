#' fct_low_prepBracket
#'
#' @return Named list
#'
#' @param input Any of the three input tibbles to transform
#' @param region A string of one of four of the regions in the tournament
#'
#' @importFrom readr read_csv
#' @importFrom magrittr %>%
#' @importFrom dplyr filter distinct
#' @importFrom tidyr pivot_longer drop_na
fct_low_prepBracket <- function(input, region){

  Region <- . <- NULL

  input <- input  %>%
    dplyr::filter(Region == region)

  gatheredInput <- input  %>%
    tidyr::pivot_longer(data = .,
                        cols = 2:ncol(.)) %>%
    dplyr::distinct(.) %>%
    tidyr::drop_na(.)

  return(
    list("input" = input,
         "gatheredInput" = gatheredInput)
  )

}
