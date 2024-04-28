#!/bin/bash

sox -n -r 44100 -b 16 -c 1 tone.wav synth 0.5 sine 1000

aplay tone.wav

rm tone.wav













