library(tidyverse)

FBImurders <- murders %>% 
  filter(State=="Ohio")

rm(murders)

FBImurders$Agency <- str_trim(FBImurders$Agency)

FBImurders <- FBImurders %>% 
  filter(Agency=="Youngstown") %>% 
  filter(Year>=2001)

library(DT)

FBImurders %>% 
  group_by(Year) %>% 
  summarize(total=n()) %>% 
  datatable()