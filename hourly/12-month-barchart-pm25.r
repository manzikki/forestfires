#The source CSV file must look like:
#Month,AVG
#2015-12,25
#2016-01,44
#get the parameter
args = commandArgs(trailingOnly=TRUE)
if (length(args) < 2) {
  stop("Parameters needed: 1 csv file of years and param values, 2 title", call.=FALSE)
}

mytitle = args[2]
mymon.data <- read.csv(file=args[1])
jpeg("SEA-pm25-12m.jpg")
ylabt <- expression(paste("Tonnes per day per m"^"2"))
xx = barplot(height = mymon.data$AVG, width = 0.85, names.arg = mymon.data$Month, ylab=ylabt)
title(mytitle)
text(x=xx, y=50, label = mymon.data$Value, cex=1, pos=3) 
