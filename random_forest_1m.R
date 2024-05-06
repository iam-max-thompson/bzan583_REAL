library(parallel)                                       #<<
library(randomForest)

library(data.table)
audio_features <- fread("/projects/bckj/Team2/data/Spotify/MAIN.csv")

#audio_features <- fread("/Users/max/Downloads/spotify_working_data/MAIN.csv")
set.seed(123)

# sample 100,000 rows
sub_audio_features <- audio_features[sample(nrow(audio_features), 300000, replace = FALSE), , drop = FALSE]

#sub_audio_features <- audio_features


print("data loaded succesfully. correct wd")

#########PARALLEL CODE #########

start_time <- Sys.time()



n = nrow(sub_audio_features)
n_test = floor(0.2 * n)
i_test = sample.int(n, n_test)
train = sub_audio_features[-i_test, ]
test = sub_audio_features[i_test, ]

nc = as.numeric(commandArgs(TRUE)[2])
#nc <-  12
ntree = lapply(splitIndices(200, nc), length)            #<<
rf = function(x, train) randomForest(popularity ~ energy + loudness + 
                                       speechiness + tempo + time_signature + 
                                       valence + bpm + key + liveness + duration_ms +
                                       release_year +  instrumentalness +
                                       danceability + acousticness +
                                       mode, train, ntree=x, norm.votes = FALSE) #<<
rf.out = mclapply(ntree, rf, train = train, mc.cores = nc)      #<<
rf.all = do.call(combine, rf.out)                        #<<

crows = splitIndices(nrow(test), nc)                     #<<
rfp = function(x) as.vector(predict(rf.all, test[x, ]))  #<<
cpred = mclapply(crows, rfp, mc.cores = nc)              #<<
pred = do.call(c, cpred)                                 #<<


rmse <- sqrt(mean((test$popularity - pred)^2))
cat("RMSE:", rmse, "\n")

end_time <- Sys.time()


# grab ten most popular songs from release year 2023 no dplyr just base r
test$pred <- round(pred, 1)

# select only track_title, popularity, release_date and pred columns
to_use <- test[, c("track_title", "popularity", "release_date", "pred")]

top_ten <- to_use[order(to_use$popularity, decreasing = TRUE), ][1:20, ]

# print top 
print("top 20 songs:")
top_ten

# print time it took to run
round(end_time - start_time, 2)


