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
# If there were repeated tricks, points formula shall be updated to: 
#points = ((base points * repeating penalty) * switch multiplier) + hold points


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