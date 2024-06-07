# Walker Ryan’s Textures Skateboarding Part Analysis and Point Evaluation Using Tony Hawk’s Pro Skater (THPS) Scoring Model

# Python code (also saved as a .py file)

```python

##########################
# count data for obstacles, trick types, and tricks
##########################



import pandas as pd

# Data setup
df = pd.read_csv("/walker-ryan-skate-part-tricks(Part-Analysis)(REV1)(CSV).csv")
print(df.head())

# Function to count something overall
def count_something_overall(df, category):
    counts_overall = df[category].value_counts().reset_index()
    counts_overall.columns = [category, "Count"]
    return counts_overall

# Function to count something per clip
def count_something_per_clip(df, category):
    clip_counts = df.groupby('Clip')[category].apply(lambda x: x.dropna().count()).reset_index()
    clip_counts.columns = ['Clip', f'{category}_Count']
    return clip_counts

# Obstacles
obstacle_counts_overall = count_something_overall(df, 'Obstacle')
print(obstacle_counts_overall)

obstacle_counts_per_clip = count_something_per_clip(df, 'Obstacle')
print(obstacle_counts_per_clip)

# Trick Types
trick_type_counts_overall = count_something_overall(df, 'Trick_Type')
print(trick_type_counts_overall)

trick_type_counts_per_clip = count_something_per_clip(df, 'Trick_Type')
print(trick_type_counts_per_clip)

# Tricks
trick_counts_overall = count_something_overall(df, 'Trick')
print(trick_counts_overall)

trick_counts_per_clip = count_something_per_clip(df, 'Trick')
print(trick_counts_per_clip)


# combine obstacle, trick type, and tricks overall and per clip data into one data frame and give option to save as CSV
obstacle_trick_types_tricks_dfs_combined = pd.concat(objs = [obstacle_counts_overall, obstacle_counts_per_clip, trick_type_counts_overall, trick_type_counts_per_clip, trick_counts_overall, trick_counts_per_clip], axis = 1)
print(obstacle_trick_types_tricks_dfs_combined)
print(obstacle_trick_types_tricks_dfs_combined.columns)
#obstacle_trick_types_tricks_dfs_combined.to_csv('obstacle_trick_types_tricks_dfs_combined.csv', index=False)





##########################
# points for clips and overall score
##########################



import pandas as pd

# Load the data
tricks_data = pd.read_csv("/walker-ryan-part-tricks-and-holds-time(REV1)(COMBINED_DATA)(CSV).csv")
print(tricks_data.head())


# Calculate the points
def calculate_final_points(row, use_pal=True):
    # Get the base points
    base_points = row['Base_Points'] if not pd.isna(row['Base_Points']) else 0
    switch_multiplier = row['Switch_Multiplier_Base_Pts'] if not pd.isna(row['Switch_Multiplier_Base_Pts']) else 1
    spin_multiplier = row['Spin_Multiplier_Trick_Total'] if not pd.isna(row['Spin_Multiplier_Trick_Total']) else 1
    hold_points = row['Total_PAL_Points'] if use_pal else row['Total_NTSC_Points']

    # Calculate the points
    points = (base_points * switch_multiplier) + hold_points

    return points, spin_multiplier

# Apply the function to calculate points and spin multipliers
tricks_data[['Points', 'Spin_Multiplier']] = tricks_data.apply(lambda row: calculate_final_points(row), axis=1, result_type='expand')

# Group by Clip and calculate total points and max spin multiplier for each clip
final_results = tricks_data.groupby('Clip').apply(lambda x: pd.Series({
    'Total_Points': x['Points'].sum(),
    'Max_Spin_Multiplier': x['Spin_Multiplier'].max()
}))

# Adjust total points by the max spin multiplier
final_results['Final_Points'] = final_results['Total_Points'] * final_results['Max_Spin_Multiplier']

# Print the results for each clip
print(final_results)
#final_results.to_csv('Final_Results_Points.csv', index= False)

# summary statistics of 'final_results'Walker
print(final_results['Final_Points'].describe())

# Calculate and print the overall point value
overall_points = final_results['Final_Points'].sum()
print(f"Overall Point Value: {overall_points}")

print(tricks_data[tricks_data['Clip'] == 4].iloc[:,:]) # clip 4 has highest overall score
print(tricks_data[tricks_data['Clip'] == 40].iloc[:,:]) # clip 40 has lowest overall score
print(tricks_data[tricks_data['Clip'] == 22].iloc[:,:]) # checking switch nose manual score to make sure calculating correctly with zero base points. Correct with zero base points.
```

# R code (also saved as a .R file)

```R

#######################
# upload data
#######################


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
```










