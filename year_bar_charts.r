#get the parameter
args = commandArgs(trailingOnly=TRUE)
if (length(args) < 2) {
  stop("Parameters needed: 1 csv file of years and param values 2 month name", call.=FALSE)
}

month = args[2]
jan.data <- read.csv(file=args[1])

barplot(height = jan.data$Burnt_Carbon, names.arg = jan.data$Year)
title(paste("Burnt Carbon in ", month))
