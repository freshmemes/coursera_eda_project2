# skipping download/unzip steps (assuming already ran plot1.R which did this)
# please set working directory to this file's location

library(tidyverse)

# read in the data
df <- readRDS("summarySCC_PM25.rds")

# validate that the data looks the way we expect it to
head(df)

# filter to Baltimore, convert to tibble for funsies
df2 <- as.tibble(subset(df, fips == "24510"))

# summarize total emissions grouped by year and type
df3 <- df2 %>% 
  group_by(year, type) %>% 
  summarize(Emissions = sum(Emissions, na.rm = T))

# simple line plot
df3 %>% 
  ggplot(aes(year, Emissions, color = type)) +
  geom_line(size = 1, aes(linetype = type)) +
  geom_point(size = 2) +
  labs(title = "3 of 4 source types saw decreased emissions from 1999 to 2008",
       subtitle = "The exception was point sources, which ended 2008 with slightly higher emissions than in 1999",
       x = "Year",
       y = expression("PM"[2.5]*" Emissions (tons)"),
       caption = "Data from the National Emissions Inventory",
       linetype = "Type",
       color = "Type") +
  guides(color = guide_legend(override.aes = list(shape = NA))) + 
  scale_x_continuous(breaks = seq(1999, 2008, by = 3),
                     minor_breaks = seq(1999, 2008, by = 1))

# output as png
ggsave("plot3.png")