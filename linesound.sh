#!/bin/bash

sox -n -r 44100 -b 16 -c 1 tone.wav synth 0.5 sine 1000

aplay tone.wav > /dev/null 2>&1

rm tone.wav













