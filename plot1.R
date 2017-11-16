# please set working directory to this file's location

# download and unzip data
download.file(url = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip", destfile = "rawdata.zip")
unzip("rawdata.zip")

# delete the zip to clean up space
file.remove("rawdata.zip")

# read in the data
df <- readRDS("summarySCC_PM25.rds")

# validate that the data looks the way we expect it to
head(df)

# sum emissions grouped by year
dfy <- aggregate(Emissions ~ year, data = df, FUN = sum)

# initialize png device, 4:3 aspect ratio
png(filename = "plot1.png", width = 1200, height = 800)

# set margins
par(mar = c(6, 6, 4, 2))

# simple barplot with labels
barplot(dfy$Emissions/(10^6), names.arg = dfy$year, xlab = "Year", ylab = "PM.25 Emissions (million tons)", ylim = c(0, 8),
        main = "Total PM.25 emissions have decreased each recorded year")

# specify y-axis ticks
axis(side = 2, at = seq(1, 8, by = 1))

# add subtitle
mtext("Emissions in 2008 were less than half of 1999's amount")

# end device
dev.off()