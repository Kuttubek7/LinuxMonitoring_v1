#!/bin/bash

function print_number_folders {
  echo "Total number of folders (including all nested ones) = $(find $1 -type d | wc -l)"
}

function print_top5_max_folders {
  echo "TOP 5 folders of maximum size arranged in descending order (path and size):"
  du -h $1 | sort -hr | head -5 | awk 'BEGIN{i=1}{printf "%d - %s, %s\n",i,$2,$1;i++}'
}

function print_total_numbers_of_file {
  echo "Total number of files = $(find ${1} -type f | wc -l)"
}

function print_conf_text_x_log_tar_simlink_numbers {
  echo "Number of:"
  echo "Configuration files (with the .conf extension) = $(find $1 -type f -name "*.conf" | wc -l)"
  echo "Text files = $(find $1 -type f -name "*.txt" | wc -l)"
  echo "Executable files = $(find $1 -type f -executable | wc -l)"
  echo "Log files (with the extension .log) = $(find $1 -type f -name "*.log" | wc -l)"
  echo "Archive files = $(find $1 -type f -name "*.zip" -o -name "*.7z" -o -name "*.rar" -o -name "*.tar" | wc -l)"
  echo "Symbolic links = $(find $1 -type l | wc -l)"
}

function print_top10_max_size {
  echo "TOP 10 files of maximum size arranged in descending order (path, size and type):"
  count_num=$(find $1 -type f | wc -l)
  if [[ $count_num -ge 10 ]] && [[ $count_num -ne 0 ]]
  then
    count_num=10
  fi
  for (( i = 1 ; i <= $count_num; i++ ))
  do 
    files_l=$(find $1 -type f -exec du -h {} + | sort -rh | head -$i | tail -1)
    if [[ -z $files ]]
    then
      echo "$i - $(echo $files_l | awk '{print $2}'), $(echo $files_l | awk '{print $1}'),\
 $(echo $files_l | grep -m 1 -o -E "\.[^/.]+$" | awk -F . '{print $2}')"
    fi
  done
}

function print_top10_x_max_size {
  echo "TOP 10 executable files of the maximum size arranged in descending order (path, size and MD5 hash of file)"
  count_num=$(find $1 -type f -executable | wc -l)
  if [[ $count_num -ge 10 ]] && [[ $count_num -ne 0 ]]
  then
    count_num=10
  fi
  for (( i = 1 ; i <= $count_num; i++ ))
  do 
    files_l=$(find $1 -type f -executable -exec du -h {} + | sort -rh | head -$i | tail -1)
    if [[ -z $files ]]
    then
      echo "$i - $(echo $files_l | awk '{print $2}'), $(echo $files_l | awk '{print $1}'), \
$(echo $files_l | awk '{print $2}' | md5sum | awk '{print $1}')"
    fi
  done
}
function print_time {
  end=$(date +%s)
  echo "Script execution time (in seconds) = $(($end - $1))"
}

begin=$(date +%s)
if [[ $# -eq 1 ]]
then
  if [[ ${1: -1} = "/" ]]
  then
    if [[ -d $1 ]]
    then
      print_number_folders $1
      print_top5_max_folders $1
      print_total_numbers_of_file $1
      print_conf_text_x_log_tar_simlink_numbers $1
      print_top10_max_size $1
      print_top10_x_max_size $1
      print_time $begin
      
    else
      echo "The parameter is not an existing directory. Try again."
    fi
  else
    echo "The parameter must end with a '/' sign. Try again."
  fi
else
  echo "The script should be run with one parameter. Try again."
fi