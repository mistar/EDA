library(shiny)
library(ggplot2)

source("global.R")

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  # Expression that generates a histogram. The expression is
  # wrapped in a call to renderPlot to indicate that:
  #
  #  1) It is "reactive" and therefore should re-execute automatically
  #     when inputs change
  #  2) Its output type is a plot
  
  output$distPlot <- renderPlot({
    x    <- faithful[, 2]  # Old Faithful Geyser data
    bins <- seq(min(x), max(x), length.out = input$bins + 1)
    
    # draw the histogram with the specified number of bins
    hist(x, breaks = bins, col = 'darkgray', border = 'white')
  })
  
  output$summary <- renderPrint({
    x <- dataSet[,input$feature1]
    summary(x)
  })
  
  output$str <- renderPrint({
    x <- dataSet[,input$feature1]
    str(x)
  })
  
  output$plot <- renderPlot({
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
  
  output$pairPlot <- renderPlot({
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

  output$correlations <- renderPlot({
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