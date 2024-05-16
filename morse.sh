#!/bin/bash
declare -A morse_code=(
    ['A']='.-' ['B']='-...' ['C']='-.-.' ['D']='-..' ['E']='.' ['F']='..-.' ['G']='--.' ['H']='....'
    ['I']='..' ['J']='.---' ['K']='-.-' ['L']='.-..' ['M']='--' ['N']='-.' ['O']='---' ['P']='.--.'
    ['Q']='--.-' ['R']='.-.' ['S']='...' ['T']='-' ['U']='..-' ['V']='...-' ['W']='.--' ['X']='-..-'
    ['Y']='-.--' ['Z']='--..' ['0']='-----' ['1']='.----' ['2']='..---' ['3']='...--' ['4']='....-'
    ['5']='.....' ['6']='-....' ['7']='--...' ['8']='---..' ['9']='----.' [' ']='/'
)

dot_symbol="."
line_symbol="-"


print_help() {
    echo "Usage: $0 [-h] [-d DOT_SYMBOL] [-l LINE_SYMBOL] [MESSAGE]"
    echo "Converts the given text to Morse code."
    echo ""
    echo "  -h, --help"
    echo "  -d, --dot SYMBOL     symbol for dot in Morse code (default: '.')"
    echo "  -l, --line SYMBOL   symbol for line in Morse code (default: '-')"
    echo ""
    echo "Arguments:"
    echo "  MESSAGE              Text to convert to Morse code"
}

text_to_morse(){
    local input="$1"    #argument przekazany do funkcji
    local morse=""     #zmienna przechowująca tłumaczenie na kod morse'a
    local len=${#input}  #długość tekstu

    for (( i=0; i<len; i++ )); do
        textcharacter="${input:i:1}"   #przypisanie do zmiennej textcharacter znaku z tekstu na pozycji i
        if [[ "${morse_code[$textcharacter]+isset}" ]]; then
            characterInMorse="${morse_code[$textcharacter]}"
            len_of_characterInMorse=${#characterInMorse} 
            for (( j=0; j<len_of_characterInMorse; j++ )); do       #iteruje po przetłumaczonym znaku, tam gdzie jest - w słowniku tam daje znak obecnie trakowany jako line_symbol, tam gdzie jest . to daje dot_symbol 
                if [[ "${characterInMorse:$j:1}" == "." ]]; then
                    morse+="$dot_symbol" 
                elif [[ "${characterInMorse:$j:1}" == "-" ]]; then
                    morse+="$line_symbol" 
                else
                    morse+=" "
                fi
            done
        else 
            morse+="$textcharacter "
        fi
    done

    echo "$morse"
}


while getopts ":hd:l:" opt; do   #to getopts jest po to aby przełączniki -h -d -l byly rozpoznawane przez skrypt, jest h jest bez : bo nie ma argumentu a jest tylko flaga, d i l mają bo wymagają podania 
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
            echo "Invalid option: $OPTARG" 1>&2   #1>&2 to przekierowanie błędów na stderr
            print_help
            exit 1
            ;;
        : )
            echo "Invalid option: $OPTARG requires an argument" 1>&2  #1>&2 to przekierowanie błędów na stderr
            print_help
            exit 1
            ;;
    esac
done
shift $((OPTIND -1))   #shift przesuwa argumenty o podaną wartość, OPTIND to zmienna która przechowuje indeks ostatniego przetworzonego argumentu, -1 bo indeksy są od 1 a shift przesuwa o 1

if [[ "$#" -eq 0 ]]; then   #jeśli liczba wszystkich argumentów jest równa 0 to wywołaj funkcję print_help
    print_help
else
    text="$*"                                   #zmienna text przechowuje wszystkie argumenty-> przez zrobienie shifta po prawej stronie są tylko te argumenty które są tekstem do przetłumaczenia
    morse_text=$(text_to_morse "$text")       #te " " są po to aby przekazać cały tekst jako jeden argument aby spacje nie były trakowane jako nowe argumenty
    echo "Morse Code: $morse_text"

    for (( i=0; i<${#morse_text}; i++ )); do
        if [[ "${morse_text:$i:1}" == "$dot_symbol" ]]; then
            sox -n -r 44100 -b 16 -c 1 tone.wav synth 0.2 sine 1000
            aplay tone.wav > /dev/null 2>&1 #przekierowanie wyjścia do /dev/null aby nie wyświetlało komunikatów
            rm tone.wav
        elif [[ "${morse_text:$i:1}" == "$line_symbol" ]]; then
            sox -n -r 44100 -b 16 -c 1 tone.wav synth 0.5 sine 1000
            aplay tone.wav > /dev/null 2>&1 #przekierowanie wyjścia do /dev/null aby nie wyświetlało komunikatów
            rm tone.wav
        else
            sleep 0.3
        fi
    
        
    done
fi
