deps = c("ggplot2","dplyr");
for (dep in deps){
  if (dep %in% installed.packages()[,"Package"] == FALSE){
    install.packages(dep);
  }
}

library(ggplot2)
library(dplyr)

# Download and unzip data if doesn't exist
zipFile <- "pm.zip"
if(!file.exists(zipFile)){
  download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip", 
                destfile = zipFile, method = "curl", mode="wb")
  unzip(zipFile, exdir=".")  
}
rm(zipFile)

# Load data files, if dont exist
if(!exists("NEI")) {
  NEI <- readRDS("summarySCC_PM25.rds")  
}

if(!exists("SCC")) {
  SCC <- readRDS("Source_Classification_Code.rds")
}

em <- tbl_df(NEI) %>%
  filter(year %in% c(1999, 2002, 2005, 2008)) %>%
  group_by(year) %>%
  summarise(total = sum(Emissions) / 1000)

png("plot1.png", width = 480, height = 480)
plot(em, ylab="Emission in 1000 tons", xlab="Year", main="Total PM2.5 emission in the USA")
lines(em)
dev.off()
