library(readr)
library(stringr)

# Pick out all player pick files. These are annotated by a prefix of "player_"
#  followed by the player's name and then the csv file extension.
playerFiles <- list.files(path = "./data-raw/",
                          pattern = "player_.*.csv",
                          full.names = TRUE)

playerPicks <- list()

for(playerFile in playerFiles){

  # Extract only the player's name
  name <- stringr::str_extract(string = playerFile,
                               pattern = "(?<=_)[[:alpha:]]*")

  # Read in the csv and assign it as a named element in the provided list.
  playerPicks[[name]] <- readr::read_csv(file = playerFile,
                                         show_col_types = FALSE)

}


usethis::use_data(playerPicks, overwrite = TRUE)
