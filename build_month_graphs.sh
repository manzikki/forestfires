if [ $# -ne 1 ]
then
echo "Param needed"
exit
fi
fname=$1
j=2003
vals=`grep "CO2 emissions" $fname | sed 's/.*:  //' | sed 's/"//'`
arr=(${vals})
echo "Year,CO2"> $fname.co2.csv
for i in "${arr[@]}"
do
    echo $j,$i >> $fname.co2.csv
    ((j++))
done
j=2003
vals=`grep "PM2.5 emissions" $fname | sed 's/.*:  //' | sed 's/"//'`
arr=(${vals})
echo "Year,PM2.5"> $fname.pm25.csv
for i in "${arr[@]}"
do
    echo $j,$i >> $fname.pm25.csv
    ((j++))
done
j=2003
vals=`grep "FRP per" $fname | sed 's/.*:  //' | sed 's/"//'`
arr=(${vals})
echo "Year,FRP"> $fname.frp.csv
for i in "${arr[@]}"
do
    echo $j,$i >> $fname.frp.csv
    ((j++))
done

