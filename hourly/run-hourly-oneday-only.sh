#this script creates daily graphs
cd "$(dirname "$0")"
bash -x get_latest.sh username password
#if there were no new files the exit code is 1 and we can stop
if [ $? -eq 1 ]
then
  exit 0
fi
rm -- --frp.nc
rm -- --pm25.nc
rm -- --co2.nc
#what is the most recent
recentf=`ls *frp.nc | tail -1`
recentp=`ls *pm25.nc | tail -1`
recentc=`ls *co2.nc | tail -1`

Rscript map_daily_frp_by_country.r $recentf THA
Rscript map_daily_frp_by_country.r $recentf LAO
Rscript map_daily_frp_by_country.r $recentf KHM
Rscript map_daily_frp_by_country.r $recentf MMR
Rscript map_daily_frp_by_country.r $recentf VNM

Rscript map_daily_pm25_by_country.r $recentp THA
Rscript map_daily_pm25_by_country.r $recentp LAO
Rscript map_daily_pm25_by_country.r $recentp KHM
Rscript map_daily_pm25_by_country.r $recentp MMR
Rscript map_daily_pm25_by_country.r $recentp VNM

Rscript map_daily_co2_by_country.r $recentc THA
Rscript map_daily_co2_by_country.r $recentc LAO
Rscript map_daily_co2_by_country.r $recentc KHM
Rscript map_daily_co2_by_country.r $recentc MMR
Rscript map_daily_co2_by_country.r $recentc VNM

Rscript map_daily_frp_sea.r $recentf
Rscript map_daily_pm25_sea.r $recentp
Rscript map_daily_co2_sea.r $recentc

