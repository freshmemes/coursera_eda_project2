# This is going to be very similar to plot5, with LA also included
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

# filter to motor vehicles in LA
df3_la <- df2 %>% 
  filter(grepl("vehicle", Short.Name, ignore.case = T)) %>% 
  filter(fips == "06037")

# summarize by year for Baltimore
df4 <- df3 %>% 
  group_by(year) %>% 
  summarize(Emissions = sum(Emissions, na.rm = T))

# summarize by year for LA
df4_la <- df3_la %>% 
  group_by(year) %>% 
  summarize(Emissions = sum(Emissions, na.rm = T))

# join the summaries for Baltimore and LA by year
df5 <- as.tibble(merge(df4, df4_la, by = "year"))

# make tidy
df6 <- df5 %>% 
  rename(Baltimore = Emissions.x, LA = Emissions.y) %>% 
  gather("City", "Emissions", 2:3)

# simple side by side bar plots
df6 %>% 
  ggplot(aes(year, Emissions)) +
  geom_bar(stat = "identity", aes(fill = City), alpha = 3/4) +
  facet_grid(. ~ City) +
  labs(title = expression("Total PM"[2.5]*" Emissions from Vehicles in Baltimore and LA, 1999-2008"),
       subtitle = "Emission levels decreased notably in both cities. LA's decrease as an absolute value is larger. However, Baltimore's decrease was\nlarger as a percentage",
       x = "Year",
       y = expression("PM"[2.5]*" Emissions (tons)"),
       caption = "Data from the National Emissions Inventory") +
  scale_x_continuous(breaks = seq(1999, 2008, by = 3))

ggsave("plot6.png")