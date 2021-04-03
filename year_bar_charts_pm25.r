#get the parameter
args = commandArgs(trailingOnly=TRUE)
if (length(args) < 2) {
  stop("Parameters needed: 1 csv file of years and param values 2 month name", call.=FALSE)
}

month = args[2]
mon.data <- read.csv(file=args[1])

jpeg(paste0(args[1] , ".jpg"), width = 1442 , height = 1442 , res = 200)

barplot(height = mon.data$PM2.5, names.arg = mon.data$Year)
title(paste("Fire based PM 2.5 in ", month))
