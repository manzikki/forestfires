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
ylabt <- expression(paste("CO2 Tonnes per day per m"^"2"))
xx = barplot(ylim=c(0, 100000), height = mymon.data$Value, width = 0.85, names.arg = mymon.data$Year, ylab=ylabt)
title(mytitle)
text(x=xx, y=50, label = mymon.data$Value, cex=1, pos=3) 
