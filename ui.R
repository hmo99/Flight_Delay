## ui.R ##
library(shinydashboard)


#Create UI Dashboard
shinyUI(dashboardPage(
  skin='blue',
  dashboardHeader(title="Flight Delays in USA"),
  
  #Create dashboard side bar
  dashboardSidebar(
    sidebarUserPanel("Huimin Ou"),
    sidebarMenu(
      menuItem("Introduction", 
               tabName="intro", 
               icon=icon('info')),
      
      menuItem("Map", 
               tabName="Map", 
               icon=icon('map')),
      menuItem('Reasons of Delay', 
               tabName='Reason_by_month', 
               icon=icon("chart-bar")),
      menuItem('Heatmap', 
               tabName="heatmap", 
               icon=icon('clock')),
      menuItem('Times Series',
               tabName="TimeS", icon=icon("chart-line")),
      menuItem('Delay Hours Box Plots',
               tabName="boxplot", icon=icon("chart-area")),
      menuItem('Data', tabName="Data", icon=icon('table')) 
      
    ) #end of sidebarMenu
  ), #end of dashboardSidebar
  
  
  
  dashboardBody(
    tabItems(
      
      #Introduction tab

      tabItem(
        tabName = 'intro',
        div(
            br(),
            h1('Background'),
            h3(" There are thousands of flight delays in the United States everyday."),
            h3('Direct Aircraft Operating Cost is 74.2 $/min. Flight delays cost airlines billions of dollars every year.'),
            h3("It is important for the airlines to minimize flight delays."),
            h3('This app can help the airline to better visualize flight delays.'),
            br(),
            br(),
            br(),
            h1(" Dataset:"),
            h3('For 2018 Flight Data,  Data Source: https://www.kaggle.com/yuanyuwendymu/airline-delay-and-cancellation-data-2009-2018'),
            h3('For the Direct Aircraft Operating Cost per Minut, the Information Source website is https://www.airlines.org/dataset/per-minute-cost-of-delays-to-u-s-airlines/  .'),
            h3('Due to memory limitation of Shiny app, I have to subset my data.'),
            h3(' Original dataset size for 2018 Flight is 7,213,446  observations.'),
            h3(' I subsetted data to 2018 delay flights for American and Delta Airlines in the United States.'),
            h3(' New Dataset Size is 310,983 observations'),
            br(),
            br(),
            br(),
            h5('Author: Huimin Ou'),
            h5('Email: huimin.ou99@gmail.com'),
            h5('Linkedin: linkedin.com/in/huimin-ou-0239a9a1')
            
        ) #end of div
      ) ,#end of tabitem for Introduction Tab
      
      
      #Map-Visualization
      
      tabItem(tabName="Map",
              fluidRow(
                column(width=9,
                       box(
                        title='Flight Origin Airport Delay Hours & Cost of Delay',
                        solidHeader = T,
                        status='info',
                        leafletOutput('map'),
                        width=NULL,
                        height='auto'
                       
                       )#end of box
                ),#end of column
              
                
                column(
                  width=3,
                  box(
                    title='Select Airlines',
                    solidHeader=T,
                    width=NULL,
                    status='info',
                    checkboxGroupInput(inputId='Air', 
                                       label="Select Airlines",
                                       choices=unique(Flight_df$AIRLINE),
                                       selected='American')

                  ) #end of box
                ),#end of column
                
                
                column(
                  width=3,
                  box(
                    title='Select Month',
                    solidHeader=T,
                    width=NULL,
                    status='info',
                    checkboxGroupInput(inputId='month_map',
                                       label="Select Month",
                                       choices=MonthOrdered,
                                       selected='1')
                    
                  ) #end of box
                )#end of column
                
              )# end of fluidRow
              
      ), #end of tabItem for Map
      
      
      
      
      #Tab for Reason of Delay
      
      tabItem(
        tabName='Reason_by_month',
        fluidRow(
            column(
            width=9,
            box(
              title='Analyze: Reason Breakdown by Airline',
              solidHeader = T,
              status='info',
              plotlyOutput('Reason_month_dodged'),
              width=NULL,
              height='auto'
            )#end of box
          ),#end of column
          
          column(
            width=3,
            box(
              title='Select Airlines',
              solidHeader=T,
              width=NULL,
              height='auto',
              status='info',
              checkboxGroupInput(inputId='Airline', #this is the input for server
                                 label="Select Airlines",
                                 choices=unique(Flight_df$AIRLINE),
                                 selected='American')
            ) #end of box
          ), #end of column
          
          column(
            width=9,
            box(
              title='Analyze: Reason Breakdown by Airline ',
              solidHeader = T,
              status='info',
              plotlyOutput('Reason_month_dodged_city'),
              width=NULL,
              height='auto'
            )#box
          ),#end of column
          
          column(
            width=3,
            box(
              title='Select Origin Airport',
              solidHeader = T,
              width=NULL,
              status='info',
              selectizeInput(
                inputId='DepAirport',
                label=NULL,
                choices=unique(Flight_df$ORIGIN )
                
              )
            ) #end of box
          ), #end of column
          
          column(
            width=12,
            div(
              h5('Carrier Delay: Delay caused by carrier such as aircraft cleaning, aircraft damage and baggage loading.'),
              h5('Late Aircraft Delay: Delay caused by previous aircraft arrived late.'),
              h5('NAS Delay: Delay caused by national aviation system.'),
              h5('Security Delay: Delay due security such as evacuation of termination and re-boarding due to security breach.'),
              h5('Weather Delay: Delay due to weather condition.')
            )# end div
          )
      )#end of fluidRow
      ),#end of Delay Reason Tab
      

      
    #Tab Heatmap
      
     tabItem(
       tabName='heatmap',
       fluidRow(
         column(
           width=9,
           box(
            title='Analyze: Delays Frequency by Hours and Weekdays & Airline',
            solidHeader = T,
            width=NULL,
            status='info',
            plotlyOutput('heatmap')
           )#end of box
         ),#end column
         
         column(
           width=3,
           box(
             title='Select Airlines',
             solidHeader=T,
             width=NULL,
             height='auto',
             status='info',
             checkboxGroupInput(inputId='Airline_heat_airline', #this is the input for server
                                label="Select Airlines",
                                choices=unique(Flight_df$AIRLINE),
                                selected='American')
         )#end of box
         ),#end of column
         
         column(
           width=9,
           box(
             title='Analyze: Delays Frequency by Hours and Weekdays & Airport',
             solidHeader = T,
             width=NULL,
             status='info',
             plotlyOutput('heatmap_airport')
           )#end of box

         ),#end column
         
         column(
           width=3,
           box(
             title='Select Origin Airport',
             solidHeader = T,
             width=NULL,
             status='info',
             selectizeInput(
               inputId='DepAirport_heat',
               label=NULL,
               choices=unique(Flight_df$ORIGIN )
             )# end of select
           ) #end of box
         ) #end of column
       )#fluid row
     ),#end of tabITEM
      
      
     
     
     ##Tab Boxplot
    
     tabItem(
       tabName = 'boxplot',
       fluidRow(
         column(
           width=9,
           box(
             title='Analyze: Delay Hours by Month',
             solidHeader = T,
             width=NULL,
             height='auto',
             status = 'info',
             plotOutput('boxplot_month_airline')
           )#end of box
         ),#end of column
         
         column(
           width=3,
           box(
             title='Select Airlines',
             solidHeader=T,
             width=NULL,
             height='auto',
             status='info',
             selectizeInput(
               inputId='Airline_box',
               label="Select Airlines",
               choices=unique(Flight_df$AIRLINE ),
               selected='American'
             ) #end of selectize input
           ) #end of box
         ),#end of column
      
         column(
           width=9,
            box(
            title='Analyze: Delay Hours by Weekday',
            solidHeader = T,
            status = 'info',
            plotOutput('boxplot_weekday_airline'),
             width = NULL,
            height='auto'
             )#end of box
        ),#end of column
        
        column(
          width=3,
          box(
            title='Select Airlines',
            solidHeader=T,
            width=NULL,
            height='auto',
            status='info',

            selectizeInput(
              inputId='Airline_box_week',
              label="Select Airlines",
              choices=unique(Flight_df$AIRLINE ),
              selected='American'
            ) #end selectize
          ) #end of box
        ),#end of column
        
        column(
          width=9,
          box(
            title='Analyze: Delay Hours by Hour of the Day',
            solidHeader = T,
            status = 'info',
            plotOutput('boxplot_hour_airline'),
            width = NULL,
            height='auto'
            
          )#end of box
        ),#end of column
        
        column(
          width=3,
          box(
            title='Select Airlines',
            solidHeader=T,
            width=NULL,
            height='auto',
            status='info',
            
            selectizeInput(
              inputId='Airline_box_hour',
              label="Select Airlines",
              choices=unique(Flight_df$AIRLINE ),
              selected='American'
            ) #end selectize
          )#end of box
        ) #end of column
      )#end of fluidrow
     ),#end of tab item
    

  #Tab -time series

  tabItem(
  
    tabName = 'TimeS',
    fluidRow(
      column(
        width=9,
        box(
          title='Frequency of Delays Monthly Trend',
          solidHeader = T,
          status = 'info',
          plotOutput('times_frequency_airline'),
          width = NULL,
          height='auto'
        ) #end of box
    
      ), #end of column
    
      column(
        width=3,
        box(
          title='Select Airlines',
          solidHeader=T,
          width=NULL,
          height='auto',
          status='info',
          checkboxGroupInput(inputId='times_frequency_airline_airline', #this is the input for server
                             label="Select Airlines",
                             choices=unique(Flight_df$AIRLINE),
                             selected='American')
        )#end of box
      ),#end of column
    
    
      column(
        width=9,
        box(
          title='Cost of Delays Monthly Trend',
          solidHeader = T,
          status = 'info',
          plotOutput('times_frequency_airline_cost'),
          width = NULL,
          height='auto'
        ), #end of box
        
      div(
        h5('Cost of Delays is calculated based on the estimated direct aircraft operating cost $74.2 per min'),
        h5('Direct aircraft operating cost info source: https://www.airlines.org/dataset/per-minute-cost-of-delays-to-u-s-airlines/ ')
      )
      ) #end of column
  
    ) #end of fluidrow
  ),#end of tabITem



#Tab--Data Table
  tabItem(
    tabName = 'Data',
    fluidRow(
      column(
        width=12,
        box(
          title='Cleaned Data',
          solidHeader = T,
          status = 'info',
          width = NULL,
          height='auto',
        DT::dataTableOutput('data_table')  
        )
      )
    
    )#end of fluidRow
  )# end of tab item





  )#end of tab Items
  ) #end of dashboard Body
    

    
) #end of dashboard page
)# end of UI
