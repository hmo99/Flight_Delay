## server.R ##
shinyServer(function(input, output){
  
#output---map
  output$map= renderLeaflet({
    
    ##Prepare data for map
    map_df=Flight_df %>% 
      filter(., AIRLINE %in% input$Air, Month %in% input$month_map) %>% 
      mutate(., Cost_of_Delay=Direct_Aircraft_Operating_Cost_per_min*Sum_Delay_Min,2) %>% 
      mutate(., Delay_Hours=Sum_Delay_Min/60, digits=1)%>% 
      group_by(., AIRPORT, LATITUDE , LONGITUDE, STATE , CITY, ORIGIN ) %>% 
      summarise(., 
                mean_delay_hour=round(mean(Delay_Hours), digits=2), 
                mean_cost_of_delay_per_flight=round(mean(Cost_of_Delay), digits=2))
    
    
    # Create a color palette.
    mybins <- seq(0,4, by=0.5)
    mypalette <- colorBin( palette="YlOrBr", 
                           domain=map_df$mean_delay_hour, 
                           na.color="transparent", 
                           bins=mybins)
    
    
    #Prep text for tooltip
    mytext <- paste(
      "State: ", map_df$STATE,"<br/>", 
      "City: ", map_df$CITY,"<br/>", 
      "IATA: ", map_df$ORIGIN,"<br/>",
      "Origin Airport: ", map_df$AIRPORT, "<br/>", 
      "Average Hours of Delay per Flight (Hrs): "   , map_df$mean_delay_hour, "<br/>", 
      "Average Cost of Delay per Flight ($): "  , map_df$mean_cost_of_delay_per_flight, sep="") %>%
      lapply(htmltools::HTML)
    
    
    #map
    leaflet(map_df) %>% 
      addTiles () %>% 
      setView(lng = -98.58, lat = 39.82, zoom = 3) %>% 
      addProviderTiles("Stamen.Toner") %>% 
      addCircleMarkers(~ LONGITUDE, ~LATITUDE,
                       fillColor = ~mypalette(mean_delay_hour),
                       fillOpacity = 0.7, 
                       color="white", 
                       radius=8, 
                       stroke=FALSE,
                       label=mytext,
                       labelOptions = labelOptions( style = list("font-weight" = "normal", 
                                                                 padding = "3px 8px"), 
                                                    textsize = "13px", direction = "auto")
      ) %>% 
      addLegend( pal=mypalette, 
                 values=~mean_delay_hour, 
                 opacity=0.9, 
                 title = "Average Delay Hours per Flight", 
                 position = "bottomright" )
    
  })#end of output map
  
  
  
  
  
  
  
  #tab output reason by month, dodge bar chart, select airline
  output$Reason_month_dodged=renderPlotly({
    gathered_delay %>% 
      filter(., AIRLINE  %in% input$Airline) %>% 
      group_by(., Reason,Month) %>% 
      summarise(., Delay_Hours=round(mean(Delay_Hours),digits=1)) %>% 
      ggplot(aes(x = Month, y =Delay_Hours)) + 
      geom_bar(stat = 'identity',aes(fill = Reason), position='dodge')+
      ggtitle(" 2018 Average Delay Hours per Flight")+ylab('Average Delay Hours per Flight')
  }) #end ouput
  
  #tab output reason by month, dodge bar chart-select airport
  output$Reason_month_dodged_city=renderPlotly({
    gathered_delay %>% 
      filter(., ORIGIN  %in% input$DepAirport) %>% 
      group_by(., Reason,Month) %>% 
      summarise(., Delay_Hours=round(mean(Delay_Hours),digits=1)) %>% 
      ggplot(aes(x = Month, y =Delay_Hours)) + 
      geom_bar(stat = 'identity',aes(fill = Reason), position='dodge')+
      ggtitle(" 2018 Average Delay Hours per Flight")+ylab('Average Delay Hours per Flight')
  }) #end ouput
  
  
  

  #output tab heatmap by airline
  output$heatmap=renderPlotly({
    heatmap_df=Flight_df %>% 
      filter(., AIRLINE %in% input$Airline_heat_airline) %>% 
      select(., Hour, Weekday,Date) %>% 
      mutate(.,Count=1) %>% 
      mutate(., Hour=as.factor(Hour)) %>% 
      group_by(., Weekday, Hour ) %>% 
      summarise(., Number_Delays=sum(Count)) %>% 
      ggplot(. , aes(Hour, Weekday,fill=Number_Delays))+
      geom_tile()
  })
  
  
  
  #output tab heatmap by airport
  output$heatmap_airport=renderPlotly({
    Hour_Weekdays=Flight_df %>% 
      filter(., ORIGIN== input$DepAirport_heat) %>% 
      select(., Hour, Weekday) %>% mutate(.,Count=1) %>% 
      mutate(., Hour=as.factor(Hour)) %>% 
      group_by(., Weekday, Hour ) %>% 
      summarise(., Number_Delays=sum(Count)) %>% 
      
      ggplot(. , aes(Hour, Weekday,fill=Number_Delays))+
      geom_tile()
  })
  
  #ouput boxplot
  output$boxplot_month_airline=renderPlot({

    Box_df_month %>% filter(.,AIRLINE  %in% input$Airline_box) %>% 
      ggplot(., aes(x=Month, y=Delay_Hours))+geom_boxplot()
  })
  
  
  #ouput boxplot
  output$boxplot_weekday_airline=renderPlot({
    
    Box_df_week %>% filter(.,AIRLINE  %in% input$Airline_box_week ) %>% 
      ggplot(., aes(x=Weekday, y=Delay_Hours))+geom_boxplot()
  })
  
  
  #output boxplot
  output$boxplot_hour_airline=renderPlot({
    
    Box_df_Hour %>% filter(.,AIRLINE  %in% input$Airline_box_hour) %>% 
    ggplot(., aes(x=Hour, y=Delay_Hours))+geom_boxplot()
    
  })
  
  
  ###output tab-time series-frequency
  output$times_frequency_airline=renderPlot({
    
    Flight_df %>% 
      filter(., AIRLINE %in% input$times_frequency_airline_airline) %>% 
      group_by(., Date, AIRLINE) %>% 
      mutate(., Count_Delay=1) %>% 
      summarise(., Num_Flight_Delay=sum(Count_Delay)) %>% 
      mutate(., date=as.Date(Date, '%Y-%m-%d')) %>% 
      ggplot(., aes(x=date, y=Num_Flight_Delay,color=AIRLINE))+
      geom_line(color="#69b3a2")+
      xlab('Month')+
      theme_linedraw()+
      ylab('Number of Flight Delay')
    
  })
  
##output tab -time series-cost
  
  output$times_frequency_airline_cost=renderPlot({
    
    Flight_df %>% 
      filter(., AIRLINE %in% input$times_frequency_airline_airline) %>% 
      group_by(., Date) %>% 
      mutate(., cost_of_delay_per_flight=Direct_Aircraft_Operating_Cost_per_min*Sum_Delay_Min) %>% 
      summarise(., Cost_of_Delay=sum(cost_of_delay_per_flight))%>% 
      mutate(., date=as.Date(Date, '%Y-%m-%d')) %>% 
      ggplot(., aes(x=date, y=Cost_of_Delay))+
      geom_line(color="#69b3a2")+
      xlab('Month')+
      theme_foundation()+
      ylab('Cost of Delay')
    
  })
  
  
#output data table
  output$data_table=renderDataTable(datatable({
  data=Flight_df %>% 
  select(.,ORIGIN ,AIRLINE,OP_CARRIER_FL_NUM ,FL_DATE, ARR_DELAY ,CARRIER_DELAY ,WEATHER_DELAY ,NAS_DELAY,SECURITY_DELAY ,LATE_AIRCRAFT_DELAY)
  data
  }))
  
})#end of shinyServer
