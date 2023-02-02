library(readr)

tournamentStructureFile <- list.files(path = "./data-raw/",
                                      pattern = "mm-structure.csv",
                                      full.names = TRUE)

tournamentStructure <- readr::read_csv(file = tournamentStructureFile,
                                       na = "",
                                       show_col_types = FALSE)


usethis::use_data(tournamentStructure, overwrite = TRUE)
