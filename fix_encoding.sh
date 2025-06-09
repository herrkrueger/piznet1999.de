#!/bin/bash

# This script converts all HTML files from ISO-8859-1 to UTF-8
# and adds a charset meta tag if it doesn't exist

# Function to process each HTML file
process_file() {
  local file="$1"
  echo "Processing $file"
  
  # Create a temporary file
  temp_file=$(mktemp)
  
  # Convert from ISO-8859-1 to UTF-8
  iconv -f ISO-8859-1 -t UTF-8 "$file" > "$temp_file"
  
  # Check if charset meta tag exists
  if ! grep -q '<meta charset="UTF-8">' "$temp_file"; then
    # Add charset meta tag after <head> tag if it exists
    if grep -q '<head>' "$temp_file"; then
      sed -i '' 's/<head>/<head>\n<meta charset="UTF-8">/' "$temp_file"
    else
      # Add head and charset meta tag after html tag if head doesn't exist
      sed -i '' 's/<html>/<html>\n<head>\n<meta charset="UTF-8">\n<\/head>/' "$temp_file"
    fi
  fi
  
  # Replace original file with the modified one
  mv "$temp_file" "$file"
}

# Find all HTML files and process them
find . -type f \( -name "*.htm" -o -name "*.html" \) -print0 | while IFS= read -r -d '' file; do
  process_file "$file"
done

echo "All HTML files have been processed and converted to UTF-8."