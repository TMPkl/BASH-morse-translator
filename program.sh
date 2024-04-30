#!/bin/bash

# Default Morse code mapping
declare -A morse_code=(
    ['A']='.-' ['B']='-...' ['C']='-.-.' ['D']='-..' ['E']='.' ['F']='..-.' ['G']='--.' ['H']='....'
    ['I']='..' ['J']='.---' ['K']='-.-' ['L']='.-..' ['M']='--' ['N']='-.' ['O']='---' ['P']='.--.'
    ['Q']='--.-' ['R']='.-.' ['S']='...' ['T']='-' ['U']='..-' ['V']='...-' ['W']='.--' ['X']='-..-'
    ['Y']='-.--' ['Z']='--..' ['0']='-----' ['1']='.----' ['2']='..---' ['3']='...--' ['4']='....-'
    ['5']='.....' ['6']='-....' ['7']='--...' ['8']='---..' ['9']='----.' [' ']='/'
)

# Default symbols for dot and line
dot_symbol="."
line_symbol="-"

# Function to convert text to Morse code
text_to_morse() {
    local input="$1"
    local morse=""
    local len=${#input}

    for (( i=0; i<len; i++ )); do
        char="${input:$i:1}"
        if [[ "${morse_code[$char]+isset}" ]]; then
            foo="${morse_code[$char]}"
            for (( j=0; j<${#foo}; j++ )); do
                if [[ "${foo:$j:1}" == "." ]]; then
                    echo -n "$dot_symbol" # Output dot symbol
                    sleep 0.1
                elif [[ "${foo:$j:1}" == "-" ]]; then
                    echo -n "$line_symbol" # Output line symbol
                    sleep 0.1
                else
                    sleep 0.3
                fi
            done
        else
            morse+="$char "
        fi
        morse+="${morse_code[$char]} "
    done
    echo "$morse"
}

# Function to print help
print_help() {
    echo "Usage: $0 [-h] [-d DOT_SYMBOL] [-l LINE_SYMBOL] [MESSAGE]"
    echo "Converts the given text to Morse code."
    echo ""
    echo "Options:"
    echo "  -h, --help           Display this help message"
    echo "  -d, --dot SYMBOL     Specify the symbol for dot in Morse code (default: '.')"
    echo "  -l, --line SYMBOL    Specify the symbol for line in Morse code (default: '-')"
    echo ""
    echo "Arguments:"
    echo "  MESSAGE              Text to convert to Morse code"
}

# Parse options
while getopts ":hd:l:" opt; do
    case ${opt} in
        h )
            print_help
            exit 0
            ;;
        d )
            dot_symbol="$OPTARG"
            ;;
        l )
            line_symbol="$OPTARG"
            ;;
        \? )
            echo "Invalid option: $OPTARG" 1>&2
            print_help
            exit 1
            ;;
        : )
            echo "Invalid option: $OPTARG requires an argument" 1>&2
            print_help
            exit 1
            ;;
    esac
done
shift $((OPTIND -1))

if [[ "$#" -eq 0 ]]; then
    print_help
else
    text="$*"
    morse_text=$(text_to_morse "$text")
    echo "Morse Code: $morse_text"
fi
