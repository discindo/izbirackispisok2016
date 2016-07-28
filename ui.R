library(shiny)

MUN <- read.csv("Voters.csv")
MUN <- MUN[!is.null(MUN$MUN),]

shinyUI(fluidPage(
  
  # Application title
  titlePanel("Спорни гласачи во Македонија.\nИзвор: ДИК, јули 2016"),
  
  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(width = 3,
                 radioButtons(inputId="choose_by",
                              label="Одбери според:",
                              choices=list("Регион", "Општина"),
                              selected="Општина"),
                 conditionalPanel(condition = "input.choose_by == 'Општина'",
                                  selectInput(inputId="Municipality", 
                                              label="Одбери Општина",
                                              choices=levels(MUN$MUN))),
                 conditionalPanel(condition = "input.choose_by == 'Регион'",
                                  selectInput(inputId="Region", 
                                              label="Одбери Регион",
                                              choices=levels(MUN$REG),
                                              selected="Скопски")),
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
