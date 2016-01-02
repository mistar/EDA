library(shiny)
source("global.R")

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Exploratory Data Analysis"),
  
  # Sidebar with a slider input for the number of bins
  sidebarLayout(
    sidebarPanel(
      #-----------------------------------------------
      conditionalPanel(
        condition = "input.datatabs == 'Data'",  
        
        #           radioButtons('origin', 'Data Origin',
        #                        c(s3 = 'AWS S3',
        #                          dir ='File direcotry on AWS'),
        #                        'AWS S3'),
        
        selectInput('s3Object', 
                    label = 'Select s3 object:', 
                    choices = listS3Objects())
        #,
        #           fileInput('file1', 'Choose CSV File',
        #                     accept=c('text/csv', 
        #                              'text/comma-separated-values,text/plain', 
        #                              '.csv')),
        #           
        #           tags$hr(),
        #           
        #           checkboxInput('header', 'Header', TRUE),
        #           
        #           radioButtons('sep', 'Separator',
        #                        c(Comma=',',
        #                          Semicolon=';',
        #                          Tab='\t'),
        #                        ','),
        #           
        #           radioButtons('quote', 'Quote',
        #                        c(None='',
        #                          'Double Quote'='"',
        #                          'Single Quote'="'"),
        #                        '"')
      ), #conditionalPanel
      #-----------------------------------------------
      
      conditionalPanel(
        condition = "input.datatabs != 'Data'",   
        selectInput('feature1', 
                    label = 'Feature:', 
                    choices = names(dataSet)
        )
      ), #conditionalPanel
      
      #-----------------------------------------------
      conditionalPanel(
        condition = "input.datatabs == 'Pairs' | input.datatabs == 'Correlations'",   
        selectInput('feature2', 
                    label = 'Second feature:', 
                    choices = names(dataSet),
                    selected = names(dataSet)[1])
      ), #conditionalPanel
      
      #-----------------------------------------------
      conditionalPanel(
        condition = "input.datatabs == 'Correlations'",   
        selectInput('feature3', 
                    label = 'Third feature:', 
                    choices = names(dataSet),
                    selected = names(dataSet)[3]),
        selectInput('feature4', 
                    label = 'Forth feature:', 
                    choices = names(dataSet),
                    selected = names(dataSet)[4]),
        selectInput('feature5', 
                    label = 'Fifth feature:', 
                    choices = names(dataSet),
                    selected = names(dataSet)[5]),
        selectInput('feature6', 
                    label = 'Sixth feature:', 
                    choices = names(dataSet),
                    selected = names(dataSet)[6])
        
      ), #conditionalPanel
      
      #-----------------------------------------------
      conditionalPanel(
        condition = "input.datatabs == 'Pairs'",   
        selectInput('fun', 
                    label = 'Function:', 
                    c("normal", "log2","log10","^2","^3"))
      ), #conditionalPanel
      
      
      #-----------------------------------------------
      conditionalPanel(
        condition = "input.datatabs == 'Feature'",   
        selectInput("plotType", 
                    label = "Type of the plot:",
                    choices = c("Histogram", "Box Plot",
                                "Dot Plot","Density")
        )
      ), #conditionalPanel
      
      #-----------------------------------------------
      
      conditionalPanel(
        condition = ("(input.plotType == 'Histogram' | input.plotType == 'Density' ) & input.datatabs == 'Feature'"),
        
        sliderInput("n_breaks",
                    label =  "Bins:",
                    min = 1,
                    max = 50,
                    value = 20)
      ), #conditionalPanel
      
      #-----------------------------------------------
      conditionalPanel(
        condition = ("input.plotType == 'Density' & input.datatabs == 'Feature'"),
        
        sliderInput("bw_adjust", 
                    label = "Bandwidth adjustment:",
                    min = 1, 
                    max = 20, 
                    value = 5, 
                    step = 1)
      ) #conditionalPanel
      
    ), # sidebarPanel
    
    #--------------------------------------------------------------------------------------------------------------------------
    #--------------------------------------------------------------------------------------------------------------------------
    
    # Show a plot of the generated distribution
    mainPanel(
      tabsetPanel(id = "datatabs",
                  tabPanel("Data", 
                           fluidRow(
                             column(2,
                                    h6("Number of Rows:"),
                                    textOutput("nrow")
                             ),
                             column(2,
                                    h6("Number of Columns:"),
                                    textOutput("ncol")
                             )
                           ),                           
                           
                           h6("Data:"),
                           dataTableOutput('dataTable')
                           
                  ), #tabPanel
                  
                  #-----------------------------------------------
                  tabPanel("Feature",
                           fluidRow(
                             column(4,
                                    h6("Summary:"),
                                    textOutput("summary")
                             ),
                             column(8,
                                    h6("Str:"),
                                    textOutput("str")
                             )
                           ),
                           
                           plotOutput("plot")
                  ), #tabPanel
                  #-----------------------------------------------
                  
                  tabPanel("Pairs", 
                           
                           h6("If the plot is not revealing enough clarity on the relationship you might want to apply a function on the original data to get clearer shape of the distribution."),
                           
                           plotOutput("pairPlot")
                  ), #tabPanel
                  #-----------------------------------------------
                  
                  
                  tabPanel("Correlations", 
                           
                           h6("Explore the correlations for any combination of 6 features."),
                           
                           plotOutput("correlations")
                  ) #tabPanel
      ) #tabsetPanel
    ) # mainPanel
  ) # sidebarLayout
)) # shinyUI