source('./common.R')

# Read the data used for plotting
plotData <- readData()

# Open PNG device
png(file = "plot1.png", height = 480, width = 480)

# Set transparent background color
par(bg = NA)

# Create the plot
with(plotData,
     hist(Global_active_power,
          col = "red",
          main = "Global Active Power",
          xlab = "Global Active Power (kilowatts)")
)

#Shut down PNG device
dev.off()