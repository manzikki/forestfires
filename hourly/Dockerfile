#build: docker build -t forestfires .
#run: mkdir results; docker run -v results:/home/results forestfires 
FROM rocker/r-ver:3.6.0
FROM ubuntu:20.04
ENV TZ=Asia/Bangkok
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apt-get update
RUN apt-get install -y curl
RUN apt-get install -y r-base
RUN apt-get install -y r-cran-ncdf4 libnetcdf-dev libgdal-dev libproj-dev cdo

RUN mkdir /home/analysis
RUN mkdir /home/results

RUN R -e "options(repos = \
  list(CRAN = 'http://mran.revolutionanalytics.com/snapshot/2021-04-11/')); \
  install.packages(c('ncdf4','raster','rgdal','ggplot2','stringr'))"

COPY get_latest.sh /home/analysis/get_latest.sh
COPY run-hourly.sh  /home/analysis/run-hourly-oneday-only.sh
COPY *.r /home/analysis/
COPY gfas_0001_cfire_climatology_2003_2018.nc.gz /home/analysis/

CMD cd /home/analysis \
  && gunzip gfas_0001_cfire_climatology_2003_2018.nc.gz \
  && bash run-hourly-oneday-only.sh \
  && cp /home/analysis/*.nc  /home/analysis/*.jpg /home/results/ \
  && ls /home/results/



