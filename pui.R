library(shiny)
library(DT)

# [IMPROVE] Read CSV 
#r <- read.csv("Desktop/piu-songlist-shiny/pumpList.csv", stringsAsFactors = F)
r <- x
# [IMPROVE] Regex 
speed <- gsub("S", "", gsub("\\b\\s*([^S]\\d+|[A-z]{2,}\\d+)\\b", "", r$LEVEL))
double <- gsub("D", "", gsub("\\b\\s*([^D]\\d+|[A-z]{2,}\\d+)\\b", "", r$LEVEL))

# Not working properly
coop <- gsub("CO", "", gsub("\\s*(S\\d+)|\\s*(D\\d+)|\\s*(DP\\d+)|\\s*(SP\\d+)", "", r$LEVEL))
sperformace <- gsub("SP", "", gsub("\\s*S\\d+\\s*|\\s*D\\d+\\s*|\\s*DP\\d+\\s*|\\s*CO\\d+\\s*", "", r$LEVEL))
dperformace <- gsub("DP", "", gsub("\\s*S\\d+\\s*|\\s*D\\d+\\s*|\\s*CO\\d+\\s*|\\s*SP\\d+\\s*", "", r$LEVEL))

# BPM is numeric to organize properly inside ui
r$BPM <- as.numeric(r$BPM)

# Speed is now default case
r$LEVEL <- speed

# User Interface
ui <- fluidPage(
	#style = "background-color: #c0fafc; height:100%",
	
	# Styling
	tags$head(tags$link(rel = "stylesheet", type = "text/css", href = "app.css")),
	
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
    output$table <- renderDataTable(
    		datatable({
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
	    },
			options = list(
				pageLength = 20,
				lengthChange = FALSE
				#dom = 'tip'
			),
			#class = 'cell-border stripe',
			rownames = FALSE
		) 
		#%>% formatStyle(columns = "GAME", target = "row", textAlign = "center")
	)
}

# Create Shiny app object
shinyApp(ui, server)
