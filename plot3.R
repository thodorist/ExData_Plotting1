##############################################
#### First, we will make a rough estimate ####
#### of the physical memory that is going ####
#### to be used                           ####
#### 2,075,259 rows and 9 columns means   ####
##############################################
20075259*9*8# bytes
20075259*9*8/2^20#MB
20075259*9*8/2^20/1024#GB
cat("Ram needed:", round(20075259*9*8/2^20/1024, 2), "GB")

#########################################################################
#### Download the zip file and save it in the working directory      ####
#### in a file called "data" where the downloaded zip file is called ####
#### electric.consumption.                                           ####
#########################################################################
if(!file.exists("./data")){dir.create("./data")}
fileURL<-"https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"

######################################################################
#### Create the extension of the file I will download the data to ####
#### and save it in a variable called "destination".              ####
######################################################################
destination<-paste0("./data", "/electric.consumption.zip")
download.file(fileURL, destfile = destination)

#############################################################
#### Unzip the 'zip' file inside the folder named "data" ####
#### which is located in the working directory.          ####
#############################################################
unzip(destination, exdir = "./data")

################################################
#### Load the "household_power_consumption" ####
#### dataset                                ####
################################################
path<-"./data/household_power_consumption.txt"
DATA<-read.table(path, sep = ";", header = TRUE, na.strings = "?")

#######################################
#### Transform DATE variables from ####
#### "factor" to "date" classes    ####
#######################################
DATA$Date<-as.Date(DATA[, 1], "%d/%m/%Y")

###############################################
#### Get the dataset for ONLY the obs from ####
#### dates 2007-02-01 AND 2007-02-02       ####
###############################################
subsetDATA<-subset(DATA, Date == "2007-02-01" | Date=="2007-02-02")

##########################################
#### Extremely!!!! important to use   ####
#### "strptime" command cause it will ####
#### produce the label of the x-axis  ####
#### the way it was asked to          ####
##########################################
dates_times<-strptime(paste(subsetDATA$Date, subsetDATA$Time),"%Y-%m-%d %H:%M:%S" )

########################################
#### Replace the "Time" column with ####
#### "dates_times" variable         ####
########################################
subsetDATA$Time<-dates_times

###############################################
#### Columns 7,8,9 of the 'subsetDATA'     ####
####  data frame need to be used. The plot ####
#### will be saved in a png file           ####
#### named "plot3"                         ####
###############################################
png("plot3.png", width=480, height=480)
plot(dates_times, subsetDATA[, 7], type = 'l', xlab = "",
     ylab = "Energy sub metering")
lines(dates_times, subsetDATA[, 8], col = "red")
lines(dates_times, subsetDATA[,9], col = "blue")
legend("topright", legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), 
       col = c("black", "red", "blue"), lty = c(1, 1, 1))
dev.off()