library(shiny)

MUN <- read.csv("mun1.csv")
MUN <- MUN[!is.null(MUN$MUN)]
MUN$Age <- 2016 - MUN$YoB
MUN$Region <- as.factor(sample(x = LETTERS, size=nrow(MUN), replace = TRUE))

shinyUI(fluidPage(
  
  # Application title
  titlePanel("Гласачи во Македонија"),
  
  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(width = 3,
                 radioButtons(inputId="choose_by",
                              label="Choose by:",
                              choices=list("Region", "Municipality"),
                              selected="Municipality"),
                 conditionalPanel(condition = "input.choose_by == 'Municipality'",
                                  selectInput(inputId="Municipality", 
                                              label="Select Municipality",
                                              choices=levels(MUN$MUN))),
                 conditionalPanel(condition = "input.choose_by == 'Region'",
                                  selectInput(inputId="Region", 
                                              label="Select Region",
                                              choices=levels(MUN$Region),
                                              selected="Macedonia")),
                 wellPanel(style = "background-color: #ffffff;",
                           h4("About"),
                           tags$div("")
                 )
                 ),
    
    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("barPlot"),
      tags$br(),
      wellPanel()
    )
    
)
))
