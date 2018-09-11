library(tidyverse)

#importing raw data
ytownmurders <- read_csv("output_data/2001-2017homicides.csv")

#renaming columns
ytownmurders <- select(ytownmurders, hour=HOUR, date=INC_DATE, address=INC_ADDRESS, 
                  v_gender=V_GENDER, v_race=V_RACE, v_age=V_AGE, 
                  solved_value="Arrest made?")

#fixing dates
library(lubridate)

ytownmurders$date <- mdy(ytownmurders$date)


#reordering columns and removing 2000 homicides
ytownmurders <- ytownmurders %>% 
  filter(year>=2001) %>% 
  select(year, month, date, hour, address, v_gender, 
                  v_race, v_age, solved_value) %>% 
  mutate(v_race=case_when(
    v_race=="W" ~ "White",
    v_race=="B" ~ "Black",
    v_race=="H" ~ "Hispanic")) %>% 
  mutate(v_gender=case_when(
    v_gender=="M" ~ "Male",
    v_gender=="F" ~ "Female")) %>% 
  mutate(solved_label=case_when(
    solved_value=="N" ~ "Unsolved",
    solved_value=="Y" ~ "Solved"))


