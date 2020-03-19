#can be called by cron daily
cd "$(dirname "$0")"
rm -f 202?-??-??.nc

python day.py

Rscript day.r 202?-??-??.nc

