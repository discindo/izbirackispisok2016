library(shiny)
library(dplyr)
library(ggplot2)
library(RColorBrewer)
library(gridExtra)

MUN <- read.csv("Voters.csv")
MUN <- MUN[!is.null(MUN$MUN),]

shinyServer(function(input, output) {

  # filter based on selected minicipality
  getData <- reactive({
    if (input$choose_by == "Општина") {
      D <- MUN %>% dplyr::filter(MUN==input$Municipality)
    } else {
      D <- MUN %>% dplyr::filter(REG==input$Region)
    }
    return(D)
  })
    
  # macedonia or municipalities
  getScale <- reactive({
    if (input$details == "Цела Македонија") {
      D <- MUN
    } else {
      D <- getData()
    }
    return(D)
  })
  
  makePlot <- reactive({
    D <- getScale()
    # draw a barplot 
    P <- ggplot(D, aes(x=AGE)) +
      geom_histogram(bins=30, fill="firebrick1", colour="white") +
      theme_bw() +
      xlab("Возраст") +
      ylab("Број на спорни гласачи") +
      scale_x_continuous(limits=c(18,100), breaks=seq(18, 100, 4))
      
    return(P)
  })
  
  makeBox <- reactive({
    D <- getScale()
    if (length(unique(D$REG)) > 1 && length(unique(D$MUN)) > 1) { 
      P <- ggplot(D, aes(y=AGE, x=REG, group=REG, fill=REG)) +
        geom_violin() + 
        scale_fill_brewer("Регион",
                          breaks=levels(D$REG),
                          labels=levels(D$REG),
                          palette = "Reds")
      } else {
      P <- ggplot(D, aes(y=AGE, x=MUN, group=MUN, fill=MUN)) +
        geom_violin() +
        scale_fill_brewer("Општина", 
                        breaks=levels(D$MUN),
                        labels=levels(D$MUN),
                        palette = "Reds")
    }
    
    P <- P +
      theme_bw() +
      xlab("") +
      ylab("Возраст на спорни гласачи") +
      scale_y_continuous(limits=c(18,100), breaks=seq(18, 100, 4)) +
      theme(axis.text.x=element_text(angle=45,hjust = 1, vjust = 1),
            legend.position="none") 
    
    return(P)
  })
  

  # make titles
  plotTitle <- reactive({
    D <- getScale()
    Mun <- unique(D$MUN)
    Reg <- unique(D$REG)
    
    if (length(unique(D$REG)) > 1 && length(unique(D$MUN)) > 1) {
      P + ggtitle(paste("Број на спорни гласачи возраст во Македонија", sep= " "))
    } else if (length(unique(D$MUN)) > 1) {
      P + ggtitle(paste("Број на спорни гласачи возраст во", Reg, "регион", sep= " "))
    } else {
      P + ggtitle(paste("Број на спорни гласачи по возраст во општина", Mun, sep= " "))
    }
  return(P)    
  })

# render the plot    
  output$barPlot <- renderPlot({
    P <- makePlot()
    P1 <- makeBox()
    
    grid.arrange(P, P1, ncol=2)
  })
  
  # render a data summary
  output$Table <- renderDataTable({
    D <- getScale()[,2:5]
    D <- data.frame(D$YoB, D$AGE, D$REG, D$MUN)
    colnames(D) <- c("Година на раѓање", "Возраст", "Регион", "Општина")
    return(D)
  }, options = list(lengthMenu = c(5, 30, 50), pageLength = 5))
  
  # order the municipalities with suspect voters within an age range
  # helper function
  getPercentOfAge <- function(DataFrame=D, AgeRange=AgeRange) {
    teens <- DataFrame %>% filter(AGE %in% AgeRange) %>% group_by(REG, MUN) %>% summarise_each(funs(length(.)), AGE)
    all <- DataFrame %>% group_by(REG, MUN) %>% summarise_each(funs(length(.)), AGE)
    Match1 <- all$MUN %in% teens$MUN
    all2 <- all[Match1,] 
    teens$Percent <- 100/(all2$AGE/teens$AGE)
    teens$Total <- all2$AGE
    teens <- teens %>% ungroup %>% 
      arrange(desc(Percent))
    return(teens)
  }
  
  output$Table1 <- renderDataTable({
    D <- MUN
    AgeRange <- input$AgeRange
    Tbl <- getPercentOfAge(DataFrame = D, AgeRange = AgeRange)
    Tbl <- data.frame(Tbl$REG, Tbl$MUN, Tbl$Percent, Tbl$Total) 
    Tbl[,3] <- round(Tbl[,3], 2)
    colnames(Tbl) <- c("Регион", "Општина", "Процент во одбрана возраст", "Вкупно во општина")
    return(Tbl)
    
  }, options = list(lengthMenu = c(5, 10, 20), pageLength = 5))
  
})  
