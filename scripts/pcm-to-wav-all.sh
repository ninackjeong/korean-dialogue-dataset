#!/bin/bash

# Script Name: pcm-to-wav-all.sh
# Created by: Cheonkam Jeong(cheonkamjeong@arizona.edu)
# Date: September 19, 2023
# Description: This script performs a conversion task from pcm files to wav ones
# Usage: ./pcm-to-wav-all.sh

# Function to convert .pcm to .wav without deleting original .pcm files
convert_pcm_to_wav() {
  for f in *.pcm; do
    ffmpeg -loglevel panic -f s16le -y -ar 16000 -ac 1 -i "$f" -ar 16000 -ac 1 "${f%.*}.wav"
  done
}

# Function to convert .pcm to .wav and delete original .pcm files
convert_pcm_to_wav_and_delete() {
  for f in *.pcm; do
    ffmpeg -loglevel panic -f s16le -y -ar 16000 -ac 1 -i "$f" -ar 16000 -ac 1 "${f%.*}.wav" && rm "$f"
  done
}

# Function to convert .pcm files in subdirectories to .wav without deleting original .pcm files
convert_pcm_in_subdirs_to_wav() {
  for D in /Volumes/ssd/corpora/NIKL_DIALOGUE_2020_PCM_v1.3_part1/NIKL_DIALOGUE_2020_PCM_v1.3_part1/part1/pcm/*; do
    if [ -d "$D" ]; then
      find "$D" -type f -name "*.pcm" -exec sh -c '
        for f; do
          ffmpeg -loglevel panic -f s16le -y -ar 16000 -ac 1 -i "$f" -ar 16000 -ac 1 "${f%.*}.wav"
        done' sh {} +
    fi
  done
}

# Function to convert .pcm files in subdirectories to .wav and delete original .pcm files
convert_pcm_in_subdirs_to_wav_and_delete() {
  for D in /Volumes/ssd/corpora/NIKL_DIALOGUE_2020_PCM_v1.3_part1/NIKL_DIALOGUE_2020_PCM_v1.3_part1/part1/pcm/*; do
    if [ -d "$D" ]; then
      find "$D" -type f -name "*.pcm" -exec sh -c '
        for f; do
          ffmpeg -loglevel panic -f s16le -y -ar 16000 -ac 1 -i "$f" -ar 16000 -ac 1 "${f%.*}.wav" && rm "$f"
        done' sh {} +
    fi
  done
}

# Prompt the user to choose which operation to perform
echo "Choose an operation:"
echo "1. Convert .pcm to .wav (Keep .pcm files)"
echo "2. Convert .pcm to .wav and delete .pcm files"
echo "3. Convert .pcm files in subdirectories to .wav (Keep .pcm files)"
echo "4. Convert .pcm files in subdirectories to .wav and delete .pcm files"
read -p "Enter your choice (1/2/3/4): " choice

# Run the selected function based on the user's choice
case "$choice" in
  1) convert_pcm_to_wav ;;
  2) convert_pcm_to_wav_and_delete ;;
  3) convert_pcm_in_subdirs_to_wav ;;
  4) convert_pcm_in_subdirs_to_wav_and_delete ;;
  *) echo "Invalid choice"; exit 1 ;;
esac

echo "Operation completed."
