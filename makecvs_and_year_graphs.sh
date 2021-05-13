#iterate over months
for i in 01 02 03 04 05 06 07 08 09 10 11 12
do
  echo "Year, Value" > tha$i.csv
  cat allc.txt | grep THA | grep PM2.5 | grep "\-$i" | sed 's/\[1\] "//' | sed 's/-.*day:/,/' | sed 's/ max.*//' >> tha$i.csv
  echo "Year, Value" > lao$i.csv
  cat allc.txt | grep LAO | grep PM2.5 | grep "\-$i" | sed 's/\[1\] "//' | sed 's/-.*day:/,/' | sed 's/ max.*//' >> lao$i.csv
  echo "Year, Value" > khm$i.csv
  cat allc.txt | grep KHM | grep PM2.5 | grep "\-$i" | sed 's/\[1\] "//' | sed 's/-.*day:/,/' | sed 's/ max.*//' >> khm$i.csv
  echo "Year, Value" > mmr$i.csv
  cat allc.txt | grep MMR | grep PM2.5 | grep "\-$i" | sed 's/\[1\] "//' | sed 's/-.*day:/,/' | sed 's/ max.*//' >> mmr$i.csv
  echo "Year, Value" > vnm$i.csv
  cat allc.txt | grep VNM | grep PM2.5 | grep "\-$i" | sed 's/\[1\] "//' | sed 's/-.*day:/,/' | sed 's/ max.*//' >> vnm$i.csv
  echo "Year, Value" > sea$i.csv
  cat allc.txt | grep SEA | grep PM2.5 | grep "\-$i" | sed 's/\[1\] "//' | sed 's/-.*day:/,/' | sed 's/ max.*//' >> sea$i.csv
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
  Rscript year_bar_charts.r tha$i.csv "Thailand $mname AVG PM2.5"
  Rscript year_bar_charts.r lao$i.csv "Laos $mname AVG PM2.5"
  Rscript year_bar_charts.r khm$i.csv "Cambodia $mname AVG PM2.5"
  Rscript year_bar_charts.r mmr$i.csv "Myanmar $mname AVG PM2.5"
  Rscript year_bar_charts.r vnm$i.csv "Vietnam $mname AVG PM2.5"
  Rscript year_bar_charts.r sea$i.csv "Upper_SEA $mname AVG PM2.5"
done
