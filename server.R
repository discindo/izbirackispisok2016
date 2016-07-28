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
      ylab("Број на гласачи") 
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
        ggtitle(paste("Број на гласачи по општина во", Reg, "регион", sep= " "))
    } else {
      P + ggtitle(paste("Број на гласачи во општина", Mun, sep= " "))
    }
  })
  
})
