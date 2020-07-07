#can be called by cron daily
cd "$(dirname "$0")"
rm -f 202?-??-??.nc

python day.py

Rscript day.r 202?-??-??.nc

j=1
for i in `ls -r 202?-??-??pm25.jpg | head -7`
do
    cp $i $j.pm25.jpg
    ((j++))
done

j=1
for i in `ls -r 202?-??-??frp.jpg | head -7`
do
    cp $i $j.frp.jpg
    ((j++))
done

j=1
for i in `ls -r 202?-??-??oc.jpg | head -7`
do
    cp $i $j.oc.jpg
    ((j++))
done
