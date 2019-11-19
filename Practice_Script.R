
# Hadley Wickam Examples
#-----------------------

library(shiny)

#----#
# UI
#----#
==

ui <- fluidPage(
  "Hello, world!"
)

#----------#
# SERVER
#----------#

server <- function(input, output, session) {
}



shinyApp(ui, server)



# Adding UI controls

library(shiny)

ui <- fluidPage(
  selectInput("dataset", label = "Dataset", choices = ls("package:datasets")),
  verbatimTextOutput("summary"),
  tableOutput("table")
)

server <- function(input, output, session) {
}


shinyApp(ui, server)

# fluidpage(): Layout function
# selectInput(): Let's the user interact with the app
    # In this case it's a select box with the label "Dataset" and let's you choose the dataset
    

# 2.5 Adding Behaviour

library(shiny)

ui <- fluidPage(
  selectInput("dataset", label = "Dataset", choices = ls("package:datasets")),
  verbatimTextOutput("summary"),
  tableOutput("table")
)

server <- function(input, output, session) {
  output$summary <- renderPrint({
    dataset <- get(input$dataset, "package:datasets")
    summary(dataset)
  })
  
  output$table <- renderTable({
    dataset <- get(input$dataset, "package:datasets")
    dataset
  })
}

shinyApp(ui,server)

# Using ggplot

library(ggplot2)
datasets <- data(package = "ggplot2")$results[, "Item"]


ui <- fluidPage(
  selectInput("dataset", "Dataset", choices = datasets),
  verbatimTextOutput("summary"),
  tableOutput("plot")
)


server <- function(input, output, session) {
  dataset <- reactive({
    get(input$dataset, "package:ggplot2")
  })
  output$summmry <- renderPrint({
    summary(dataset())
  })
  output$plot <- renderPlot({
    plot(dataset)
  })
}

shinyApp(ui,server)














