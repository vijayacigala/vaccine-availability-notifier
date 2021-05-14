#!/bin/bash

dt=`date +"%d-%m-%Y"`

ctr=0
results=''

while [ $ctr -lt 3 ]
do
  temp=`/usr/bin/curl -s --location --request GET "https://cdn-api.co-vin.in/api/v2/appointment/sessions/public/calendarByDistrict?district_id=363&date=${dt}" --header 'Host: cdn-api.co-vin.in' --header 'User-Agent: Mozilla' --header 'Cookie: troute=t1;'  | /usr/local/bin/jq '.centers' | /usr/local/bin/jq '.[] | {pincode: .pincode, date: .sessions[].date, min_age_limit: .sessions[].min_age_limit, available_capacity: .sessions[].available_capacity} | select(.min_age_limit < 45) | select(.available_capacity > 0)' | xargs`

  results="${results}${temp}"
  inc=`expr $ctr \* 7`
  dt=`date -v +"$inc"d +"%d-%m-%Y"`
  ctr=`expr $ctr + 1`
done

result=`echo -n ${results} | wc -m`
if [ $result -gt 0 ]
then
  osascript -e 'display notification "18+ vaccine available" with title "Vaccine" subtitle "18+ vaccine available" sound name "Glass"'
  echo "$(date) Slot available"
  echo $results
else
  echo "$(date) No slots"
fi
