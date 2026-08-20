#!/bin/bash

MENU_SELECTOR()
{
    local options=("$@")
    local selected=0
    local key
    local num_options=${#options[@]}
    echo
    for i in "${!options[@]}"; do
        if [[ $i -eq $selected ]]; then
            printf "${RESET}${PROMPTSTYLE}${BOLD}                >-%s\033[0m\n" "${options[$i]}"
        else
            printf "                  ${RESET}${TITLE}%s\n" "${options[$i]}"
        fi
    done
    while true; do
        tput cuu $num_options
        for i in "${!options[@]}"; do
            if [[ $i -eq $selected ]]; then
                printf "${RESET}${PROMPTSTYLE}${BOLD}                >-%s\033[0m\n" "${options[$i]}-<"
            else
                printf "                  ${RESET}${TITLE}%s\n" "${options[$i]}  "
            fi
        done
        IFS= read -rsn1 key
        case "$key" in
            $'\x1b')
                IFS= read -rsn2 -t 1 rest || continue
                case "$rest" in
                    "[A")
                        ((selected--))
                        ((selected < 0)) && selected=$((num_options - 1))
                        ;;
                    "[B")
                        ((selected++))
                        ((selected >= num_options)) && selected=0
                        ;;
                esac
                ;;
            "")
                return $selected
                ;;
            [Qq])
                return 111
                ;;
            [Cc])
                return 110
                ;;
            *)
                ;;
        esac
    done
}
MAINMENU()
{
	if [[ $FIRSTTIMEHERE=='TRUE' ]]; then
		cd "$SCRIPTPATHMAIN"
		sed -i '' '8856s/TRUE/FALSE/' macOS\ Creator.command
	fi
	FIRSTTIMEHERE="FALSE"
	ENTERHERE="TRUE"
	WINDOWBAR
	echo -e "${RESET}${TITLE}${BOLD}                            macOS Creator Home menu${RESET}"
	echo -e "${RESET}${BODY}                        Press ${BOLD}W${RESET}${BODY} to see list of controls${RESET}"
	echo -e "${RESET}${BODY}                  Use ${BOLD}↑ ↓${RESET}${BODY} to navigate. Press ${BOLD}Return${RESET}${BODY} to select${RESET}"
	echo -e "${CANCEL}                     To show the help menu, press the ${BOLD}? ${RESET}${CANCEL}key${RESET}"
	echo -e ""
	echo -e "${TITLE}${BOLD}                            Please choose an option:${RESET}${BODY}"
	menuoptions=("-----------Create macOS Installer-----------" \
             	"-------------Identify Mac model-------------" \
             	"------------------Settings------------------" \
             	"-----------------User Guide-----------------" \
             	"--------------------Exit--------------------" )
	MENU_SELECTOR "${menuoptions[@]}"
	selection=$?
	if [[ $selection -eq 000 ]]; then
    	AUTOMACOSINSTALL
    elif [[ $selection -eq 004 ]]; then
    	WINDOWBAREND
    elif [[ $selection -eq 110 ]]; then
    	echo "Credits"
	else
    	WINDOWERROR
	fi
}
MAINMENU
