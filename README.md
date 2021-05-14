# Vaccine availability notifier
Fed up with checking the availability for vaccine on COWIN and with me not receiving alerts from notifiers on phones or me being away from phone during availability caused me to think a medium I could be better notified.
Since, available on laptop mostly, thought a cron to notify would be better!

The scripts when setup with cron send out notifications with a sound and also log the vaccination centres in the format ```{ pincode: 413102, date: 27-05-2021, min_age_limit: 45, available_capacity: 2 }```.
The scripts currently look out for availability for next 3 weeks from the sys date.

A sample notification

![image](https://user-images.githubusercontent.com/7105292/118262023-f2d2d500-b4d1-11eb-8c49-d99970521f4f.png)


## Steps to setup cron and get notified on availibilty of vaccine (For MacOS)
1. Copy the scripts to a directory and note the path
2. Setup cron(s) as below to run every minute:
```
* * * * * cd ~/vaccine && ./finder_45.sh 363 >> ~/vaccine/45.log
* * * * * cd ~/vaccine && ./finder_18.sh 363 >> ~/vaccine/18.log
```
- "vaccine" in the above snippet is the directory where the scripts were stored at the time of cron setup
- 363 is the district Id (Can be easily obtained from COWIN network calls)
- Logs for the periodic runs are stored in ~/vaccine/45.log and ~/vaccine/18.log respectively


## Things to change if the script does not work
1. Change path to curl and jq and replace accordingly in the script in this line for finder_45.sh:

```
temp=`/usr/bin/curl -s --location --request GET "https://cdn-api.co-vin.in/api/v2/appointment/sessions/public/calendarByDistrict?district_id=$1&date=$dt" --header 'Host: cdn-api.co-vin.in' --header 'User-Agent: Mozilla' --header 'Cookie: troute=t1;'  | /usr/local/bin/jq '.centers' | /usr/local/bin/jq '.[] | {pincode: .pincode, date: .sessions[].date, min_age_limit: .sessions[].min_age_limit, available_capacity: .sessions[].available_capacity} | select(.available_capacity > 0)' | xargs`
```

2. Change path to curl and jq and replace accordingly in the script in this line for finder_18.sh:

```
temp=`/usr/bin/curl -s --location --request GET "https://cdn-api.co-vin.in/api/v2/appointment/sessions/public/calendarByDistrict?district_id=$1&date=$dt" --header 'Host: cdn-api.co-vin.in' --header 'User-Agent: Mozilla' --header 'Cookie: troute=t1;'  | /usr/local/bin/jq '.centers' | /usr/local/bin/jq '.[] | {pincode: .pincode, date: .sessions[].date, min_age_limit: .sessions[].min_age_limit, available_capacity: .sessions[].available_capacity} | select(.min_age_limit < 45) | select(.available_capacity > 0)' | xargs`
```
3. Ofcourse curl and jq should be installed on your Mac for 1 and 2



