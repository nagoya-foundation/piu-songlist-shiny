library(dplyr)
library(shiny)

r <- read.csv("Desktop/piu-songlist-shiny/pumpList.csv", stringsAsFactors = F)

ui <- fluidPage(
    
    titlePanel("Pump It Up Songlist"),
    
    fluidRow(
        column(4,
               selectInput("game", "Game", append("All", unique(r$GAME)))
        ),
        column(4,
               selectInput("level", "Level", append("All", seq(1:28)))
        ),
        column(4,
               selectInput("category", "Category", c("All", "Speed", "Double", "Co-op"))
        )
    ),
    
    fluidRow(
        column(12,
            DT::dataTableOutput("table")
        )
    )
)

# Define server logic to plot various variables against mpg ----
server <- function(input, output) {
    
    # Filter data based on selections
    output$table <- DT::renderDataTable(DT::datatable({
        # data <- mpg
        # if (input$man != "All") {
        #     data <- data[data$manufacturer == input$man,]
        # }
        # if (input$cyl != "All") {
        #     data <- data[data$cyl == input$cyl,]
        # }
        # if (input$trans != "All") {
        #     data <- data[data$trans == input$trans,]
        # }
        r
    }))
}

shinyApp(ui, server)

