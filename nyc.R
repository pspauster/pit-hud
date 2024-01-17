library(tidyverse)
library(janitor)
library(readxlsb)


years <- as.character(2014:2023)
  
nyc <- map_dfr(years, ~read_xlsb("2007-2023-PIT-Counts-by-CoC.xlsb", sheet = .x, col_types = "string")%>%
                 clean_names() %>% 
                 filter(co_c_number == "NY-600")%>%
                 mutate(year = .x)
               )

nyc_clean <- nyc %>% 
  select(-co_c_category) %>% 
  mutate_at(vars(-(1:3)), ~as.numeric(str_replace_all(.x, ",", ""))) %>% 
  pivot_longer(starts_with(c("overall_", "sheltered", "unsheltered")),
               names_to = c("type"),
               values_to = "value")


nyc_summary <- read_csv("individuals_nyc_summary.csv")



