# read in the player level data
# note: fixing the which dropped time to 51.3
#setwd("/Users/max/Desktop/school/bzan583_REAL")
setwd('/u/sthompson2/bzan583_REAL')

library(readr)
library(tidyverse)
game_level <- read_csv("game_level_data_583.csv")
player_level <- read_csv("player_level_data_583.csv")

player_level <- player_level %>% 
  filter(batting_position <= 9)



Rprof()

# Create lineup dataframe
lineup <- data.frame(game_id = game_level$game_id, team = game_level$team)

# Define the list of columns to create
columns_to_create <- c(
  "avg_obp_this_yr", "avg_slg_this_yr", "avg_obp_plus_slg_this_yr",
  "ly_games", "ly_plate_appearances", "ly_on_base_percentage",
  "ly_slugging_percentage", "ly_OBP_plus_SLG", "ly_double_rate",
  "ly_triple_rate", "ly_hr_rate", "ly_steal_score", "ly_start_rate", "ly_avg_batting_position", "avg_double_rate_this_yr", "avg_triple_rate_this_yr", "avg_home_run_rate_this_yr", "avg_steal_score_this_yr",
  "avg_start_rate_this_yr", "avg_batting_position_this_yr"
)

# Create columns for each position
for (i in 1:9) {
  lineup[paste0("p", i)] <- ""
  lineup[paste0("p", i, "_", columns_to_create)] <- 0
}

# Loop through each game
for (game in 1:nrow(game_level)) {
  current_game <- game_level[game, ]
  current_game_id <- current_game$game_id
  current_team <- current_game$team
  
  # Find player rows for the current game and team
  player_rows <- which(player_level$game_id == current_game_id &
                         player_level$team == current_team)
  
  # Fill in player data
  for (pos in 1:9) {
    player_row <- player_rows[player_level$batting_position[player_rows] == pos]
    player_name <- player_level$Player[player_row]
    player <- player_level[player_row, ]
    
    # Fill in player stats
    lineup[game, paste0("p", pos)] <- player_name
    lineup[game, paste0("p", pos, "_", columns_to_create)] <- player[, columns_to_create]
  }
  
  # Print progress
  if (game %% 100 == 0) {
    cat("Game", game, "of", nrow(game_level), "\n")
    cat("Percent Done:", round(game / nrow(game_level) * 100, 0), "%\n")
  }
}

Rprof(NULL)
summaryRprof()
