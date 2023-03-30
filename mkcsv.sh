#!/bin/bash

csv_header() {
  echo "\"Month\",\"Password\",\"Network Name\",\"#QRCode\""
}

csv_row() {
  echo "${row}"
}

read_starting_dates() {
  re='^[0-9]+$'

  read -p "Starting month [1-12; Defaults to current month]: " starting_month

  if [ -z $starting_month ]; then
    starting_month=$(date +%-m)
  fi

  if ! [[ $starting_month =~ $re ]] ; then
    echo "error: Not a number" >&2; exit 1
  fi

  read -p "Starting year [YYYY; Defaults to current year]: " starting_year

  if [ -z $starting_year ]; then
    starting_year=$(date +%Y)
  fi

  if ! [[ $starting_year =~ $re ]] ; then
    echo "error: Not a number" >&2; exit 1
  fi

  echo "Starting Month: ${months[$starting_month-1]}"
  echo "Starting Year: $starting_year"
}

generate_months_list() {
  months_list=()

  current_month=$((starting_month-1))
  current_year=$starting_year

  for i in {1..12}; do
    months_list+=("${months[$current_month]} ${current_year}")

    current_month=$((current_month+1))

    if [[ current_month -gt 11 ]]; then
      current_month=0
      current_year=$((current_year+1))
    fi
  done
}

months=("January" "February" "March" "April" "May" "June" "July" "August" "September" "October" "November" "December")
output_filename="passwords.csv"
rows=()

if [ -f .env ]; then
  export $(echo $(cat .env | sed 's/#.*//g'| xargs) | envsubst)
fi

network_name=$(printenv NETWORK_NAME)

read_starting_dates
generate_months_list

echo "Generating CSV contents..."

for month in "${months_list[@]}"; do
  password=$(cat /dev/urandom | LC_ALL=C tr -dc 'a-zA-Z0-9' | fold -w 8 | sed 1q)
  qr_code="WIFI:S:${network_name};T:WPA;P:${password};;"
  row="\"${month}\",\"${password}\",\"${network_name}\",\"${qr_code}\""

  rows+=("${row}")
done

csv_header
for row in "${rows[@]}"; do
  csv_row
done

csv_header > "${output_filename}"

for row in "${rows[@]}"; do
  csv_row >> "${output_filename}"
done