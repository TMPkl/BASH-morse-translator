#!/bin/bash

declare -A morse_code=(
    ['A']='.-' ['B']='-...' ['C']='-.-.' ['D']='-..' ['E']='.' ['F']='..-.' ['G']='--.' ['H']='....'
    ['I']='..' ['J']='.---' ['K']='-.-' ['L']='.-..' ['M']='--' ['N']='-.' ['O']='---' ['P']='.--.'
    ['Q']='--.-' ['R']='.-.' ['S']='...' ['T']='-' ['U']='..-' ['V']='...-' ['W']='.--' ['X']='-..-'
    ['Y']='-.--' ['Z']='--..' ['0']='-----' ['1']='.----' ['2']='..---' ['3']='...--' ['4']='....-'
    ['5']='.....' ['6']='-....' ['7']='--...' ['8']='---..' ['9']='----.' [' ']='/'
)

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
                    ./dotsound.sh
                    sleep 0.2
                elif [[ "${foo:$j:1}" == "-" ]]; then
                    ./linesound.sh
                    sleep 0.2
                else
                    sleep 0.6
                fi
	    	sleep 0.4
            done
        else
            morse+="$char "
        fi
        morse+="${morse_code[$char]} "
    done
    echo "$morse"
}

# Funkcja wyświetlająca pomoc
print_help() {
    echo "Użycie: $0 [-h] [WIADOMOSC]"
    echo "Konwertuje podany tekst na kod Morse'a."
    echo ""
    echo "Opcje:"
    echo "  -h, --help      Wyświetla pomoc"
    echo ""
    echo "Argumenty:"
    echo "  WIASOMOSC           Tekst do przekonwertowania na kod Morse'a"
}

if [[ "$#" -eq 0 || "$1" == "-h" || "$1" == "--help" ]]; then
    print_help
else
    text="$*"
    morse_text=$(text_to_morse "$text")
    echo "Kod Morse'a: $morse_text"
fi
