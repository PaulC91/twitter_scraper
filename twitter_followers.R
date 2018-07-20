library(rtweet)
library(tidyverse)
library(readxl) # for read_excel
library(openxlsx) #for write.xlsx
library(lubridate)

medialist1 <- read_excel("media list.xlsx") %>% 
  .$Handle

otherdetail <- read_excel("media list.xlsx")

#collect follower accounts
baselist <- lookup_users(medialist1) %>% 
  select(name, screen_name, followers_count) %>% 
  mutate(Handle = sapply(screen_name, tolower)) %>%
  mutate(Handle = as.character(Handle)) %>% 
  left_join(otherdetail, by = "Handle") %>% 
  select(-name, -Handle) %>% 
  mutate(Date = today()) %>% 
  filter(followers_count > 1000)

runninglist <- read_excel("twitterfollowcount.xlsx") %>%
  mutate(Date = as_date(Date)) %>% 
  bind_rows(baselist) %>%
  write.xlsx("twitterfollowcount.xlsx")