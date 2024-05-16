#!/bin/bash

# Generate tone using sox
sox -n -r 44100 -b 16 -c 1 tone.wav synth 0.5 sine 1000

# Play the generated tone using aplay
aplay tone.wav > /dev/null 2>&1

# Print a message indicating that the tone is being played
echo "Playing line sound"

# Remove the temporary audio file
rm tone.wav









