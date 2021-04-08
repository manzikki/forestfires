cd "$(dirname "$0")"
bash -x get_latest.sh username password
#what is the most recent
recentf=`ls *frp.nc | tail -1`
recentp=`ls *pm25.nc | tail -1`
recentc=`ls *co2.nc | tail -1`

Rscript daily_frp_by_country.r $recentf THA
Rscript daily_frp_by_country.r $recentf LAO
Rscript daily_frp_by_country.r $recentf KHM
Rscript daily_frp_by_country.r $recentf MMR
Rscript daily_frp_by_country.r $recentf VNM

Rscript daily_pm25_by_country.r $recentp THA
Rscript daily_pm25_by_country.r $recentp LAO
Rscript daily_pm25_by_country.r $recentp KHM
Rscript daily_pm25_by_country.r $recentp MMR
Rscript daily_pm25_by_country.r $recentp VNM

Rscript daily_co2_by_country.r $recentc THA
Rscript daily_co2_by_country.r $recentc LAO
Rscript daily_co2_by_country.r $recentc KHM
Rscript daily_co2_by_country.r $recentc MMR
Rscript daily_co2_by_country.r $recentc VNM

Rscript daily_frp_sea.r $recentf
Rscript daily_pm25_sea.r $recentp
Rscript daily_co2_sea.r $recentc
