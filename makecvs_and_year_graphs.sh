#This script generates an up to date allc.txt file by running a month-simple-by-country.r over countries in the
#SEA region and appending the numeric results of the month files to allc.txt
#This script creates CVS files from the allc.txt file that has been created by monthly analysis scripts
#Then it creates the "this month each year" graph files.

tfile=allc.txt

#do the allc.txt generation in tmp
mkdir tmp
cp gfas_0001_cfire_climatology_2003_2018.nc month-simple-by-country.r  12-month-barchart-pm25.* tmp
cd tmp
#link data files
ln -s /var/www/html/data/????-??.nc .
rm -f $tfile
#delete the txt files of the most recent nc file so that we regenerate it
lastnc=`ls ????-??.nc | tail -1`
rm $lastnc.txt 
for i in ????-??.nc
do
    for c in THA LAO KHM MMR VNM SEA
    do
         if test -f $i-$c.txt
         then
             echo $i-$c.txt already exists
             cat $i-$c.txt >> $tfile
         else
             Rscript month-simple-by-country.r $i $c > $i-$c.txt
             cat $i-$c.txt >> $tfile
         fi
    done
done
bash 12-month-barchart-pm25.sh
cp SEA-pm25-12m.jpg ..
cp $tfile ..
cd ..

#iterate over months
for i in 01 02 03 04 05 06 07 08 09 10 11 12
do
  echo "Year, Value" > tha$i.pm25.csv
  cat $tfile | grep THA | grep PM2.5 | grep "\-$i" | sed 's/\[1\] "//' | sed 's/-.*day:/,/' | sed 's/ max.*//' >> tha$i.pm25.csv
  echo "Year, Value" > lao$i.pm25.csv
  cat $tfile | grep LAO | grep PM2.5 | grep "\-$i" | sed 's/\[1\] "//' | sed 's/-.*day:/,/' | sed 's/ max.*//' >> lao$i.pm25.csv
  echo "Year, Value" > khm$i.pm25.csv
  cat $tfile | grep KHM | grep PM2.5 | grep "\-$i" | sed 's/\[1\] "//' | sed 's/-.*day:/,/' | sed 's/ max.*//' >> khm$i.pm25.csv
  echo "Year, Value" > mmr$i.pm25.csv
  cat $tfile | grep MMR | grep PM2.5 | grep "\-$i" | sed 's/\[1\] "//' | sed 's/-.*day:/,/' | sed 's/ max.*//' >> mmr$i.pm25.csv
  echo "Year, Value" > vnm$i.pm25.csv
  cat $tfile | grep VNM | grep PM2.5 | grep "\-$i" | sed 's/\[1\] "//' | sed 's/-.*day:/,/' | sed 's/ max.*//' >> vnm$i.pm25.csv
  echo "Year, Value" > sea$i.pm25.csv
  cat $tfile | grep SEA | grep PM2.5 | grep "\-$i" | sed 's/\[1\] "//' | sed 's/-.*day:/,/' | sed 's/ max.*//' >> sea$i.pm25.csv

  echo "Year, Value" > tha$i.frp.csv
  cat $tfile | grep THA | grep FRP | grep "\-$i" | sed 's/\[1\] "//' | sed 's/-.*day:/,/' | sed 's/ max.*//' >> tha$i.frp.csv
  echo "Year, Value" > lao$i.frp.csv
  cat $tfile | grep LAO | grep FRP | grep "\-$i" | sed 's/\[1\] "//' | sed 's/-.*day:/,/' | sed 's/ max.*//' >> lao$i.frp.csv
  echo "Year, Value" > khm$i.frp.csv
  cat $tfile | grep KHM | grep FRP | grep "\-$i" | sed 's/\[1\] "//' | sed 's/-.*day:/,/' | sed 's/ max.*//' >> khm$i.frp.csv
  echo "Year, Value" > mmr$i.frp.csv
  cat $tfile | grep MMR | grep FRP | grep "\-$i" | sed 's/\[1\] "//' | sed 's/-.*day:/,/' | sed 's/ max.*//' >> mmr$i.frp.csv
  echo "Year, Value" > vnm$i.frp.csv
  cat $tfile | grep VNM | grep FRP | grep "\-$i" | sed 's/\[1\] "//' | sed 's/-.*day:/,/' | sed 's/ max.*//' >> vnm$i.frp.csv
  echo "Year, Value" > sea$i.frp.csv
  cat $tfile | grep SEA | grep FRP | grep "\-$i" | sed 's/\[1\] "//' | sed 's/-.*day:/,/' | sed 's/ max.*//' >> sea$i.frp.csv

  echo "Year, Value" > tha$i.co2.csv
  cat $tfile | grep THA | grep CO2 | grep "\-$i" | sed 's/\[1\] "//' | sed 's/-.*day:/,/' | sed 's/ max.*//' >> tha$i.co2.csv
  echo "Year, Value" > lao$i.co2.csv
  cat $tfile | grep LAO | grep CO2 | grep "\-$i" | sed 's/\[1\] "//' | sed 's/-.*day:/,/' | sed 's/ max.*//' >> lao$i.co2.csv
  echo "Year, Value" > khm$i.co2.csv
  cat $tfile | grep KHM | grep CO2 | grep "\-$i" | sed 's/\[1\] "//' | sed 's/-.*day:/,/' | sed 's/ max.*//' >> khm$i.co2.csv
  echo "Year, Value" > mmr$i.co2.csv
  cat $tfile | grep MMR | grep CO2 | grep "\-$i" | sed 's/\[1\] "//' | sed 's/-.*day:/,/' | sed 's/ max.*//' >> mmr$i.co2.csv
  echo "Year, Value" > vnm$i.co2.csv
  cat $tfile | grep VNM | grep CO2 | grep "\-$i" | sed 's/\[1\] "//' | sed 's/-.*day:/,/' | sed 's/ max.*//' >> vnm$i.co2.csv
  echo "Year, Value" > sea$i.co2.csv
  cat $tfile | grep SEA | grep CO2 | grep "\-$i" | sed 's/\[1\] "//' | sed 's/-.*day:/,/' | sed 's/ max.*//' >> sea$i.co2.csv

  mname="Jan"
  if [ $i -eq 02 ]
  then
      mname="Feb"
  fi
  if [ $i -eq 03 ]
  then
      mname="Mar"
  fi
  if [ $i -eq 04 ]
  then
      mname="Apr"
  fi
  if [ $i -eq 05 ]
  then
      mname="May"
  fi
  if [ $i -eq 06 ]
  then
      mname="Jun"
  fi
  if [ $i -eq 07 ]
  then
      mname="Jul"
  fi
 if [ $i -eq 08 ]
  then
      mname="Aug"
  fi
  if [ $i -eq 09 ]
  then
      mname="Sep"
  fi
  if [ $i -eq 10 ]
  then
      mname="Oct"
  fi
  if [ $i -eq 11 ]
  then
      mname="Nov"
  fi
  if [ $i -eq 12 ]
  then
      mname="Dec"
  fi
  Rscript year_bar_charts_pm25.r tha$i.pm25.csv "Thailand $mname PM2.5"
  Rscript year_bar_charts_pm25.r lao$i.pm25.csv "Laos $mname PM2.5"
  Rscript year_bar_charts_pm25.r khm$i.pm25.csv "Cambodia $mname PM2.5"
  Rscript year_bar_charts_pm25.r mmr$i.pm25.csv "Myanmar $mname PM2.5"
  Rscript year_bar_charts_pm25.r vnm$i.pm25.csv "Vietnam $mname PM2.5"
  Rscript year_bar_charts_pm25.r sea$i.pm25.csv "Upper_SEA $mname PM2.5"

  Rscript year_bar_charts_frp.r tha$i.frp.csv "Thailand $mname FRP"
  Rscript year_bar_charts_frp.r lao$i.frp.csv "Laos $mname FRP"
  Rscript year_bar_charts_frp.r khm$i.frp.csv "Cambodia $mname FRP"
  Rscript year_bar_charts_frp.r mmr$i.frp.csv "Myanmar $mname FRP"
  Rscript year_bar_charts_frp.r vnm$i.frp.csv "Vietnam $mname FRP"
  Rscript year_bar_charts_frp.r sea$i.frp.csv "Upper_SEA $mname FRP"

  Rscript year_bar_charts_co2.r tha$i.co2.csv "Thailand $mname CO2"
  Rscript year_bar_charts_co2.r lao$i.co2.csv "Laos $mname CO2"
  Rscript year_bar_charts_co2.r khm$i.co2.csv "Cambodia $mname CO2"
  Rscript year_bar_charts_co2.r mmr$i.co2.csv "Myanmar $mname CO2"
  Rscript year_bar_charts_co2.r vnm$i.co2.csv "Vietnam $mname CO2"
  Rscript year_bar_charts_co2.r sea$i.co2.csv "Upper_SEA $mname CO2"

done
