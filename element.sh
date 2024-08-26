#!/bin/bash

# Function to display usage information
usage() {
    echo Please provide an element as an argument.
    return 1
}

# Check if an argument is provided
if [ $# -eq 0 ]; then
    usage
    exit 0
fi

# Function to display the element information
display_element() {
    local input=$1
    
    # Query the database for the element information
    result=$(psql --username=freecodecamp --dbname=periodic_table --tuples-only --no-align --command="
    SELECT
        e.atomic_number,
        e.symbol,
        e.name,
        p.atomic_mass,
        p.melting_point_celsius,
        p.boiling_point_celsius
    FROM elements e
    JOIN properties p ON e.atomic_number = p.atomic_number
    WHERE e.atomic_number::text = '$input' OR e.symbol = '$input' OR e.name = '$input';")

    if [[ -z "$result" ]]; then
        echo "I could not find that element in the database."
    else
        # Format the output
        echo "$result" | awk -F '|' '{ 
            gsub(/^[ \t]+|[ \t]+$/, "", $1); 
            gsub(/^[ \t]+|[ \t]+$/, "", $2); 
            gsub(/^[ \t]+|[ \t]+$/, "", $3); 
            gsub(/^[ \t]+|[ \t]+$/, "", $4); 
            gsub(/^[ \t]+|[ \t]+$/, "", $5); 
            gsub(/^[ \t]+|[ \t]+$/, "", $6); 
            print "The element with atomic number " $1 " is " $3 " (" $2 "). It'\''s a nonmetal, with a mass of " $4 " amu. " $3 " has a melting point of " $5 " celsius and a boiling point of " $6 " celsius."
        }'
    fi
}

# Handle the argument and display the element information
display_element "$1"
