library(shiny)
library(dplyr)
library(ggplot2)
library(RColorBrewer)

MUN <- read.csv("Voters.csv")
MUN <- MUN[!is.null(MUN$MUN),]

shinyServer(function(input, output) {
  
  # filter based on selected species
  
  getData <- reactive({
    if (input$choose_by == "Општина") {
      D <- MUN %>% dplyr::filter(MUN==input$Municipality)
    } else {
      D <- MUN %>% dplyr::filter(REG==input$Region)
    }
    return(D)
  })
  
  makePlot <- reactive({
    D <- getData()
    # draw a barplot 
    P <- ggplot(D, aes(x=AGE)) +
      geom_histogram(bins=30, fill="firebrick1", colour="white") +
      theme_bw() +
      xlab("Возраст") +
      ylab("Број на спорни гласачи") +
      scale_x_continuous(limits=c(18,100), breaks=seq(18, 100, 4))
      
    return(P)
  })
  
  # render the plot  
  output$barPlot <- renderPlot({
    P <- makePlot()
    D <- getData()
    Mun <- unique(D$MUN)
    Reg <- unique(D$REG)
    
    if (length(unique(D$MUN)) > 1) {
      P +# facet_grid(MUN ~ ., scales="free") + 
        ggtitle(paste("Број на спорни гласачи возраст во", Reg, "регион", sep= " "))
    } else {
      P + ggtitle(paste("Број на спорни гласачи по возраст во општина", Mun, sep= " "))
    }
  })
  
  # render a data summary
  output$Table <- renderDataTable({
    D <- getData()[,2:5]
    D <- data.frame(D$YoB, D$AGE, D$REG, D$MUN)
    colnames(D) <- c("Година на раѓање", "Возраст", "Регион", "Општина")
    return(D)
  },)
  
  
})
