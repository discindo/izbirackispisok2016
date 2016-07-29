library(shiny)

MUN <- read.csv("Voters.csv")
MUN <- MUN[!is.null(MUN$MUN),]

shinyUI(fluidPage(
  
  # Application title
  titlePanel("Спорни гласачи во Македонија. Извор: ДИК, јули 2016"),
  
  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(width = 4,
                 radioButtons(inputId="details",
                              label="",
                              choices=list("Цела Македонија","Региони и Општини"),
                              selected="Цела Македонија"),
                 conditionalPanel(condition = "input.details == 'Региони и Општини'",
                   radioButtons(inputId="choose_by",
                                label="Одбери според:",
                                choices=list("Регион", "Општина"),
                                selected="Регион"),
                   conditionalPanel(condition = "input.choose_by == 'Општина'",
                                    selectInput(inputId="Municipality", 
                                                label="Одбери Општина",
                                                choices=levels(MUN$MUN))),
                   conditionalPanel(condition = "input.choose_by == 'Регион'",
                                    selectInput(inputId="Region", 
                                                label="Одбери Регион",
                                                choices=levels(MUN$REG),
                                                selected="Скопски"))
                   ),
                 wellPanel(style = "background-color: #ffffff;",
                           h4("За"),
                           tags$div("Визуелизација на спорните гласачи од", tags$a(href="http://www.sec.mk/", "списокот објавен од страна на Државната изборна комисија во јули 2016.")),
                           tags$div("Податоците се групирани по општини и по региони. Град Скопје е извдоен посебно од Скопскиот регион. Недостасуваат 6 записи за кои
                                    има вредости NULL за општини во оригиналните податоци."),
                           tags$div("Оригиналните податоци се достапни", tags$a(href="https://drive.google.com/file/d/0B8ZpCwro9h-zcmtheXlEOGRsaHc/view", 'тука.'))
                    )
                 ),
        
        # Show a plot of the generated distribution
    mainPanel(width = 8,
      plotOutput("barPlot"),
      tags$br(),
      dataTableOutput("Table")
    )
  )
))
