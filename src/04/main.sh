#!/bin/bash
. ./part04.conf 

function print_system_research {
detect_color $1
left_fone_color="\033[4$?m"
detect_color $2
left_text_color="\033[3$?m"
detect_color $3
right_fone_color="\033[4$?m"
detect_color $4
right_text_color="\033[3$?m"

color_default="\033[37m\033[0m"
echo -e "${left_fone_color}${left_text_color}HOSTNAME${color_default} = ${right_fone_color}${right_text_color}$hostname${color_default}
${left_fone_color}${left_text_color}TIMEZONE${color_default} = ${right_fone_color}${right_text_color}$timezone${color_default}
${left_fone_color}${left_text_color}USER${color_default} = ${right_fone_color}${right_text_color}$user${color_default}
${left_fone_color}${left_text_color}OS${color_default} = ${right_fone_color}${right_text_color}$os${color_default}
${left_fone_color}${left_text_color}DATE${color_default} = ${right_fone_color}${right_text_color}$date${color_default}
${left_fone_color}${left_text_color}UPTIME${color_default} = ${right_fone_color}${right_text_color}$uptime${color_default}
${left_fone_color}${left_text_color}UPTIME_SEC${color_default} = ${right_fone_color}${right_text_color}$uptime_sec${color_default}
${left_fone_color}${left_text_color}IP${color_default} = ${right_fone_color}${right_text_color}$ip${color_default}
${left_fone_color}${left_text_color}MASK${color_default} = ${right_fone_color}${right_text_color}$mask${color_default}
${left_fone_color}${left_text_color}GATEWAY${color_default} = ${right_fone_color}${right_text_color}$gateway${color_default}
${left_fone_color}${left_text_color}RAM_TOTAL${color_default} = ${right_fone_color}${right_text_color}$ram_total${color_default}
${left_fone_color}${left_text_color}RAM_USED${color_default} = ${right_fone_color}${right_text_color}$ram_used${color_default}
${left_fone_color}${left_text_color}RAM_FREE${color_default} = ${right_fone_color}${right_text_color}$ram_free${color_default}
${left_fone_color}${left_text_color}SPACE_ROOT${color_default} = ${right_fone_color}${right_text_color}$space_root${color_default}
${left_fone_color}${left_text_color}SPACE_ROOT_USED${color_default} = ${right_fone_color}${right_text_color}$space_root_used${color_default}
${left_fone_color}${left_text_color}SPACE_ROOT_FREE${color_default} = ${right_fone_color}${right_text_color}$space_root_free${color_default}"

pr_color_schema $def
}

function detect_color {
  res=0
  case "$1" in
    1) res=7;;
    2) res=1;;
    3) res=2;;
    4) res=4;;
    5) res=5;;
    6) res=0;;
  esac
  return $res
}

function pr_color_schema {
  echo -e "\nColumn 1 background = $( if [[ $1 -eq 1 ]] ; then echo "default (black)" ; else echo -n ${column1_background}; get_color_name ${column1_background}; fi )
Column 1 font color = $( if [[ $1 -eq 1 ]] ; then echo "default (white)" ; else echo -n ${column1_font_color}; get_color_name ${column1_font_color}; fi )
Column 2 background = $( if [[ $1 -eq 1 ]] ; then echo "default (red)" ; else echo -n ${column2_background}; get_color_name ${column2_background}; fi )
Column 2 font color = $( if [[ $1 -eq 1 ]] ; then echo "default (blue)" ; else echo -n ${column2_font_color}; get_color_name ${column2_font_color}; fi )"
}

function get_color_name {
  case "$1" in
    1) echo " (white)" ;;
    2) echo " (red)" ;;
    3) echo " (green)" ;;
    4) echo " (blue)" ;;
    5) echo " (purple)" ;;
    6) echo " (black)" ;;
  esac
}

hostname=$(hostname)
timezone="$(cat /etc/timezone) $(date -u "+%Z") $(date "+%z")"
user=$(whoami)
os=$(cat /etc/issue | awk '{print $1,$2,$3}' | tr -s '\r\n' ' ')
date=$(date +"%d %b %Y %T")
uptime=$(uptime -p)
uptime_sec=$(awk '{print $1}' /proc/uptime)
ip=$(hostname -I)
mask=$(ifconfig | grep -m1 netmask | awk '{print $4}')
gateway=$(ip -4 route show default | grep "[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*" -o)
ram_total=$(free -m | awk '/Mem:/{printf "%.3f GB", $2/1024}')
ram_used=$(free -m | awk '/Mem:/{printf "%.3f GB", $3/1024}')
ram_free=$(free -m | awk '/Mem:/{printf "%.3f GB", $4/1024}')
space_root=$(df /root/ | awk '/\/$/ {printf "%.2f MB", $2/1024}')
space_root_used=$(df /root/ | awk '/\/$/ {printf "%.2f MB", $3/1024}')
space_root_free=$(df /root/ | awk '/\/$/ {printf "%.2f MB", $4/1024}')
reg='^[1-6]$'
def=0
if ! [[ $column1_background =~ $reg ]] || ! [[ $column1_font_color =~ $reg ]] ||
    ! [[ $column2_background =~ $reg ]] || ! [[ $column2_font_color =~ $reg ]]
then
def=1
print_system_research 6 1 2 4
else
print_system_research ${column1_background} ${column1_font_color} ${column2_background} ${column2_font_color}
fi