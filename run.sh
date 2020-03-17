#can be called by cron daily
cd "$(dirname "$0")"
rm -f 202*frp.nc
rm -f 202*pm25.nc

python frp-day.py
python pm25-day.py

Rscript work.r 202*frp.nc  202*pm25.nc

