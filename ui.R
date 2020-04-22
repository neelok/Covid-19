source("global.R")
source("func.R")


ui <- fluidPage(
  
  dashboardPage(
    dashboardHeader(title = "Covid 19 Research Papers"),
    dashboardSidebar(
      sliderInput("num", "Number of words in the plot",
                  min = 10, max = 50, value = 20, step = 5
      ),
      
      selectInput(inputId = "doc", choices = 1:1000, label = "Select the Document"),
      sidebarMenu(
        menuItem("Dashboard", tabName = "dashboard"),
        menuItem("Raw Documents", tabName = "Research Paper")
      )
    ),
    dashboardBody(
      tabItems(
        tabItem("dashboard",
                
                fluidRow(
                  box(
                    width = 6, status = "info", solidHeader = TRUE,
                    title = "Tops Words in the Document",
                    bubblesOutput("bubbles", width = "100%")
                  ),
                  box(
                    width = 6, status = "info", solidHeader = TRUE,
                    title = "Important Words in the Document (Using TFIDF weighting)",
                    bubblesOutput("impBubbles", width = "100%")
                  )
                  
                )
        ),
        tabItem("rawdata",
                numericInput("maxrows", "Rows to show", 25),
                verbatimTextOutput("rawtable"),
                # downloadButton("downloadCsv", "Download as CSV")
        )
      )
    )
  )
  
  
  
)