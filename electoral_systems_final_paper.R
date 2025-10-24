install.packages("rvest")
install.packages("devtools")
library(rvest)
library(tidyverse)
library(devtools)
devtools::install_github("vdeminstitute/vdemdata")
library(vdemdata)
vdem<-vdem
vparty<-vparty

pr2maj<-vdem%>%
  arrange(country_name, year)%>%
  group_by(country_name)%>%
  filter(v2elparlel == 1 & 
           lead (v2elparlel, default = NA) == 0) 

pr2maj

# t‑rows (where the jump starts)
start_rows <- vdem %>% 
  arrange(country_name, year) %>%
  group_by(country_name) %>%
  filter(v2elparlel == 1 & lead(v2elparlel, default = NA) == 0) %>%
  mutate(ElectoralSystem = "PR")

# t+1‑rows (where the jump lands)
end_rows   <- vdem %>% 
  arrange(country_name, year) %>%
  group_by(country_name) %>%
  filter(v2elparlel == 0 & lag(v2elparlel, default = NA) == 1) %>%
  mutate(ElectoralSystem = "Majoritarian")

# Combine them

pr2maj <- bind_rows(start_rows, end_rows) %>% 
  arrange(country_name, year, ElectoralSystem)

pr2maj%>%select(country_name, year, ElectoralSystem)

#This works, but now I need to add variety. Maybe PR to Mixed (2) or other (3)? 
#Also, what is included in "Other"? How do I know which one?
#Should filter for democracies only,
#and consider only elite biased democracies as well. 
