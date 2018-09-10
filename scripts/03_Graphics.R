library(tidyverse)

#graphing the solve rates
ggplot(data=joemurders, aes(x=year, fill=solved_label)) +
  geom_bar()
