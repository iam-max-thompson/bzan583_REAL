library(parallel)                                       #<<
library(randomForest)

library(data.table)
audio_features <- fread("/projects/bckj/Team2/data/Spotify/audio_features.csv")

set.seed(123)

# sample 100,000 rows
sub_audio_features <- audio_features[sample(nrow(audio_features), 10000, replace = FALSE), , drop = FALSE]


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
rf = function(x, train) randomForest(danceability ~ energy + loudness + speechiness + tempo + time_signature + valence, train, ntree=x, norm.votes = FALSE) #<<
rf.out = mclapply(ntree, rf, train = train, mc.cores = nc)      #<<
rf.all = do.call(combine, rf.out)                        #<<

crows = splitIndices(nrow(test), nc)                     #<<
rfp = function(x) as.vector(predict(rf.all, test[x, ]))  #<<
cpred = mclapply(crows, rfp, mc.cores = nc)              #<<
pred = do.call(c, cpred)                                 #<<


rmse <- sqrt(mean((test$danceability - pred)^2))
cat("RMSE:", rmse, "\n")

end_time <- Sys.time()

# print time it took to run
round(end_time - start_time, 2)