echo "Year, Value" > tha.csv
cat allc.txt | grep THA | grep PM2.5 | grep '\-01' | sed 's/\[1\] "//' | sed 's/-.*day:/,/' | sed 's/ max.*//' >> tha.csv
echo "Year, Value" > lao.csv
cat allc.txt | grep LAO | grep PM2.5 | grep '\-01' | sed 's/\[1\] "//' | sed 's/-.*day:/,/' | sed 's/ max.*//' >> lao.csv
echo "Year, Value" > khm.csv
cat allc.txt | grep KHM | grep PM2.5 | grep '\-01' | sed 's/\[1\] "//' | sed 's/-.*day:/,/' | sed 's/ max.*//' >> khm.csv
echo "Year, Value" > MMR.csv
cat allc.txt | grep MMR | grep PM2.5 | grep '\-01' | sed 's/\[1\] "//' | sed 's/-.*day:/,/' | sed 's/ max.*//' >> mmr.csv
echo "Year, Value" > vnm.csv
cat allc.txt | grep VNM | grep PM2.5 | grep '\-01' | sed 's/\[1\] "//' | sed 's/-.*day:/,/' | sed 's/ max.*//' >> vnm.csv
Rscript year_bar_charts.r tha.csv "Thailand PM2.5"
Rscript year_bar_charts.r lao.csv "Laos PM2.5"
Rscript year_bar_charts.r khm.csv "Cambodia PM2.5"
Rscript year_bar_charts.r mmr.csv "Myanmar PM2.5"
Rscript year_bar_charts.r vnm.csv "Vietnam PM2.5"
