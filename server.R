library(shiny)
library(dplyr)
library(ggplot2)
library(RColorBrewer)

MUN <- read.csv("mun1.csv")
MUN <- MUN[!is.null(MUN$MUN)]
MUN$Age <- 2016 - MUN$YoB
MUN$Region <- as.factor(sample(x = LETTERS, size=nrow(MUN), replace = TRUE))

shinyServer(function(input, output) {
  
  # filter based on selected species
  
  getData <- reactive({
    if (input$choose_by == "Municipality") {
      D <- MUN %>% dplyr::filter(MUN==input$Municipality)
    } else {
      D <- MUN %>% dplyr::filter(Region==input$Region)
    }
    return(D)
  })
  
  makePlot <- reactive({
    D <- getData()
    # draw a barplot 
    P <- ggplot(D, aes(x=Age)) +
      geom_histogram(bins=50, fill="orange") +
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
    Reg <- unique(D$Region)
    
    if (length(unique(D$MUN)) > 1) {
      P +# facet_grid(MUN ~ ., scales="free") + 
        ggtitle(paste("Број на гласачи по општина во регион", Reg, sep= " "))
    } else {
      P + ggtitle(paste("Број на гласачи во општина ", Mun, sep= " "))
    }
  })
  
})
