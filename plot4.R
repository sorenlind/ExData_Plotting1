source('./common.R')

# Read the data used for plotting
plotData <- readData()

# Open PNG device
png(file = "plot4.png", height = 480, width = 480)

# Make space for 4 plots in one and set transparent background color
par(mfrow = c(2, 2), bg = NA)

# Create the plot
with(plotData, {
  # Top left plot
  plot(Global_active_power ~ DateTime, type = "l", xlab = "", ylab = "Global Active Power")
  
  # Top right plot
  plot(Voltage ~ DateTime, type = "l", xlab = "datetime", ylab = "Voltage")
  
  # Bottom left plot
  plot(Sub_metering_1 ~ DateTime, type = "l", xlab = "", ylab = "Energy sub metering")
  lines(Sub_metering_2 ~ DateTime, col = "red")
  lines(Sub_metering_3 ~ DateTime, col = "blue")
  legend("topright",
         col=c("black", "red", "blue"),
         lty = 1,
         legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
  
  # Bottom right plot  
  plot(Global_reactive_power~DateTime, type = "l", xlab = "datetime", ylab = "Global_reactive_power")
})

#Shut down PNG device
dev.off()
