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
  filter(fips == "24510") %>%
  group_by(type, year) %>%
  summarise(total = sum(Emissions))

g <- ggplot(em, aes(x = year, y = total))
g + facet_wrap(~ type, nrow = 2, ncol = 2) + 
  geom_point() + geom_smooth(method = "lm") +
  labs(title = "Total PM2.5 emission in the Baltimore City, Maryland") +
  labs(x = "Year", y = "Emission in tons")
ggsave("plot3.png")

    
