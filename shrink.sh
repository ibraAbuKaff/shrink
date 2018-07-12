#!/bin/bash

# Functions ==============================================

# return 1 if global command line program installed, else 0
# example
# echo "node: $(program_is_installed node)"
function program_is_installed {
  # set to 1 initially
  local return_=1
  # set to 0 if not found
  type $1 >/dev/null 2>&1 || { local return_=0; }
  # return value
  echo "$return_"
}

# display a message in red with a cross by it
# example
# echo echo_fail "No"
function echo_fail {
  # echo first argument in red
  printf "\e[31m✘ ${1}"

  printf "\e[31m Make sure the libraries are installed on your system"

  # reset colours back to normal
  printf "\033\e[0m"

}

# display a message in green with a tick by it
# example
# echo echo_fail "Yes"
function echo_pass {
  # echo first argument in green
  printf "\e[32m✔ ${1}"
  # reset colours back to normal
  printf "\033\e[0m"
}

# echo pass or fail
# example
# echo echo_if 1 "Passed"
# echo echo_if 0 "Failed"
function echo_if {
  if [ $1 == 1 ]; then
    echo_pass $2
  else
    echo_fail $2
  fi
}

# Functions ==============================================



#check if jq and curl has been installed or not
echo "==================================================="
echo "checking jq   if   already installed    $(echo_if $(program_is_installed jq))"
echo "checking curl if   already installed    $(echo_if $(program_is_installed curl))"
echo "==================================================="

# accept url as a parameterclear
URL_TO_BE_SHORTENED=$1
# make call for the api
response=$(curl  --silent -H 'Accept: application/json' -H 'Content-Type: application/json' -X GET "https://3o2.co/api?url=$URL_TO_BE_SHORTENED" | jq  '.short_url,.qr_code,.status')

#converting to array
responseArr=($(echo "$response" | tr '' '\n'))

#Extartc the attributes from response array
SHORT_URL=${responseArr[0]}
QR_SHORT_URL=${responseArr[1]}
STATUS=${responseArr[2]}


if [ "$STATUS" != 201 ] && [ "$STATUS" != 200 ]; then
	printf "\e[31m✘ Error, please try again"
	printf "\033\e[0m"
	exit;
fi


printf "\e[32m✔ Original URL :$URL_TO_BE_SHORTENED \n";
printf "\e[32m✔ Short URL    :$SHORT_URL \n";
printf "\e[32m✔ QR Code      :$QR_SHORT_URL \n";
