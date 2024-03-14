#!/bin/bash
hostname=$(hostname)
timezone="$(cat /etc/timezone) $(date -u "+%Z") $(date "+%z")"
user=$(whoami)
os=$(cat /etc/issue | awk '{print $1,$2,$3}' | tr -s '\r\n' ' ')
date=$(date +"%e %b %Y %T")
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

function print_system_research {
  echo "HOSTNAME = $hostname
TIMEZONE = $timezone
USER = $user
OS = $os
DATE = $date
UPTIME = $uptime
UPTIME_SEC = $uptime_sec
IP = $ip
MASK = $mask
GATEWAY = $gateway
RAM_TOTAL = $ram_total
RAM_USED = $ram_used
RAM_FREE = $ram_free
SPACE_ROOT = $space_root
SPACE_ROOT_USED = $space_root_used
SPACE_ROOT_FREE = $space_root_free"
}

function save_to_file {
  read -p "save data into file? Y/n: " answer
  res=0

  if [ "$answer" = "Y" ] || [ "$answer" = "y" ]
  then
    res=1
  fi

  return $res
}

print_system_research
save_to_file

if [[ $? -eq 1 ]]
then
  current_date=$(date "+%d_%m_%y_%H_%M_%S")
  filename="$current_date.status"
  print_system_research >> $filename
fi