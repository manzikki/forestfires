user=$1
pw=$2
lastdate=`curl ftp://dissemination.ecmwf.int -Q "CWD DATA/CAMS_GFAS" -u$user:$pw | tail -1 | sed 's/.* //'`
if [ -z $lastdate ]
then
    echo Curl failed
    exit 1
fi
curl ftp://dissemination.ecmwf.int -Q "CWD DATA/CAMS_GFAS/$lastdate" -u$user:$pw > latest.files
frpf=`grep frpfire.nc latest.files | sed 's/.* //'`
pm25f=`grep pm2p5fire.nc latest.files | sed 's/.* //'`
co2f=`grep co2fire.nc latest.files | sed 's/.* //'`
year=`grep frpfire.nc latest.files | sed 's/.*z_cams_c_ecmf_//' | cut -c 1-4`
month=`grep frpfire.nc latest.files | sed 's/.*z_cams_c_ecmf_....//' | cut -c 1-2`
day=`grep frpfire.nc latest.files | sed 's/.*z_cams_c_ecmf_......//' | cut -c 1-2`
frpofile=$year-$month-${day}frp.nc
pm25ofile=$year-$month-${day}pm25.nc
co2ofile=$year-$month-${day}co2.nc
#if the file is here, dont download
if [ -f $frpofile ]
then
    echo file $frpofile exists
    exit 1
else
    curl ftp://dissemination.ecmwf.int/DATA/CAMS_GFAS/$lastdate/$frpf -u$user:$pw --output $frpofile
    curl ftp://dissemination.ecmwf.int/DATA/CAMS_GFAS/$lastdate/$pm25f -u$user:$pw --output $pm25ofile
    curl ftp://dissemination.ecmwf.int/DATA/CAMS_GFAS/$lastdate/$co2f -u$user:$pw --output $co2ofile
fi
