#!/bin/bash

# 1. Check if the user provided exactly 2 arguments
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <model> <session>"
    echo "Example: $0 Pwt session0"
    exit 1
fi

MODEL=$1
SESSION=$2

# 2. Define directories dynamically
IN_DIR=~/github/GraphIDS/null_models/$MODEL/$SESSION
OUT_DIR="$IN_DIR/counts"

# 3. Define the exact path to your executable
EXEC_PATH=~/github/snap/examples/temporalmotifs

# 4. Safety check: Ensure the input directory actually exists
if [ ! -d "$IN_DIR" ]; then
    echo "Error: Directory $IN_DIR does not exist. Please check your spelling."
    exit 1
fi

# 5. Ensure the output directory exists
mkdir -p "$OUT_DIR"

echo "Starting job for Model: $MODEL | Session: $SESSION"
echo "---------------------------------------------------"

# 6. Loop through all gen*.txt files
for input_file in "$IN_DIR"/gen*.txt; do
    
    # Safety check: if no files match, exit the loop
    [ -e "$input_file" ] || { echo "No gen*.txt files found in $IN_DIR"; break; }

    base_name=$(basename "$input_file")
    out_name="${base_name/gen/out}"
    output_file="$OUT_DIR/$out_name"
    
    echo "Processing: $base_name -> $out_name"
    
    # Run the executable using its absolute path
    "$EXEC_PATH/temporalmotifsmain" -i:"$input_file" -delta:1000 -o:"$output_file" -nt:12

done

echo "---------------------------------------------------"
echo "Done processing $MODEL/$SESSION!"