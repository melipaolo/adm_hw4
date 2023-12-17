#!/bin/bash

awk -F, '$3 != -1' vodclickstream_uk_movies_03.csv > movies.csv

### Most viewed movie
# Through "cut -d ',' -f4" we take into account in our analysis only the fourth column i.e. that of the movie name for each row ("-d ',' " indicates that each column is separated by a delimiter of the type ','). 
# After that we sort it so that we have all the repetitions of each neighboring movie and through "uniq -c" we take unique values of the movie title and with "-c" count all the repetitions so as to find the most viewed movie.
# We sort again in descending order according to the number of repeats of the movie with "sort -nr"; we take only the first row with "head -n 1" and print the full name of the movie via "awk '{print substr($0, index($0,$2))}' " 
most_viewed_movie=$(cut -d',' -f4 movies.csv | sort | uniq -c | sort -nr | head -n 1 | awk '{print substr($0, index($0,$2))}')
echo "The movie most viewed in Netflix UK is: $most_viewed_movie"

### Average time between two clicks
# Here quite explicitly we take the third column of which we are going to average by summing the values present along with the count increment to get the total number of values summed. 
# I use the END statement so that I do not receive as printed output all the sum and count values every time there is an increment. 
# We then printed the actual average seen in hours because in seconds we had too large a number that does not render well the resulting amount of time.
average_time=$(awk -F, '{print $3}' movies.csv | awk '{sum += $1; count += 1} END {print sum/count/3600}')
echo "Average duration between subsequent clicks: $average_time hours"

### ID of the user that has spent the most time on Netflix
# In this case I create an array user_durations[] that with "$NF" takes the last column ever (I do not take the numbered column because the delimiter ',' is also present in some values like the title and so for each row the command splits the columns differently).
# In this column it adds the durations to figure out for each user how much time they spent on Netflix.
# With the END statement we apply the next command at the end of the one just described.
# We analyze the total duration of each user and compare it to the maximum duration we have (we start with a maximum duration of 0) and then print the user who spent the most time on Netflix.
most_watcher_userID=$(awk -F, '{ user_duration[$NF]+=$3 } END { max_duration=0; for (user in user_duration) { if (user_duration[user] > max_duration) { max_duration = user_duration[user]; most_watcher_userID = user; } } print most_watcher_userID }' movies.csv)
echo "ID dell'utente che ha trascorso più tempo su Netflix: $most_watcher_userID"

