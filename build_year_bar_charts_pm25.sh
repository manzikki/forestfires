echo "Year,Value" > jan.pm25.csv
grep "\-01" all.txt | grep PM | sed 's/^.....//' | sed 's/-/,/' | sed 's/01 .*day: //' | sed 's/ .*//' >> jan.pm25.csv
echo "Year,Value" > feb.pm25.csv
grep "\-02" all.txt | grep PM | sed 's/^.....//' | sed 's/-/,/' | sed 's/02 .*day: //' | sed 's/ .*//' >> feb.pm25.csv
echo "Year,Value" > mar.pm25.csv
grep "\-03" all.txt | grep PM | sed 's/^.....//' | sed 's/-/,/' | sed 's/03 .*day: //' | sed 's/ .*//' >> mar.pm25.csv
echo "Year,Value" > apr.pm25.csv
grep "\-04" all.txt | grep PM | sed 's/^.....//' | sed 's/-/,/' | sed 's/04 .*day: //' | sed 's/ .*//' >> apr.pm25.csv
echo "Year,Value" > may.pm25.csv
grep "\-05" all.txt | grep PM | sed 's/^.....//' | sed 's/-/,/' | sed 's/05 .*day: //' | sed 's/ .*//' >> may.pm25.csv
echo "Year,Value" > jun.pm25.csv
grep "\-06" all.txt | grep PM | sed 's/^.....//' | sed 's/-/,/' | sed 's/06 .*day: //' | sed 's/ .*//' >> jun.pm25.csv
echo "Year,Value" > jul.pm25.csv
grep "\-07" all.txt | grep PM | sed 's/^.....//' | sed 's/-/,/' | sed 's/07 .*day: //' | sed 's/ .*//' >> jul.pm25.csv
echo "Year,Value" > aug.pm25.csv
grep "\-08" all.txt | grep PM | sed 's/^.....//' | sed 's/-/,/' | sed 's/08 .*day: //' | sed 's/ .*//' >> aug.pm25.csv
echo "Year,Value" > sep.pm25.csv
grep "\-09" all.txt | grep PM | sed 's/^.....//' | sed 's/-/,/' | sed 's/09 .*day: //' | sed 's/ .*//' >> sep.pm25.csv
echo "Year,Value" > oct.pm25.csv
grep "\-10" all.txt | grep PM | sed 's/^.....//' | sed 's/-/,/' | sed 's/10 .*day: //' | sed 's/ .*//' >> oct.pm25.csv
echo "Year,Value" > nov.pm25.csv
grep "\-11" all.txt | grep PM | sed 's/^.....//' | sed 's/-/,/' | sed 's/11 .*day: //' | sed 's/ .*//' >> nov.pm25.csv
echo "Year,Value" > dec.pm25.csv
grep "\-12" all.txt | grep PM | sed 's/^.....//' | sed 's/-/,/' | sed 's/12 .*day: //' | sed 's/ .*//' >> dec.pm25.csv


Rscript year_bar_charts_pm25.r jan.pm25.csv January
Rscript year_bar_charts_pm25.r feb.pm25.csv February
Rscript year_bar_charts_pm25.r mar.pm25.csv March
Rscript year_bar_charts_pm25.r apr.pm25.csv April
Rscript year_bar_charts_pm25.r may.pm25.csv May
Rscript year_bar_charts_pm25.r jun.pm25.csv June
Rscript year_bar_charts_pm25.r jul.pm25.csv July
Rscript year_bar_charts_pm25.r aug.pm25.csv August
Rscript year_bar_charts_pm25.r sep.pm25.csv September
Rscript year_bar_charts_pm25.r oct.pm25.csv October
Rscript year_bar_charts_pm25.r nov.pm25.csv November
Rscript year_bar_charts_pm25.r dec.pm25.csv December

