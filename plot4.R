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

if(!exists("NEI_merge")) {
  NEI_merge <- tbl_df(merge(NEI, SCC))
}
NEI_coal <- NEI_merge[grepl(".*coal.*", NEI_merge$Short.Name, ignore.case = TRUE),]

em <- tbl_df(NEI_coal) %>%
  group_by(year) %>%
  summarise(total = sum(Emissions) / 1000)

g <- ggplot(em, aes(x = year, y = total))
g + geom_point() + geom_smooth(method = "lm") +
  labs(title = "Total PM2.5 emission in the USA from coal combustion-related sources") +
  labs(x = "Year", y = "Emission in 1000 tons")

ggsave("plot4.png", width=7, height=7, dpi=70)


