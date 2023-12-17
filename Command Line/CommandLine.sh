#!/bin/bash

# This is just the runnable command line script, for the commented lines go to the command line part of the main.ipynb file

awk -F, '$3 != -1' vodclickstream_uk_movies_03.csv > movies.csv

### Most viewed movie
most_viewed_movie=$(cut -d',' -f4 movies.csv | sort | uniq -c | sort -nr | head -n 1 | awk '{print substr($0, index($0,$2))}')
echo "The movie most viewed in Netflix UK is: $most_viewed_movie"

### Average time between two clicks
average_time=$(awk -F, '{print $3}' movies.csv | awk '{sum += $1; count += 1} END {print sum/count/3600}')
echo "Average duration between subsequent clicks: $average_time hours"

### ID of the user that has spent the most time on Netflix
most_watcher_userID=$(awk -F, '{ user_duration[$NF]+=$3 } END { max_duration=0; for (user in user_duration) { if (user_duration[user] > max_duration) { max_duration = user_duration[user]; most_watcher_userID = user; } } print most_watcher_userID }' movies.csv)
echo "ID dell'utente che ha trascorso più tempo su Netflix: $most_watcher_userID"

