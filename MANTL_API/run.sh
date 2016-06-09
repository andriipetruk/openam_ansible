#!/bin/bash

#
# MANTL REST shell client v1.0
# Andrii Petruk <apetruk@cisco.com>
#


# colors pre set
RED_BOLD='\033[01;31m' # bold red
NORMAL=`echo "\033[m"`
MENU=`echo "\033[36m"` #Blue
NUMBER=`echo "\033[33m"` #yellow
FGRED=`echo "\033[41m"`
RED_TEXT=`echo "\033[31m"`
ENTER_LINE=`echo "\033[33m"`


show_menu(){
    clear
    cat logo_mantl
    echo -e "${RED_TEXT} Welcome to MANTL Shell REST Client - interactive mode"
    echo -e "${MENU}*********************************************${NORMAL}"
    echo -e "${MENU}**${NUMBER} 1)${MENU} Authentication ${NORMAL}"
    echo -e "${MENU}**${NUMBER} 2)${MENU} Deploy app ${NORMAL}"
    echo -e "${MENU}**${NUMBER} 3)${MENU} List all running apps${NORMAL}"
    echo -e "${MENU}**${NUMBER} 4)${MENU} Destroy app ${NORMAL}"
    echo -e "${MENU}**${NUMBER} X)${MENU} Exit ${NORMAL}"
    echo -e "${MENU}**${NUMBER} C)${MENU} Configure Settings ${NORMAL}"
    echo -e "${MENU}*********************************************${NORMAL}"
    echo -e "${ENTER_LINE}Please enter a menu option and enter ${NORMAL}"
    read option

        case $option in

                1)
                        authn_module
                        ;;

                2)
                        marathon_deploy_module
                        ;;

                3)
                        marathon_view_module
                        ;;

                 4)
                        marathon_delete_module
                        ;;



                [x] | [X])
                                clear
                                log_out
                                exit
                                ;;

                [c] | [C])

                        config
                        ;;

                *)

                        menu
                        ;;
        esac

}

function config() {

        clear
        chmod 600 settings
        nano settings
        chmod 400 settings
        show_menu
}


function log_out() {

        clear
        ./log_out.sh
        echo ""
        read -p "Press [Enter] to return to menu"

}

function authn_module() {

        clear
        echo "Enter username:"
        read username
        echo "Enter Password:"
        read -s password

        ./get_tokenid.sh $username $password
        echo ""
        read -p "Press [Enter] to return to menu"
        show_menu

}


function marathon_deploy_module() {

        clear
        echo -e "${RED_TEXT} Enter json file name for deploy APP to MANTl:"
        fileList=$(find ./app/ -maxdepth 1 -type f)
         echo -e "${MENU}"
        select fileName in $fileList; do
        if [ -n "$fileName" ]; then
          ./deploy_marathon.sh ${fileName}
        fi
           break
        done
        read -p "Press [Enter] to return to menu"
        show_menu

}

function marathon_view_module() {

        clear
          ./marathon_listapp.sh > marathon_listapp_out.json
         python -m json.tool marathon_listapp_out.json
        read -p "Press [Enter] to return to menu"
        show_menu

}

function marathon_delete_module() {

        clear
        echo -e "${RED_TEXT} Enter APP ID for delete:"
        read app_id  
        ./delete_marathon.sh $app_id
        read -p "Press [Enter] to return to menu"
        show_menu

}


#initiate menu
show_menu

