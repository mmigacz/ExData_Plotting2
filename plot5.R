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
NEI_baltimore <- filter(NEI_merge, fips == "24510")

em <- NEI_baltimore[grepl(".*motor*", NEI_baltimore$Short.Name, ignore.case = TRUE),] %>%
  group_by(year) %>%
  summarise(total = sum(Emissions))

t1999 <- (em %>% filter(year == 1999) %>% select(total))$total
t2008 <- (em %>% filter(year == 2008) %>% select(total))$total
color <- ifelse(t2008 - t1999 > 0, "red", "green")

g <- ggplot(em, aes(x = year, y = total))
g + geom_point(aes(color = total)) + geom_line() +
  labs(title = "Total PM2.5 emission from motor vehicle sources in the Baltimore City, Maryland") +
  labs(x = "Year", y = "Emission in tons, log scale") +
  scale_y_log10() +
  geom_hline(data = (filter(em, year == 1999)), aes(yintercept=total))

ggsave("plot5.png")


