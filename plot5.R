# This is going to be very similar to plot4, with the data filtered to Baltimore.
# skipping download/unzip steps (assuming already ran plot1.R which did this)
# please set working directory to this file's location

library(tidyverse)

# read in the data
df <- readRDS("summarySCC_PM25.rds")
scc <- readRDS("Source_Classification_Code.rds")

# validate that the data looks the way we expect it to
head(df)
head(scc)

# merge df and scc, convert to tibble
df2 <- as.tibble(merge(df, scc, by = "SCC"))

# filter to motor vehicles in Baltimore
df3 <- df2 %>% 
  filter(grepl("vehicle", Short.Name, ignore.case = T)) %>% 
  filter(fips == "24510")

# summarize by year
df4 <- df3 %>% 
  group_by(year) %>% 
  summarize(Emissions = sum(Emissions, na.rm = T))

# simple bar plot
df4 %>% 
  ggplot(aes(year, Emissions)) +
  geom_bar(stat = "identity", fill = "royalblue", alpha = 3/4) +
  labs(title = expression("Total PM"[2.5]*" Emissions from Vehicles in Baltimore, 1999-2008"),
       subtitle = "Emission levels were almost halved from 1999 to 2002 and continued to steadily decrease. In 2008, emissions were about one-third of the\n1999 amount.",
       x = "Year",
       y = expression("PM"[2.5]*" Emissions (tons)"),
       caption = "Data from the National Emissions Inventory") +
  scale_x_continuous(breaks = seq(1999, 2008, by = 3))

ggsave("plot5.png")