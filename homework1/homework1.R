library(ggplot2)
library(RColorBrewer)
data(movies) 
data(EuStockMarkets)

# Filter out any rows that have a budget value less than or equal to 0 in the movies dataset.
movies <- movies[which(movies$budget > 0), ]

# Add a genre column to the movies dataset as follows:
movies$genre <- rep(NA, nrow(movies))
count <- rowSums(movies[, 18:24])
movies$genre[which(count > 1)] = "Mixed"
movies$genre[which(count < 1)] = "None"
movies$genre[which(count == 1 & movies$Action == 1)] = "Action"
movies$genre[which(count == 1 & movies$Animation == 1)] = "Animation"
movies$genre[which(count == 1 & movies$Comedy == 1)] = "Comedy"
movies$genre[which(count == 1 & movies$Drama == 1)] = "Drama"
movies$genre[which(count == 1 & movies$Documentary == 1)] = "Documentary"
movies$genre[which(count == 1 & movies$Romance == 1)] = "Romance"
movies$genre[which(count == 1 & movies$Short == 1)] = "Short"

# Transform the EuStockMarkets dataset to a time series as follows:
eu <- transform(data.frame(EuStockMarkets), time = time(EuStockMarkets))

# Plot 1: Scatterplot. 
movies1 <- movies
movies1$budget_MM <- movies1$budget / 1000000
scatterplot <- ggplot(movies1,
                      aes(x=budget_MM, y=rating, color=genre)) + 
                geom_point(alpha=.8) +
                ggtitle("Budget and Rating of Movies") +
                xlab("Budget (in million)") + 
                ylab("Rating") +
                theme(text=element_text(family="Georgia", face="italic"))
ggsave(file="hw1-scatter.png", plot=scatterplot, width=8, height=6)

# Plot 2: Bar Chart.
movies2 <- movies
Count <- rle(sort(movies2$genre))
movies2$Count <- Count[[1]][match(movies2$genre, Count[[2]])]
movies3 <- movies2[!duplicated(movies2[c("genre" , "Count")]), c("genre" , "Count")]
movies3 <- movies3[order(movies3$Count, decreasing=TRUE), ]
genretext <- movies3$genre
barchart <- ggplot(movies3,
                   aes(x=genre, y=Count)) + 
            geom_bar(stat="identity", width=0.7, fill="#CC79A7") +
            ggtitle("Number of Movies Per Genre") +
            xlab("Genre") + 
            ylab("Count") +
            scale_x_discrete(limits=genretext) +
            theme(text=element_text(family="Georgia", face="italic"))
ggsave(file="hw1-bar.png", plot=barchart, width=8, height=6)


# Plot 3: Small Multiples.
multiples <- ggplot(movies1,
                    aes(x=budget_MM, y=rating, color=genre))+ 
              geom_point(alpha=.8, size=1.2) +
              ggtitle("Budget and Rating of Movies Per Genre") +
              xlab("Budget (in million)") + 
              ylab("Rating") +
              facet_wrap(~ genre, ncol=3) +
              labs(colour="Genre") +
              theme(text=element_text(family="Georgia", face="italic"))
ggsave(file="hw1-multiples.png", plot=multiples, width=8, height=6)


# Plot 4: Multi-Line Chart.
eu1 <- eu
eu1$time <- as.numeric(time(eu1$time))
new_eu <- data.frame(price=eu1$DAX, time=eu1$time)
new_eu$index <- "DAX"
new_eu <- rbind(new_eu, data.frame(price=eu1$SMI, time=eu1$time, index=rep("SMI", nrow(eu1))))
new_eu <- rbind(new_eu, data.frame(price=eu1$CAC, time=eu1$time, index=rep("CAC", nrow(eu1))))
new_eu <- rbind(new_eu, data.frame(price=eu1$FTSE, time=eu1$time, index=rep("FTSE", nrow(eu1))))

multiline <- ggplot(new_eu,
                    aes(x=time, y=price,
                        group=factor(index),
                        color=factor(index))) + 
              geom_line(size=0.6) +
              ggtitle("Time Series of Stock Market Prices for 4 indexes") +
              xlab("Time") + 
              ylab("Price") +
              labs(colour="Index") +
              theme(text=element_text(family="Georgia", face="italic"))
ggsave(file="hw1-multiline.png", plot=multiline, width=8, height=6)




