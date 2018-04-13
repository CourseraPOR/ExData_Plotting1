##check if file has already been downloaded to working directory
##if not already downloaded, do so now
if (!file.exists("household_power_consumption.txt")) {
  
  url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
  
  download.file(url, destfile = "full.zip")
  dateDownloaded <- date()
  unzip("full.zip")
  
  ##delete the zipped file
  unlink("full.zip")
}


##check to see if feb07 data have already been read into R
##if not, read data for specified dates only
if (!exists("feb07")) {
  install.packages("sqldf")
  library(sqldf)
  feb07 <- read.csv.sql("household_power_consumption.txt", sql= 'select * from file where Date = "1/2/2007" OR Date = "2/2/2007"', sep=";")
  
  ##create a new column with DateTime variable
  library(lubridate)
  feb07$Date <- dmy(feb07$Date)
  feb07$DateTime <- with(feb07, Date + hms(Time))
}

##launch graphics device to create png file
png(filename = "plot4.png", height=400, width = 400)

##create plot
par(mfrow=c(2,2), mar=c(4,4,4,2), lwd=0.5)
with(feb07, plot(DateTime, Global_active_power, ylab = "Global Active Power", xlab="", type="l"))
with(feb07, plot(DateTime, Voltage, ylab = "Voltage", xlab="datetime", type="l"))
with(feb07, plot(DateTime, Sub_metering_1, ylab = "Energy sub metering", xlab="", type="l"))
with(feb07, lines(DateTime, Sub_metering_2, col="red"))
with(feb07, lines(DateTime, Sub_metering_3, col="blue"))
legend("topright", lty=1 , bty="n", cex=0.5, col=c("black", "blue", "red"), legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
with(feb07, plot(DateTime, Global_reactive_power, ylab = "Global_reactive_power", xlab="datetime", type="l"))

##close graphics device
dev.off()