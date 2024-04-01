# read in the player level data
# note: this took 111 seconds
setwd("/Users/max/Desktop/school/bzan583_REAL")
library(readr)
library(tidyverse)
game_level <- read_csv("game_level_data_583.csv")
player_level <- read_csv("player_level_data_583.csv")



Rprof()

start_time <- Sys.time()


lineup <- data.frame(matrix(ncol = 0, nrow = nrow(game_level)))

# create lineup level stats
lineup$game_id <- game_level$game_id
lineup$team <- game_level$team

# Define the list of columns to create
columns_to_create <- c(
  "avg_obp_this_yr", "avg_slg_this_yr", "avg_obp_plus_slg_this_yr",
  "ly_games", "ly_plate_appearances", "ly_on_base_percentage",
  "ly_slugging_percentage", "ly_OBP_plus_SLG", "ly_double_rate",
  "ly_triple_rate", "ly_hr_rate", "ly_steal_score", "ly_start_rate", "ly_avg_batting_position", "avg_double_rate_this_yr", "avg_triple_rate_this_yr", "avg_home_run_rate_this_yr", "avg_steal_score_this_yr",
  "avg_start_rate_this_yr", "avg_batting_position_this_yr"
)

# Loop through each position
for (i in 1:9) {
  # Create p column
  lineup[paste0("p", i)] <- 0
  
  # Loop through the columns to create
  for (col in columns_to_create) {
    # Create the column
    lineup[paste0("p", i, "_", col)] <- 0
  }
}

# Loop through each game to grab game stats
for (game in 1:nrow(game_level)) {
  current_game <- game_level[game, ]
  current_game_id <- current_game$game_id
  current_team <- current_game$team
  
  for (pos in 1:9) {
    player_row <- which(player_level$game_id == current_game_id &
                          player_level$batting_position == pos &
                          player_level$team == current_team)
    
    player_name <- player_level$Player[player_row]
    player <- player_level[player_row, ]
    
    # Loop through the columns to fill in stats
    for (col in columns_to_create) {
      # Get the value from the player dataframe
      value <- player[[col]]
      
      # Fill in the lineup dataframe
      lineup[game, paste0("p", pos, "_", col)] <- value
    }
    
    # Fill in player name separately
    lineup[game, paste0("p", pos)] <- player_name
  }
  
  # Print progress
  if (game %% 100 == 0) {
    print(paste("Game", game, "of", nrow(game_level)))
    # print percent done
    print(paste("Percent Done:", round(game / nrow(game_level) * 100, 0), "%"))
  }
}




Rprof(NULL)
summaryRprof()
