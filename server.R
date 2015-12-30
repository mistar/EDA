library(shiny)
library(UsingR)


diabetesRisk <- function(glucose) glucose / 200

shinyServer(
  function(input,output){
    output$oid1 <- renderPrint({input$id1})
    output$oid2 <- renderPrint({input$id2})
    output$odate <- renderPrint({input$date})
    output$inputValue <- renderPrint({input$glucose})
    output$predicition <- renderPrint({diabetesRisk(input$glucose)})
  }
  hist(galton$child)
)