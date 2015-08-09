source('./common.R')

# Read the data used for plotting
plotData <- readData()

# Open PNG device
png(file = "plot2.png", height = 480, width = 480)

# Set transparent background color
par(bg = NA)

# Create the plot
with(plotData,
     plot(Global_active_power ~ DateTime,
          type = "l",
          xlab = "",
          ylab = "Global Active Power (kilowatts)")
)

#Shut down PNG device
dev.off()
