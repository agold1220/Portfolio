library(ggplot2)
library(shiny)
library(dplyr)
library(ggthemes)
library(rsconnect)


PitcherData = read.csv('PitchersData.csv')
HitterData = read.csv('HittersData.csv')
HitterMetrics = read.csv('HitterAdvancedMetrics.csv')
PitcherMetrics = read.csv('PitcherAdvancedMetrics.csv')


plate_width <- 17+2*(9/pi)


#Pitcher Outcome
PitcherData$Outcome = ifelse(grepl('single', PitcherData$events, ignore.case = T),'Hit', 
                      ifelse(grepl('double', PitcherData$events, ignore.case = T),'Hit', 
                      ifelse(grepl('triple', PitcherData$events, ignore.case = T),'Hit',
                      ifelse(grepl('home_run', PitcherData$events, ignore.case = T),'Hit',
                      ifelse(grepl('strikeout', PitcherData$events, ignore.case = T),'Strikeout',
                      ifelse(grepl('force_out', PitcherData$events, ignore.case = T),'Field Out',
                      ifelse(grepl('field_out', PitcherData$events, ignore.case = T),'Field Out',
                      ifelse(grepl('fielders_choice_out', PitcherData$events, ignore.case = T),'Field Out',
                      ifelse(grepl('double_play', PitcherData$events, ignore.case = T),'Field Out', PitcherData$events)))))))))

#Hitter Outcome
HitterData$Outcome =  ifelse(grepl('single', HitterData$events, ignore.case = T),'Hit', 
                      ifelse(grepl('double', HitterData$events, ignore.case = T),'Hit', 
                      ifelse(grepl('triple', HitterData$events, ignore.case = T),'Hit',
                      ifelse(grepl('home_run', HitterData$events, ignore.case = T),'Hit',
                      ifelse(grepl('strikeout', HitterData$events, ignore.case = T),'Strikeout',
                      ifelse(grepl('force_out', HitterData$events, ignore.case = T),'Field Out',
                      ifelse(grepl('field_out', HitterData$events, ignore.case = T),'Field Out',
                      ifelse(grepl('fielders_choice_out', HitterData$events, ignore.case = T),'Field Out',
                      ifelse(grepl('double_play', HitterData$events, ignore.case = T),'Field Out', HitterData$events)))))))))
  



#Hitter Table
names(HitterMetrics)[c(1,2,3,11,12)] = c('Player Name', 'Pitch Type', 
                                       'Pitch Percentage', 
                                       'Average Exit Velocity', 
                                       'Average Launch Angle')

HitterMetrics %>%
  select('Player Name', 'Pitch Percentage', AVG, ISO, BABIP, SLG, wOBA, xwOBA, xBA, 
         'Average Exit Velocity' , 'Average Launch Angle')

#Pitcher Table
names(PitcherMetrics)[c(1,2,3,11,12,13,15,16)] = c('Player Name', 'Pitch Type', 
                                                   'Pitch Percentage', 
                                                   'Average Exit Velocity',
                                                   'Average Launch Angle',
                                                   'Average Spin Rate',
                                                   'Effective Speed',
                                                   'Release Extension')

PitcherMetrics %>%
  select('Player Name', 'Pitch Type', 'Pitch Percentage', AVG, ISO, BABIP, SLG,
         wOBA, xwOBA, xBA, 'Average Exit Velocity', 'Average Launch Angle',
         'Average Spin Rate', Velocity, 'Effective Speed','Release Extension')



#-------------------------------------------------------------------------------

#Start Shiny App

ui = fluidPage(
  sidebarLayout(
  sidebarPanel(
    
    conditionalPanel(
      condition = 'input.tabselected == 1 | input.tabselected == 2',
      
      #Pitcher Input
      selectInput('pitcher', 'Select Pitcher:', choices = unique(PitcherData$player_name)),
      selectInput('pitcherpitchtype', 'Pitch Type:', choices = c('All',
                                                                 'Fastball' = 'FF',
                                                                 'Change-Up' = 'CH',
                                                                 'Slider' = 'SL',
                                                                 'Curveball' = 'CU',
                                                                 'Knuckle Curve' = 'KC',
                                                                 'Cutter' = 'FC',
                                                                 'Sinker' = 'SI',
                                                                 'Splitter' = 'FS',
                                                                 'Slow Curveball' = 'CS'))), #conditional panel 1
    conditionalPanel(
      condition = 'input.tabselected == 1',
      
      selectInput('pitcherresult', 'Select Pitcher Result:', 
                  choices = c('All',
                              'Hit', 
                              'Strikeout',
                              'Field Out')
      )), #conditional panel 2
    
    conditionalPanel(
      condition = 'input.tabselected == 1 | input.tabselected == 2',
      
      #Hitter Input
      selectInput('hitter', 'Select Hitter:', choices = unique(HitterData$player_name)),
      selectInput('hitterpitchtype', 'Pitch Type:', choices = c('All',
                                                                'Fastball' = 'FF',
                                                                'Change-Up' = 'CH',
                                                                'Slider' = 'SL',
                                                                'Curveball' = 'CU',
                                                                'Knuckle Curve' = 'KC',
                                                                'Cutter' = 'FC',
                                                                'Sinker' = 'SI',
                                                                'Splitter' = 'FS',
                                                                'Slow Curveball' = 'CS'))), #conditional panel 3
    conditionalPanel(
      condition = 'input.tabselected == 1',
      
      selectInput('hitterresult', 'Select Hitter Result:', 
                  choices = c('All',
                              'Hit', 
                              'Strikeout',
                              'Field Out'))), #conditional panel 4
  ), #sidebarPanel
  
  mainPanel(
    tabsetPanel(type = 'pills', id = 'tabselected',
  tabPanel('Heat Maps', value = 1, splitLayout(plotOutput('pitchermap'), plotOutput('hittermap'))),
  tabPanel('Metrics', value = 2, tableOutput('PitcherMetrics'), 
           tableOutput('HitterMetrics'))
    )#tabsetPanel
  ) #mainPanel
  ) #sidebarLayout
  
) #fluidPage

server = function(input, output){

  
  #Pitcher Plot
  
  PitcherHeatMap <- reactive({
    
    rows = TRUE
    if(input$pitcherpitchtype != 'All'){rows = rows & PitcherData$pitch_type == input$pitcherpitchtype}
    if(input$pitcherresult != 'All'){rows = rows & PitcherData$Outcome == input$pitcherresult}
    
    
    PitcherData[rows, ] %>%
      filter(player_name == input$pitcher)
  })
  
  output$pitchermap = renderPlot(
    ggplot(PitcherHeatMap(), aes(x = plate_x, y = plate_z)) +
      stat_density_2d_filled(show.legend = FALSE, bins = 5) +
      scale_fill_manual(values = c('white', 'slategray2', 'gray95', 'indianred2', 'red4')) +
      geom_rect(xmin = -(plate_width/2)/12,
                xmax = (plate_width/2)/12,
                ymin = 1.5,
                ymax = 3.6,
                alpha = .01,
                color = 'black',
                size = 1,
                fill = NA) +
      coord_equal() +
      xlab('Horizontal Location (Catcher View)') +
      ylab('Vertical Location') +
      lims(x = c(-2,2), y = c(0,5)) +
      theme_classic() +
      labs(title = paste(input$pitcher, "\n", input$pitcherpitchtype,"\n", input$pitcherresult, sep = ''), 
           x = 'Horizontal Location (Catcher View)', y = 'Vertical Location') +
      theme(plot.title = element_text(hjust = 0.5))
  )
  
  
  #Hitter Plot
  
  HitterHeatMap <- reactive({
    
    rows = TRUE
    if(input$hitterpitchtype != 'All'){rows = rows & HitterData$pitch_type == input$hitterpitchtype}
    if(input$hitterresult != 'All'){rows = rows & HitterData$Outcome == input$hitterresult}
    
    
    HitterData[rows, ] %>%
      filter(player_name == input$hitter)
  })
  
  output$hittermap = renderPlot(
    ggplot(HitterHeatMap(), aes(x = plate_x, y = plate_z)) +
      stat_density_2d_filled(show.legend = FALSE, bins = 5) +
      scale_fill_manual(values = c('white', 'slategray2', 'gray95', 'indianred2', 'red4')) +
      geom_rect(xmin = -(plate_width/2)/12,
                xmax = (plate_width/2)/12,
                ymin = 1.5,
                ymax = 3.6,
                alpha = .01,
                color = 'black',
                size = 1,
                fill = NA) +
      coord_equal() +
      xlab('Horizontal Location (Catcher View)') +
      ylab('Vertical Location') +
      lims(x = c(-2,2), y = c(0,5)) +
      theme_classic() +
      labs(title = paste(input$hitter, "\n", input$hitterpitchtype, "\n", 
                         input$hitterresult, sep = ''), 
           x = 'Horizontal Location (Catcher View)', y = 'Vertical Location') +
      theme(plot.title = element_text(hjust = 0.5))
  )

  #Pitcher Metrics Table
  
  output$PitcherMetrics = renderTable(
    
    PitcherMetrics %>%
      filter(`Player Name` == input$pitcher,
             `Pitch Type` == input$pitcherpitchtype)
    
  )
  
  
  #Hitter Metrics Table  

  output$HitterMetrics = renderTable(
    
      HitterMetrics %>%
        filter(`Player Name` == input$hitter,
               `Pitch Type` == input$hitterpitchtype)
      
    )
  
}

shinyApp(ui, server)
