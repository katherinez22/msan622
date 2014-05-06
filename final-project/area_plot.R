d <- read.csv("NamesOf50States.csv")
# Stacked Area Plot:
require(ggplot2)
new_df <- subset(d, grepl("^Sop", Name))
new_df2 <- aggregate(Number ~ Sex+Year+Name, new_df, sum)
p <- ggplot(new_df2)
p <- p+geom_area(aes(x=Year, y=Number, fill=Name))
print(p)