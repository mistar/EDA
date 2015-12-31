library(shiny)
source("global.R")

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Exploratory Data Analysis"),
  
  # Sidebar with a slider input for the number of bins
  sidebarLayout(
    sidebarPanel(
      inputPanel(
        conditionalPanel(
          condition = "input.datatabs == 'Initialization'",   
          selectInput('s3Objects', 
                      label = 'Select s3 object:', 
                      choices = listS3Objects())
        ),

                selectInput('feature1', 
                    label = 'First feature:', 
                    choices = names(dataSet)
        ),
        
        conditionalPanel(
          condition = "input.datatabs == 'Plotting Pairs' | input.datatabs == 'Correlations'",   
          selectInput('feature2', 
                      label = 'Second feature:', 
                      choices = names(dataSet),
                      selected = names(dataSet)[1])
        ),
        
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
          
        ),
        
        conditionalPanel(
          condition = "input.datatabs == 'Plotting Pairs'",   
          selectInput('fun', 
                      label = 'Function:', 
                      c("normal", "log2","log10","^2","^3"))
        ),
        
        
        conditionalPanel(
          condition = "input.datatabs == 'Plotting single feature'",   
          selectInput("plotType", 
                      label = "Type of the plot:",
                      choices = c("Histogram", "Box Plot",
                                  "Dot Plot","Density")
          )
        ),
        
        
        conditionalPanel(
          condition = "input.plotType == 'Histogram'",
          
          sliderInput("n_breaks",
                      label =  "Bins:",
                      min = 1,
                      max = 50,
                      value = 20)
        ),
        
        conditionalPanel(
          condition = "input.plotType == 'Density'",
          
          sliderInput("n_breaks",
                      label =  "Bins:",
                      min = 1,
                      max = 50,
                      value = 20),
          
          sliderInput("bw_adjust", 
                      label = "Bandwidth adjustment:",
                      min = 1, 
                      max = 100, 
                      value = 20, 
                      step = 1)
        )
        
      ) # inputPanel
    ), # sidebarPanel
    
    # Show a plot of the generated distribution
    mainPanel(
      tabsetPanel(id = "datatabs",
                  tabPanel("Initialization", 
                           wellPanel(
                             h6("Data set:")
                           )
                  ),
                  
                  tabPanel("Statistics",
                           wellPanel(
                             h6("Number of Rows:"),
                             nrow(dataSet),
                             
                             h6("Number of Columns:"),
                             ncol(dataSet),
                             
                             h6("Column names:"),
                             lapply(names(dataSet), function (x) paste(x, " -- ", sep=" ")),
                             
                             h6("Summary for the selected feature:"),
                             textOutput("summary"),
                             
                             h6("---"),
                             textOutput("str")
                           )
                  ),
                  tabPanel("Plotting single feature", 
                           
                           plotOutput("plot")),
                  tabPanel("Plotting Pairs", 
                           
                           h6("If the plot is not revealing enough clerity on the relationship you might want to apply a function on the original data to get clearer shape of the distribution."),
                           
                           plotOutput("pairPlot")),
                  
                  tabPanel("Correlations", 
                           
                           h6("Explore the correlations for any combination of 6 features."),
                           
                           plotOutput("correlations"))
                  
      ) # tabsetPanel
    ) # mainPanel
  ) # sidebarLayout
)) # shinyUI