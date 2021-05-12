#The source CSV file must look like:
#Year,Value
#2015,25
#get the parameter
args = commandArgs(trailingOnly=TRUE)
if (length(args) < 2) {
  stop("Parameters needed: 1 csv file of years and param values, 2 title", call.=FALSE)
}

mytitle = args[2]
mymon.data <- read.csv(file=args[1])
jpeg(paste0(args[1],".jpg"))
barplot(height = mymon.data$Value, names.arg = mymon.data$Year)
title(mytitle)
