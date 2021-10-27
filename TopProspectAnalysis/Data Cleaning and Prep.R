library(dplyr)
library(scales)



Current_MLB = read.csv("Current_MLB.csv")
Current_MiLB = read.csv("Current_MiLB.csv")

MiLB_for_Current_MLB = subset(Current_MLB, Level == 'R' | Level == 'A'|Level == 'A+'|Level == 'AA'|Level == 'AAA')
MLB_for_Current_MLB = subset(Current_MLB, Level == 'MLB')

## --- Create weighted mean columns for Current MLB players MiLB Stats ---------

MiLB_for_Current_MLB = MiLB_for_Current_MLB %>%
  mutate(
    ID = as.character(ID),
    Weight = as.numeric(ifelse(Level == 'R', 1,
             ifelse(Level == 'A', 1.25, 
             ifelse(Level == 'A+', 1.5, 
             ifelse(Level == 'AA', 1.75,
             ifelse(Level == 'AAA', 2, Level)))))),
    BB_Percentage = Weight*as.numeric(gsub('\\%', '', BB_Percentage))/100,
    K_Percentage = Weight*as.numeric(gsub('\\%', '', K_Percentage))/100,
    BB_to_K = Weight*BB_to_K,
    AVG = Weight*AVG,
    OBP = Weight*OBP,
    SLG = Weight*SLG,
    OPS = Weight*OPS,
    Spd = Weight*Spd,
    BABIP = Weight*BABIP,
    wSB = Weight*wSB,
    wRC = Weight*wRC,
    wRAA = Weight*wRAA,
    wOBA = Weight*wOBA,
    wRCplus = Weight*wRCplus) %>%
  group_by(ID, Name) %>%
  summarise_at(c('BB_Percentage', 'K_Percentage', 'BB_to_K', 'AVG', 'OBP', 'SLG',
                 'OPS', 'ISO', 'Spd', 'BABIP',
                 'wSB', 'wRC', 'wRAA', 'wOBA', 'wRCplus'), mean) %>%
  mutate(
    BB_Percentage_MiLB = round(BB_Percentage, 3),
    K_Percentage_MiLB = round(K_Percentage, 3),
    BB_to_K_MiLB = round(BB_to_K, 2),
    AVG_MiLB = round(AVG, 3),
    OBP_MiLB = round(OBP, 3),
    SLG_MiLB = round(SLG, 3),
    OPS_MiLB = round(OPS, 3),
    ISO_MiLB = round(ISO, 3),
    Spd_MiLB = round(Spd, 1),
    BABIP_MiLB = round(BABIP, 3),
    wSB_MiLB = round(wSB, 1),
    wRC_MiLB = round(wRC, 0),
    wRAA_MiLB = round(wRAA, 1),
    wOBA_MiLB = round(wOBA, 3),
    wRCplus_MiLB = round(wRCplus, 0)
  ) %>%
  select(c(-BB_Percentage, -K_Percentage, -BB_to_K, -AVG, -OBP, -SLG,
           -OPS, -ISO, -Spd, -BABIP,
           -wSB, -wRC, -wRAA, -wOBA, -wRCplus))

## --- Rename current MLB columns to differentiate between MLB & MiLB metrics --

MLB_for_Current_MLB = MLB_for_Current_MLB %>%
  mutate(
    ID = as.character(ID),
    BB_Percentage = as.numeric(gsub('\\%', '', BB_Percentage))/100,
    K_Percentage = as.numeric(gsub('\\%', '', K_Percentage))/100) %>%
  select(c(-Level, -G))

names(MLB_for_Current_MLB)[3:17] = c('BB_Percentage_MLB', 'K_Percentage_MLB', 
                                    'BB_to_K_MLB', 'AVG_MLB', 'OBP_MLB', 'SLG_MLB',
                                    'OPS_MLB','ISO_MLB', 'Spd_MLB', 'BABIP_MLB',
                                    'wSB_MLB', 'wRC_MLB', 'wRAA_MLB',
                                    'wOBA_MLB', 'wRCplus_MLB')

## --- Merge MiLB and MLB data to get columns side by side ---------------------

Current_MLB_with_MiLB = merge(MiLB_for_Current_MLB, MLB_for_Current_MLB, 
                              by.x = 'ID', by.y = 'ID')  
Current_MLB_with_MiLB = Current_MLB_with_MiLB[-18]
names(Current_MLB_with_MiLB)[2] = 'Name'
Current_MLB_with_MiLB = Current_MLB_with_MiLB %>%
  relocate(ID, Name, BB_Percentage_MLB, BB_Percentage_MiLB, K_Percentage_MLB, 
           K_Percentage_MiLB, BB_to_K_MLB, BB_to_K_MiLB, AVG_MLB, AVG_MiLB,
           OBP_MLB, OBP_MiLB, SLG_MLB, SLG_MiLB, OPS_MLB, OPS_MiLB, ISO_MLB,
           ISO_MiLB, Spd_MLB, Spd_MiLB, BABIP_MLB, BABIP_MiLB, wSB_MLB,
           wSB_MiLB, wRC_MLB, wRC_MiLB, wRAA_MLB, wRAA_MiLB, wOBA_MLB,
           wOBA_MiLB, wRCplus_MLB, wRCplus_MiLB)

## --- Apply same weights and grouping to current MiLB prospects ---------------

Current_MiLB = Current_MiLB %>%
  mutate(
    ID = as.character(ID),
    Weight = as.numeric(ifelse(Level == 'R', 1,
                        ifelse(Level == 'A', 1.25, 
                        ifelse(Level == 'A+', 1.5, 
                        ifelse(Level == 'AA', 1.75,
                        ifelse(Level == 'AAA', 2, Level)))))),
  BB_Percentage_MiLB = Weight*as.numeric(gsub('\\%', '', BB_Percentage))/100,
  K_Percentage_MiLB = Weight*as.numeric(gsub('\\%', '', K_Percentage))/100,
  BB_to_K_MiLB = Weight*BB_to_K,
  AVG_MiLB = Weight*AVG,
  OBP_MiLB = Weight*OBP,
  SLG_MiLB = Weight*SLG,
  Spd_MiLB = Weight*Spd,
  OPS_MiLB = Weight*OPS,
  ISO_MiLB = Weight*ISO,
  BABIP_MiLB = Weight*BABIP,
  wSB_MiLB = Weight*wSB,
  wRC_MiLB = Weight*wRC,
  wRAA_MiLB = Weight*wRAA,
  wOBA_MiLB = Weight*wOBA,
  wRCplus_MiLB = Weight*wRCplus) %>%
  group_by(ID, Name) %>%
  summarise_at(c('BB_Percentage_MiLB', 'K_Percentage_MiLB', 'BB_to_K_MiLB', 
                 'AVG_MiLB', 'OBP_MiLB', 'SLG_MiLB', 'OPS_MiLB', 'ISO_MiLB',
                 'Spd_MiLB', 'BABIP_MiLB', 'wSB_MiLB', 'wRC_MiLB', 'wRAA_MiLB',
                 'wOBA_MiLB', 'wRCplus_MiLB'), mean) %>%
  mutate(
    BB_Percentage_MiLB = round(BB_Percentage_MiLB, 3),
    K_Percentage_MiLB = round(K_Percentage_MiLB, 3),
    BB_to_K_MiLB = round(BB_to_K_MiLB, 2),
    AVG_MiLB = round(AVG_MiLB, 3),
    OBP_MiLB = round(OBP_MiLB, 3),
    SLG_MiLB = round(SLG_MiLB, 3),
    OPS_MiLB = round(OPS_MiLB, 3),
    ISO_MiLB = round(ISO_MiLB, 3),
    Spd_MiLB = round(Spd_MiLB, 1),
    BABIP_MiLB = round(BABIP_MiLB, 3),
    wSB_MiLB = round(wSB_MiLB, 1),
    wRC_MiLB = round(wRC_MiLB, 0),
    wRAA_MiLB = round(wRAA_MiLB, 1),
    wOBA_MiLB = round(wOBA_MiLB, 3),
    wRCplus_MiLB = round(wRCplus_MiLB, 0)
  )





