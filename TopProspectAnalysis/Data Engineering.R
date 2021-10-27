library(rvest)
library(plyr)
library(dplyr)
library(Lahman)
library(baseballr)
library(scales)


data("People") # Lahman


## --- Create table to merge each team by each year for link below -----------
years = 2010:2021
teams = c('LAA', 'ARI', 'ATL', 'BAL', 'BOS', 
          'CHC', 'CHW', 'CIN', 'CLE', 'COL',
          'DET', 'MIA', 'HOU', 'KCR', 'LAD',
          'MIL', 'MIN', 'NYM', 'NYY', 'OAK',
          'PHI', 'PIT', 'SDP', 'SEA', 'SFG',
          'STL', 'TBR', 'TEX', 'TOR', 'WSN')
All = merge(teams, years)
team_year = paste0(All$x, '/', All$y)


BBREF_urls = paste0('https://www.baseball-reference.com/teams/',team_year,'.shtml#all_team_batting')

## --- Scrape Baseball Reference for rosters from every team between 2010 and 2021 ---

Rosters = data.frame()
for (i in seq_along(BBREF_urls)) {
  tbl = BBREF_urls[i] %>%
    read_html() %>%
    html_nodes("table") %>%
    html_table()
  t1 = tbl[[1]] %>%
    mutate(
      Name = gsub('\\*|#', '', Name)
      ) %>%
    select(Pos, Name) %>%
    filter(!Pos %in% c('P', 'SP', 'RP', 'CL', '', 'Pos'))
  Rosters = rbind(Rosters, t1)
  print(i)
}


## --- Get BBREF IDs -----------------------------------------------------------

All_BBREF_IDs = People %>%
  select('playerID', 'nameFirst', 'nameLast') %>%
  mutate(Name = paste(nameFirst, nameLast)) %>%
  select(playerID, Name)


## --- Merge on ID with the names of the players in above table ----------------

Scraped_IDs = data.frame(merge(All_BBREF_IDs, Rosters, by.x = 'Name', by.y = 'Name'))


## --- Merge with chadwick database from baseballr package for Fangraphs IDs ---

chadwick = get_chadwick_lu() # baseballr package

Final_ID = merge(Scraped_IDs, chadwick, by.x = 'playerID', by.y = 'key_bbref')%>%
  select(playerID, Name, key_fangraphs, mlb_played_first)

Final_ID = unique(Final_ID) %>%
  filter(!is.na(key_fangraphs),
         mlb_played_first >= 2006) # When Fangraphs starts tracking minor league data

FangraphsID_with_Name = Final_ID %>%
  select(key_fangraphs, Name)

FangraphsID = Final_ID$key_fangraphs

## ---- All work above is to get rosters and merge IDs from multiple sources to get FangraphsID -----##

## --- Scrape Fangraphs for Advance Metrics Table ------------------------------

Fangraphs_urls = paste0('https://www.fangraphs.com/statss-legacy.aspx?playerid=',FangraphsID,'&position=PB')

Current_MLB = data.frame()
for (i in seq_along(Fangraphs_urls)) {
  tbl = Fangraphs_urls[i] %>%
    read_html() %>%
    html_nodes(xpath = '//*[@id="SeasonStats1_dgSeason2"]') %>%
    html_table(trim = T) %>%
    data.frame(stringsAsFactors = F)
  t1 = tbl[] %>%
    filter(
      !Team %in% c('Steamer (R)', 'Steamer', 'Average', 'ATC', 'Depth Charts', 
                   'Depth Charts (R)', 'THE BAT', 'THE BAT (R)',
                   'THE BAT X', 'THE BAT X (RoS)', 'ZiPS', 'ZiPS (R)',
                   '2 Teams'),
      !Season %in% 'Postseason') %>% # remove unwanted rows 
    mutate(
      Level = ifelse(grepl('\\(R)', Team), 'R',
              ifelse(grepl('\\(A)', Team), 'A',
              ifelse(grepl('\\(A\\+)', Team), 'A+',
              ifelse(grepl('\\(AA)', Team), 'AA',
              ifelse(grepl('\\(AAA)', Team), 'AAA',
              ifelse(grepl('\\- - -', Team), 'MLB',
              Team)))))), # Create level
      ID = FangraphsID[i] # Add ID
    ) %>%
    filter(
      Level %in% c('R', 'A', 'A+', 'AA', 'AAA', 'MLB')
    ) %>%
    rename(
      BB_Percentage = BB.,
      K_Percentage = K.,
      BB_to_K = BB.K,
      wRCplus = wRC.
    ) %>%
    merge(FangraphsID_with_Name, by.x = 'ID',by.y='key_fangraphs') %>% # Get Name
    select(
      c(Name, ID, Level, everything(), -Team, -UBR, -wGDP, -Season)
    ) 
  Current_MLB = rbind(Current_MLB, t1) 
  print(i)
}

## --- Clean Advanced Metrics Table -------------------------------------------

Current_MLB = Current_MLB %>%
  mutate(BB_Percentage = as.numeric(gsub('\\%', '', BB_Percentage)),
         K_Percentage = as.numeric(gsub('\\%', '', K_Percentage))) %>%
  group_by(ID, Level, Name) %>% # Group to get one row per level by player
  summarise(
    BB_Percentage = percent(mean(BB_Percentage)/100, accuracy = .1),
    K_Percentage = percent(mean(K_Percentage)/100, accuracy = .1),
    BB_to_K = round(mean(BB_to_K), 2),
    AVG = round(mean(AVG), 3),
    OBP = round(mean(OBP), 3),
    SLG = round(mean(SLG), 3),
    OPS = round(mean(OPS), 3),
    ISO = round(mean(ISO), 3),
    Spd = round(mean(Spd), 1),
    BABIP = round(mean(BABIP), 3),
    wSB = round(mean(wSB), 1),
    wRC = round(mean(wRC), 0),
    wRAA = round(mean(wRAA), 1),
    wOBA = round(mean(wOBA), 3),
    wRCplus = round(mean(wRCplus), 0)
  )

unique(Current_MLB$ID)


## --- Scrape Fangraphs Main Table to get games played -------------------------

Current_Games = data.frame()
for (i in seq_along(Fangraphs_urls)) {
  tbl = Fangraphs_urls[i] %>%
    read_html() %>%
    html_nodes(xpath = '//*[@id="SeasonStats1_dgSeason11_ctl00"]') %>%
    html_table(trim = T) %>%
    data.frame(stringsAsFactors = F)
  t1 = tbl[] %>%
    filter(
      !Team %in% c('Steamer (R)', 'Steamer', 'Average', 'ATC', 'Depth Charts', 
                   'Depth Charts (R)', 'THE BAT', 'THE BAT (R)',
                   'THE BAT X', 'THE BAT X (RoS)', 'ZiPS', 'ZiPS (R)',
                   '2 Teams'),
      !Season %in% 'Postseason') %>% # remove unwanted rows 
    mutate(
      Level = ifelse(grepl('\\(R)', Team), 'R',
              ifelse(grepl('\\(A)', Team), 'A',
              ifelse(grepl('\\(A\\+)', Team), 'A+',
              ifelse(grepl('\\(AA)', Team), 'AA',
              ifelse(grepl('\\(AAA)', Team), 'AAA',
              ifelse(grepl('\\- - -', Team), 'MLB',
              Team)))))), # Create level
      ID = FangraphsID[i] # Add ID
    ) %>%
    filter(
      Level %in% c('R', 'A', 'A+', 'AA', 'AAA', 'MLB')
      ) %>%
    select(
      ID, G, Level
    )
  Current_Games = rbind(Current_Games, t1)
  print(i)
}

## --- Group table by ID and Level to get total games at each level ------------

Current_Games = Current_Games %>%
  group_by(ID, Level) %>%
  summarise(G = sum(G))

## --- Join Advanced Table and Games table to get one data frame ---------------

Current_MLB = join(Current_MLB, Current_Games) %>%
  relocate(ID, Name, Level, G, everything())

  
## --- Get Fangraphs Top 100 Position Players IDs and URLs ---------------------


Top_100 = read.csv('C:/Users/agold/OneDrive/Desktop/AWS Project/fangraphsProspectIDs.csv')

Top_100_ID_with_Name = Top_100 %>%
  select(playerId, Name)

Top_100_ID = Top_100$playerId

Top_100_urls = paste0('https://www.fangraphs.com/statss-legacy.aspx?playerid=',Top_100_ID,'&position=PB')

## --- Scrape Fangraphs For Advanced Metrics Table for Top 100 -----------------

Current_MiLB = data.frame()
for (i in seq_along(Top_100_urls)) {
  tbl = Top_100_urls[i] %>%
    read_html() %>%
    html_nodes(xpath = '//*[@id="SeasonStats1_dgSeason2"]') %>%
    html_table(trim = T) %>%
    data.frame(stringsAsFactors = F)
  t1 = tbl[] %>%
    filter(
      !Team %in% c('Steamer (R)', 'Steamer', 'Average', 'ATC', 'Depth Charts', 
                   'Depth Charts (R)', 'THE BAT', 'THE BAT (R)',
                   'THE BAT X', 'THE BAT X (RoS)', 'ZiPS', 'ZiPS (R)',
                   '2 Teams'),
      !Season %in% 'Postseason') %>% # remove unwanted rows 
    mutate(
      Level = ifelse(grepl('\\(R)', Team), 'R',
              ifelse(grepl('\\(A)', Team), 'A',
              ifelse(grepl('\\(A\\+)', Team), 'A+',
              ifelse(grepl('\\(AA)', Team), 'AA',
              ifelse(grepl('\\(AAA)', Team), 'AAA',
              ifelse(grepl('\\- - -', Team), 'MLB',
              Team)))))), # Create level
      ID = Top_100_ID[i] # Add ID
    ) %>%
    filter(
      Level %in% c('R', 'A', 'A+', 'AA', 'AAA', 'MLB')
    ) %>%
    rename(
      BB_Percentage = BB.,
      K_Percentage = K.,
      BB_to_K = BB.K,
      wRCplus = wRC.
    ) %>%
    merge(Top_100_ID_with_Name, by.x = 'ID',by.y='playerId') %>% # Get Name
    select(
      c(Name, ID, Level, everything(), -Team, -UBR, -wGDP, -Season)
    ) 
  Current_MiLB = rbind(Current_MiLB, t1) 
  print(i)
}


## --- Clean Top 100 Advance Metrics Table -------------------------------------

Current_MiLB = Current_MiLB %>%
  mutate(BB_Percentage = as.numeric(gsub('\\%', '', BB_Percentage)),
         K_Percentage = as.numeric(gsub('\\%', '', K_Percentage))) %>%
  group_by(ID, Level, Name) %>% # Group to get one row per level by player
  summarise(
    BB_Percentage = percent(mean(BB_Percentage)/100, accuracy = .1),
    K_Percentage = percent(mean(K_Percentage)/100, accuracy = .1),
    BB_to_K = round(mean(BB_to_K), 2),
    AVG = round(mean(AVG), 3),
    OBP = round(mean(OBP), 3),
    SLG = round(mean(SLG), 3),
    OPS = round(mean(OPS), 3),
    ISO = round(mean(ISO), 3),
    Spd = round(mean(Spd), 1),
    BABIP = round(mean(BABIP), 3),
    wSB = round(mean(wSB), 1),
    wRC = round(mean(wRC), 0),
    wRAA = round(mean(wRAA), 1),
    wOBA = round(mean(wOBA), 3),
    wRCplus = round(mean(wRCplus), 0)
  )


## --- Get Top 100 Games played from Main table --------------------------------

Top_100_Games = data.frame()
for (i in seq_along(Top_100_urls)) {
  tbl = Top_100_urls[i] %>%
    read_html() %>%
    html_nodes(xpath = '//*[@id="SeasonStats1_dgSeason11_ctl00"]') %>%
    html_table(trim = T) %>%
    data.frame(stringsAsFactors = F)
  t1 = tbl[] %>%
    filter(
      !Team %in% c('Steamer (R)', 'Steamer', 'Average', 'ATC', 'Depth Charts', 
                   'Depth Charts (R)', 'THE BAT', 'THE BAT (R)',
                   'THE BAT X', 'THE BAT X (RoS)', 'ZiPS', 'ZiPS (R)',
                   '2 Teams'),
      !Season %in% 'Postseason') %>% # remove unwanted rows 
    mutate(
      Level = ifelse(grepl('\\(R)', Team), 'R',
              ifelse(grepl('\\(A)', Team), 'A',
              ifelse(grepl('\\(A\\+)', Team), 'A+',
              ifelse(grepl('\\(AA)', Team), 'AA',
              ifelse(grepl('\\(AAA)', Team), 'AAA',
              ifelse(grepl('\\- - -', Team), 'MLB',
              Team)))))), # Create level
      ID = Top_100_ID[i] # Add ID
    ) %>%
    filter(
      Level %in% c('R', 'A', 'A+', 'AA', 'AAA', 'MLB')
    ) %>%
    select(
      ID, G, Level
    )
  Top_100_Games = rbind(Top_100_Games, t1)
  print(i)
}

## --- Group Top_100_Games to get total games played by level for each player --

Top_100_Games = Top_100_Games %>%
  group_by(ID, Level) %>%
  summarise(G = sum(G))

## --- Join games and advanced metrics table to get one data frame for Top 100 --

Current_MiLB = join(Current_MiLB, Top_100_Games) %>%
  relocate(ID, Name, Level, G, everything())

## --- Remove any MLB data from MiLB table due to recent callups ---------------

Current_MiLB = Current_MiLB[-c(5,11,17,23,28,33,37,43,48,54,59,85,292),]

## --- View Final Data Frames ---------------------------------------------------

