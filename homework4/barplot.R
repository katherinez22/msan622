require(ggplot2)
require(scales)
source("data.r")

# Sort bars by frequency
bar_df <- head(data_df, 10)
bar_df$word <- factor(bar_df$word, levels = bar_df$word, ordered = TRUE)

# Print a simple bar plot of the top 10 words
p <- ggplot(bar_df, aes(x = word, y = freq)) +
  geom_bar(stat = "identity", width=0.7, fill="#99d8c9") +
  ggtitle("Word Count of T. F. Thiselton Dyer's books") +
  xlab("Top 10 Word Stems (Stop Words Removed)") +
  ylab("Frequency") +
  theme_minimal() +
  scale_x_discrete(expand = c(0, 0)) +
  scale_y_continuous(expand = c(0, 0), limits = c(0, 550)) +
  theme(panel.grid = element_blank()) +
  theme(axis.ticks = element_blank()) +
  theme(text=element_text(family="Georgia", face="italic"))

# print(p)
ggsave(filename = file.path("data_bar.png"), plot = p, width = 8, height = 6, dpi = 100)
