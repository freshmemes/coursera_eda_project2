# This is going to be very similar to plot1, with the data filtered to Baltimore.
# skipping download/unzip steps (assuming already ran plot1.R which did this)
# please set working directory to this file's location

# read in the data
df <- readRDS("summarySCC_PM25.rds")

# validate that the data looks the way we expect it to
head(df)

# filter to Baltimore
df2 <- subset(df, fips == "24510")

# sum emissions grouped by year
dfy <- aggregate(Emissions ~ year, data = df2, FUN = sum)

# initialize png device, 4:3 aspect ratio
png(filename = "plot2.png", width = 1200, height = 800)

# set margins
par(mar = c(6, 6, 4, 2))

# simple barplot with labels
barplot(dfy$Emissions/(10^3), names.arg = dfy$year, xlab = "Year", ylab = "PM.25 Emissions (thousand tons)", ylim = c(0, 4),
        main = "Total PM.25 emissions have decreased over time in Baltimore, MD")

# add subtitle
mtext("Although the decrease has been non-monotonic, emissions are lower in 2008 than in 1999")

# end device
dev.off()