#!/bin/bash
dt=`date +"%d-%m-%Y"`

ctr=0
results='[]'

while [ $ctr -lt 3 ]
do
  temp=`/usr/bin/curl -s --location --request GET "https://cdn-api.co-vin.in/api/v2/appointment/sessions/public/calendarByDistrict?district_id=$1&date=$dt" --header 'Host: cdn-api.co-vin.in' --header 'User-Agent: Mozilla' --header 'Cookie: troute=t1;'  | /usr/local/bin/jq '.centers | [.[] | .pincode as $pc | (.sessions[] | {pincode: $pc, date: .date, min_age_limit: .min_age_limit, available_capacity: .available_capacity}) | select(.available_capacity > 0)]'`

  results="[ ${results},${temp} ]"
  results=`echo $results | /usr/local/bin/jq flatten | /usr/local/bin/jq unique`
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
