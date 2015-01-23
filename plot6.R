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
NEI_bala <- filter(NEI_merge, fips == "24510" | fips == "06037")

em <- NEI_bala[grepl(".*motor*", NEI_bala$Short.Name, ignore.case = TRUE),] %>%
  group_by(fips, year) %>%
  summarise(total = sum(Emissions))

g <- ggplot(em, aes(x = year, y = total))
g + geom_point(aes(color = fips)) + 
  geom_line(aes(color = fips)) +
  scale_y_log10() +
  geom_hline(data = (filter(em, year == 1999)), aes(yintercept=total)) +
  labs(title = "Total PM2.5 emission from motor vehicle sources in the Baltimore City and in Los Angeles County") +
  labs(x = "Year", y = "Emission in tons, log scale")

ggsave("plot6.png", width=7, height=7, dpi=70)


