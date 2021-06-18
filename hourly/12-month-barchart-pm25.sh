year=$1
month=$2
lastyear=$(( $year -1 ))
#echo $lastyear
#iterate
m=$month
echo "Month,AVG" > twelwe.csv
while [ $m -lt 13 ]
do
    pm=$lastyear-${m}-SEA
    if [ $m -lt 10 ]
    then
        pm=$lastyear-0${m}-SEA
    fi
    cat $pm*txt | sed 's/\[1\] "//' | sed 's/ Average fire PM2.5 emissions per day: /,/' | sed 's/ .*//' >> twelwe.csv
    ((m++))
done
m=1
while [ $m -lt $month ]
do
    pm=$year-${m}-SEA
    if [ $m -lt 10 ]
    then
        pm=$year-0${m}-SEA
    fi
    cat $pm*txt | sed 's/\[1\] "//' | sed 's/ Average fire PM2.5 emissions per day: /,/' | sed 's/ .*//' >> twelwe.csv
    ((m++))
done
