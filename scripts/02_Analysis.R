library(DT)

#looking at murders per year
ytownmurders %>% 
  group_by(year) %>% 
  summarize(total=n()) %>% 
  datatable()

#looking at murders per month
ytownmurders %>% 
  group_by(month) %>% 
  summarize(total=n()) %>% 
  datatable()

#looking at victims by race
ytownmurders %>% 
  group_by(v_race) %>% 
  summarize(total=n()) %>% 
  mutate(percent=round(total/sum(total)*100, 2)) %>% 
  datatable()

#looking at victims by gender
ytownmurders %>% 
  group_by(v_gender) %>% 
  summarize(total=n()) %>% 
  mutate(percent=round(total/sum(total)*100, 2)) %>% 
  datatable()

#looking at solve rates per year
ytownmurders %>%
  group_by(year(ytownmurders$date), solved_label) %>% 
  summarize(total=n()) %>% 
  mutate(percent=round(total/sum(total)*100, 2)) %>% 
  filter(solved_label=="Solved") %>% 
  datatable()
