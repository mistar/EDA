library(shiny)
library(ggplot2)
library(DT)

source("global.R")

shinyServer(function(input, output,session) {

  selectedData <-  reactive({
    dataSet <- getS3Data(input$s3Object)
    updateSelectInput(session, "feature1", choices = names(dataSet))
    updateSelectInput(session, "feature2", choices = names(dataSet))
    updateSelectInput(session, "feature3", choices = names(dataSet))
    updateSelectInput(session, "feature4", choices = names(dataSet))
    updateSelectInput(session, "feature5", choices = names(dataSet))
    updateSelectInput(session, "feature6", choices = names(dataSet))
    dataSet
  })
  
  #-----------------------------------------------
  output$dataTable <- renderDataTable({

    # input$file1 will be NULL initially. After the user selects
    # and uploads a file, it will be a data frame with 'name',
    # 'size', 'type', and 'datapath' columns. The 'datapath'
    # column will contain the local filenames where the data can
    # be found.
    
#    if(input$origin == 's3'){

#     } else {
#     inFile <- input$file1
#     
#     if (is.null(inFile))
#       return(NULL)
#     
#     dataSet <- read.csv(inFile$datapath, header=input$header, sep=input$sep, 
#              quote=input$quote)
#     }
    selectedData()
  }, options = list(
    lengthMenu = list(c(5, 10, 15, -1), c('5', '10', '15', '50')),
    pageLength = 10
  )
)
  
  #-----------------------------------------------
  output$nrow <- renderText({
    nrow(selectedData())
  })
  #-----------------------------------------------
  output$feature1 <- renderText({
    selectedFeature1()
  })
  
  #-----------------------------------------------
  output$ncol <- renderText({
    ncol(selectedData())
  })
  
     #-----------------------------------------------
  output$summary <- renderPrint({
    dataSet <- selectedData()
    summary(dataSet[,input$feature1])
  })
  
  #-----------------------------------------------
  output$str <- renderPrint({
    dataSet <- selectedData()
    str(dataSet[,input$feature1])
  })
  
  #-----------------------------------------------
  output$plot <- renderPlot({
    dataSet <- selectedData()

    x <- na.omit(dataSet[,input$feature1])
    
    if (input$plotType == "Histogram") {
      hist(x, 
           probability = TRUE, 
           breaks = as.numeric(input$n_breaks),
           xlab = input$feature1, 
           col = "grey",
           main = "")
      abline(v = mean(x), col = "blue", lwd = 2)
      abline(v = median(x), col = "red", lwd = 2)
      legend("topright", c("mean", "median"), col=c("blue", "red"), lwd=10)
      
    } else if (input$plotType == "Box Plot") {
      boxplot(x,
              horizontal = TRUE,
              axes = FALSE,
              col="grey",
              xlab = input$feature1
      )
    } else if (input$plotType == "Dot Plot") {
      dotchart(x, cex=.7,
               xlab=input$feature1)
      
    } else if (input$plotType == "Density") {
      hist(x, 
           probability = TRUE, 
           breaks = as.numeric(input$n_breaks),
           xlab = input$feature1, main = "")
      dens <- density(x, 
                      adjust = input$bw_adjust)
      lines(dens, col = "green")
      abline(v = mean(x), col = "blue", lwd = 2)
      abline(v = median(x), col = "red", lwd = 2)
      legend("topright", c("mean", "median","density"), col=c("blue", "red","green"), lwd=10)
    }
  })
  
  #-----------------------------------------------
  output$pairPlot <- renderPlot({
    dataSet <- selectedData()
    
        if (input$fun == "normal"){
        x <- dataSet[,input$feature1]
        y <- dataSet[,input$feature2]
      } else if (input$fun == "log2"){
        x <- paste("log2(",dataSet[,input$feature1],")",sep="")
        y <- paste("log2(",dataSet[,input$feature2],")",sep="")
      } else if (input$fun == "log10"){
        x <- paste("log10(",dataSet[,input$feature1],")",sep="")
        y <- paste("log10(",dataSet[,input$feature2],")",sep="")
      } else if (input$fun == "^2"){
        x <- paste(dataSet[,input$feature1],"^2",sep="")
        y <- paste(dataSet[,input$feature2],"^2",sep="")
      } else if (input$fun == "^3"){
        x <- paste(dataSet[,input$feature1],"^3",sep="")
        y <- paste(dataSet[,input$feature2],"^3",sep="")
      }
      qplot(x, y, data = dataSet, na.rm=TRUE) +
        stat_smooth()
    })

  #-----------------------------------------------
  output$correlations <- renderPlot({
    dataSet <- selectedData()
    
    x <- dataSet[, c(input$feature1,input$feature2,input$feature3,input$feature4,input$feature5,input$feature6)]
    panel.cor <- function(x, y, digits=2, prefix="", cex.cor)
    {
      usr <- par("usr"); on.exit(par(usr))
      par(usr = c(0, 1, 0, 1))
      r = (cor(x, y))
      txt <- format(c(r, 0.123456789), digits=digits)[1]
      txt <- paste(prefix, txt, sep="")
      if(missing(cex.cor)) cex <- 0.8/strwidth(txt)
      text(0.5, 0.5, txt, cex = cex * abs(r))
    }
    
    pairs(x, lower.panel = panel.smooth, upper.panel = panel.cor)
  })
  
})