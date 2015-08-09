source('./common.R')

# Read the data used for plotting
plotData <- readData()

# Open PNG device
png(file = "plot3.png", height = 480, width = 480)

# Set transparent background color
par(bg = NA)

# Create the plot
with(plotData, {
  plot(Sub_metering_1 ~ DateTime, type = "l", xlab = "", ylab = "Energy sub metering")
  lines(Sub_metering_2 ~ DateTime, col = "red")
  lines(Sub_metering_3 ~ DateTime, col = "blue")
  legend("topright",
         col=c("black", "red", "blue"),
         lty = 1,
         legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
})

#Shut down PNG device
dev.off()
