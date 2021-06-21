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

recenty=`ls *pm25.nc | tail -1 | sed 's/-.*//'`
recentm=`ls *pm25.nc | tail -1 | sed 's/^....-//' | sed 's/-.*//'`
#combine the recent month PM2.5 files into a month file
mkdir p
rm -f p/$recenty-$recentm.nc
cdo -b f64 mergetime $recenty-$recentm-??pm25*nc p/$recenty-$recentm.nc
#same with frp
mkdir f
rm -f f/$recenty-$recentm.nc
cdo -b f64 mergetime $recenty-$recentm-??frp*nc f/$recenty-$recentm.nc
#and co2
mkdir c
rm -f c/$recenty-$recentm.nc
cdo -b f64 mergetime $recenty-$recentm-??co2*nc c/$recenty-$recentm.nc

#copy the month graph builders and run them
cp month-barchart-frp.r gfas_0001_cfire_climatology_2003_2018.nc f
cp month-barchart-pm25.r gfas_0001_cfire_climatology_2003_2018.nc p
cp month-barchart-co2.r gfas_0001_cfire_climatology_2003_2018.nc c

curdir=`pwd`
cd f
Rscript month-barchart-frp.r $recenty-$recentm.nc  > $recenty-$recentm-SEA-frp.txt
cd $curdir

cd p
Rscript month-barchart-pm25.r $recenty-$recentm.nc > $recenty-$recentm-SEA-pm25.txt
cd $curdir

cd c
Rscript month-barchart-co2.r $recenty-$recentm.nc  > $recenty-$recentm-SEA-co2.txt
cd $curdir

#is today the first day of the month?
thisday=`date +%d`
if [ $thisday -eq 1 ]
then
    echo Running a script to create a barachart of the last 12 months
    cd p
    bash ../12-month-barchart-pm25.sh $recenty $recentm
    Rscript ../12-month-barchart-pm25.r twelve.csv "Fire related PM2.5, last 12 months"
    cd $curdir
fi

#finally: delete the old maps to avoid clutter
find -type f -name "*.jpg" -mtime 2 -exec rm {} \;

