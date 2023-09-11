#!/bin/bash

# Ensure that ffmpeg is installed
if ! command -v ffmpeg &> /dev/null; then
    echo "ffmpeg is not installed. Please install ffmpeg and try again."
    exit 1
fi

# Iterate through all .pcm files in the current directory and convert them to .wav
for f in *.pcm; do
    if [ -f "$f" ]; then
        output_wav="${f%.*}.wav"
        echo "Converting $f to $output_wav"
        ffmpeg -loglevel panic -f s16le -y -ar 16000 -ac 1 -i "$f" -ar 16000 -ac 1 "$output_wav"
        echo "Conversion complete for $f"
    fi
done

echo "All conversions are complete!"
