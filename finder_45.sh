#!/bin/bash
dt=`date +"%d-%m-%Y"`

ctr=0
results='[]'

while [ $ctr -lt 3 ]
do
  temp=`/usr/bin/curl -s --location --request GET "https://cdn-api.co-vin.in/api/v2/appointment/sessions/public/calendarByDistrict?district_id=$1&date=$dt" --header 'Host: cdn-api.co-vin.in' --header 'User-Agent: Mozilla' --header 'Cookie: troute=t1;'  | /usr/local/bin/jq '.centers | [.[] | {pincode: .pincode, date: .sessions[].date, min_age_limit: .sessions[].min_age_limit, available_capacity: .sessions[].available_capacity} | select(.available_capacity > 0)] | unique_by(.pincode,.date)'`

  results="[ ${results},${temp} ]"
  results=`echo $results | jq 'flatten'`
  inc=`expr $ctr \* 7`
  dt=`date -v +"$inc"d +"%d-%m-%Y"`
  ctr=`expr $ctr + 1`
done

if [ ${#results} -gt 2  ]
then
  osascript -e 'display notification "45+ vaccine available" with title "Vaccine" subtitle "45+ vaccine available" sound name "Glass"'
  echo "$(date) Slots available"
  echo $results
else
  echo "$(date) No slots"
fi
