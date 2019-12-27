library(leaflet)
library (dplyr)
library(ggplot2)
library(plotly)
library(ggthemes)
library(gplots)
library(lubridate)
library(reshape2)
library(DT)
library(tidyverse)


#Read data
Flight_df=read.csv("new_data.csv")

#order level for weekday
Flight_df$Weekday=ordered (Flight_df$Weekday, levels=c('Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday'))

#order Month Column
MonthOrdered=sort(unique(Flight_df$Month))
MonthOrdered

#Prepared Data for delay reason analysis
#gather delay_min by reason
gathered_delay = Flight_df %>% 
  gather(key = 'Reason',value = 'delay_min',CARRIER_DELAY:LATE_AIRCRAFT_DELAY)

head(gathered_delay)

gathered_delay$Month=as.factor(gathered_delay$Month)

gathered_delay=gathered_delay %>% mutate(., Delay_Hours=delay_min/60)

#prep data for boxplot
Box_df_month=Flight_df %>% 
  mutate(., Delay_Hours=round(Sum_Delay_Min/60, digits = 2)) %>% 
  mutate(., Month=as.factor(Month)) %>% 
  mutate(., Hour=as.factor(Hour))
  
  
Box_df_week=Flight_df %>% 
  mutate(., Delay_Hours=round(Sum_Delay_Min/60, digits = 2)) %>% 
  mutate(., Month=as.factor(Month)) %>% 
  mutate(., Hour=as.factor(Hour))

Box_df_Hour=Flight_df %>% 
  mutate(., Delay_Hours=round(Sum_Delay_Min/60, digits = 2)) %>% 
  mutate(., Month=as.factor(Month)) %>% 
  mutate(., Hour=as.factor(Hour))