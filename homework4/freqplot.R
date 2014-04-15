require(ggplot2)
source("data.r")

# Create a data frame comparing words from two ebooks
freq_df <- data.frame(
  data45362 = data_matrix[, "pg45362.txt"],
  data10118 = data_matrix[, "pg10118.txt"],
  stringsAsFactors = FALSE)

rownames(freq_df) <- rownames(data_matrix)

# Filter out infrequent words
# freq_df <- freq_df[rowSums(freq_df) > 30,]

# Alternatively, just look at top 20
freq_df <- freq_df[order(rowSums(freq_df), decreasing = TRUE),]
freq_df <- head(freq_df, 20)

# Plot frequencies
p <- ggplot(freq_df, aes(data45362, data10118)) + 
  geom_text(label = rownames(freq_df), position = position_jitter(width = 2, height = 2)) +
  xlab("The Ghost World") + ylab("The Folk-lore of Plants") +
  ggtitle("Words Frequency Comparison") +
  theme(text=element_text(family="Georgia", face="italic")) +
  scale_x_continuous(limits = c(0, 500)) +
  scale_y_continuous(limits = c(0, 500)) +
  theme(panel.grid.major = element_blank()) 
#   coord_fixed(ratio = 1/1) +
#   scale_colour_brewer(type = "seq", palette = "BuGn")

# print(p)
ggsave(filename = file.path("data_freq.png"), width = 8, height = 6, dpi = 100)
