library(readr)

tournamentStandingsFile <- list.files(path = "./data-raw/",
                                      pattern = "mm-standings.csv",
                                      full.names = TRUE)

tournamentStandings <- readr::read_csv(file = tournamentStandingsFile,
                                       na = "",
                                       show_col_types = FALSE)


usethis::use_data(tournamentStandings, overwrite = TRUE)
