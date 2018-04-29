library(shiny)

# Read CSV
r <- read.csv("Desktop/piu-songlist-shiny/pumpList.csv", stringsAsFactors = F)

# Start conversion of levels
speed <- r$LEVEL
double <- r$LEVEL
coop <- r$LEVEL
sperformace <- r$LEVEL
dperformace <- r$LEVEL


speed <- gsub("S", "", gsub("\\b\\s*([^S]\\d+|[A-z]{2,}\\d+)\\b", "", speed))
double <- gsub("D", "", gsub("\\b\\s*([^D]\\d+|[A-z]{2,}\\d+)\\b", "", double))
#coop <- gsub("CO", "", gsub("\\b\\s*([^CO]\\d+|[A-z]{2,}\\d+)\\b", "", coop))
#sperformace <- gsub("SP", "", gsub("\\b\\s*([^SP]\\d+|[A-z]{2,}\\d+)\\b", "", sperformace))
#dperformace <- gsub("DP", "", gsub("\\b\\s*([^DP]\\d+|[A-z]{2,}\\d+)\\b", "", dperformace))

r$LEVEL <- speed

# User Interface
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
               selectInput("category", "Category", c("Speed", "Double", "Co-op", "Single Performace", "Double Performace"))
        )
    ),
    
    fluidRow(
        column(12,
            DT::dataTableOutput("table")
        )
    )
)

# Server
server <- function(input, output) {
    output$table <- DT::renderDataTable(DT::datatable({
        if (input$game != "All") {
            r <- r[r$GAME == input$game,]
        }
        if (input$category != "Speed") {
            if(input$category == "Double"){
            	
            }
        	
        	switch (input$category,
        		"Double" = {
        			r$LEVEL <- double
        		},
        		"Co-op" = {
        			r$LEVEL <- coop
        		},
        		"Single Performace" = {
        			r$LEVEL <- dperformace
        		},
        		{
        			r$LEVEL <- sperformace
        		}
			)
        }
        if (input$level != "All") {
        	r <- r[lapply(strsplit(r$LEVEL, " "),function(x) length(grep(paste0("\\b^", input$level, "\\b"), x))) > 0, ]
        }
		r
    }))
}

# Create Shiny app object
shinyApp(ui, server)
