#!/bin/bash 

# Generate a timestamp for the file name
timestamp=$(date +%Y%m%d%H%M%S)
id_file="./env/id"
prev_id=$(cat $id_file)
id=$((prev_id + 1))

url="https://jsonplaceholder.typicode.com/posts/$id"

# Fetch JSON data using curl
json_data=$(curl -s "$url")

# Create the file name with the timestamp
file_name="data/file_${id}_${timestamp}.json"

# Save JSON data to the file
echo "$json_data" > "$file_name"
# Save id to file
echo "$id" > $id_file

echo "JSON data saved to $file_name"
