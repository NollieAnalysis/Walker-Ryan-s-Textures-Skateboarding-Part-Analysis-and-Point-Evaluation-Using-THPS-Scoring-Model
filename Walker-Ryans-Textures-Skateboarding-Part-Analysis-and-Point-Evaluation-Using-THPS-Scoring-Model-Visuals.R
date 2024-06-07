#######################
# upload data
#######################

# packages = ggplot2 and tidyverse

obstacle_trick_types_tricks_counts_dfs_combined <- read.csv("/obstacle_trick_types_tricks_counts_dfs_combined.csv")
head(obstacle_trick_types_tricks_counts_dfs_combined)
colnames(obstacle_trick_types_tricks_counts_dfs_combined)


#######################
# end upload data
#######################




#######################
# visuals for obstacle counts
#######################


# slice df for obstacle count overall
df_obstacle_count_overall <- obstacle_trick_types_tricks_counts_dfs_combined [1:7, c(1,2)]

# Sort data frame in descending order by count
df_obstacle_count_overall <- df_obstacle_count_overall[order(-df_obstacle_count_overall$Count),]

# Set the order of the Trick_Type factor based on the sorted data and reverse it
df_obstacle_count_overall$Obstacle <- factor(df_obstacle_count_overall$Obstacle, 
                                                 levels = rev(df_obstacle_count_overall$Obstacle))


head(df_obstacle_count_overall)


# pie chart (option 3) ******************
# Sort data frame in descending order by count
df_obstacle_count_overall <- df_obstacle_count_overall %>%
  arrange(desc(Count))

# Calculate the percentage for each category
df_obstacle_count_overall <- df_obstacle_count_overall %>%
  mutate(Percentage = Count / sum(Count) * 100)

# Create a new label for the legend
df_obstacle_count_overall <- df_obstacle_count_overall %>%
  mutate(LegendLabel = paste0(Obstacle, " (", Count, ")"))

# Set the order of the Obstacle factor based on the sorted data
df_obstacle_count_overall$Obstacle <- factor(df_obstacle_count_overall$Obstacle, levels = df_obstacle_count_overall$Obstacle)

# Plot using ggplot2
pie <- ggplot(df_obstacle_count_overall, aes(x = "", y = Count, fill = Obstacle)) +
  geom_bar(stat = "identity", width = 1, color = "white") + # Add white border for slices
  coord_polar(theta = "y", start = pi/2, direction = -1) + # Change to y for pie chart and set start angle to 90 degrees (pi/2 radians) and clockwise direction
  labs(title = "Obstacle Counts", x = NULL, y = NULL) + # Add title and remove axis titles
  theme_minimal() + # Apply minimal theme
  theme(axis.text.x = element_blank(), # Remove x-axis text
        axis.text.y = element_blank(), # Remove y-axis text
        axis.ticks = element_blank(), # Remove axis ticks
        panel.grid = element_blank(), # Remove grid lines
        plot.title = element_text(size = 20, face = "bold", hjust = 0.5), # Customize title
        legend.title = element_text(size = 12), # Customize legend title
        legend.text = element_text(size = 10)) + # Customize legend text
  scale_fill_manual(values = scales::hue_pal()(length(unique(df_obstacle_count_overall$Obstacle))),
                    labels = df_obstacle_count_overall$LegendLabel) + # Ensure legend order matches the data and include counts
  geom_text(aes(label = sprintf("%.1f%%", Percentage)), position = position_stack(vjust = 0.5)) # Add percentage labels inside pie slices

# Display pie chart
print(pie)


#######################
# end visuals for obstacle counts
#######################




#################
# visuals for trick types
#################


# slice df for trick type count overall
df_trick_type_count_overall <- obstacle_trick_types_tricks_counts_dfs_combined [1:8, c(5,6)]

# Sort data frame in descending order by count
df_trick_type_count_overall <- df_trick_type_count_overall[order(-df_trick_type_count_overall$Count.1),]

# Set the order of the Trick_Type factor based on the sorted data
df_trick_type_count_overall$Trick_Type <- factor(df_trick_type_count_overall$Trick_Type, 
                                                 levels = rev(df_trick_type_count_overall$Trick_Type))
head(df_trick_type_count_overall)


# pie chart (option 3) ******************
# Sort data frame in descending order by count
df_trick_type_count_overall <- df_trick_type_count_overall %>%
  arrange(desc(Count.1))

# Calculate the percentage for each category
df_trick_type_count_overall <- df_trick_type_count_overall %>%
  mutate(Percentage = Count.1 / sum(Count.1) * 100)

# Create a new label for the legend
df_trick_type_count_overall <- df_trick_type_count_overall %>%
  mutate(LegendLabel = paste0(Trick_Type, " (", Count.1, ")"))

# Set the order of the Obstacle factor based on the sorted data
df_trick_type_count_overall$Trick_Type <- factor(df_trick_type_count_overall$Trick_Type, levels = df_trick_type_count_overall$Trick_Type)

# Plot using ggplot2
pie <- ggplot(df_trick_type_count_overall, aes(x = "", y = Count.1, fill = Trick_Type)) +
  geom_bar(stat = "identity", width = 1, color = "white") + # Add white border for slices
  coord_polar(theta = "y", start = pi/2, direction = -1) + # Change to y for pie chart and set start angle to 90 degrees (pi/2 radians) and clockwise direction
  labs(title = "Trick Type Counts", x = NULL, y = NULL) + # Add title and remove axis titles
  theme_minimal() + # Apply minimal theme
  theme(axis.text.x = element_blank(), # Remove x-axis text
        axis.text.y = element_blank(), # Remove y-axis text
        axis.ticks = element_blank(), # Remove axis ticks
        panel.grid = element_blank(), # Remove grid lines
        plot.title = element_text(size = 20, face = "bold", hjust = 0.5), # Customize title
        legend.title = element_text(size = 12), # Customize legend title
        legend.text = element_text(size = 10)) + # Customize legend text
  scale_fill_manual(values = scales::hue_pal()(length(unique(df_trick_type_count_overall$Trick_Type))),
                    labels = df_trick_type_count_overall$LegendLabel) + # Ensure legend order matches the data and include counts
  geom_text(aes(label = sprintf("%.1f%%", Percentage)), position = position_stack(vjust = 0.5)) # Add percentage labels inside pie slices

# Display pie chart
print(pie)


#################
# end visuals for trick types
#################