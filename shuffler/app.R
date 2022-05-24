library(shiny)

colClasses = c("factor", "numeric")
col.names = c("Player", "1")

names <-data.frame(names = c("Gordon","Henry","Januar"))

df <- read.table(text = "",
                 colClasses = colClasses,
                 col.names = col.names)
ui <- fluidPage(
  
  # Application title
  titlePanel("Shuffler"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      textInput("AddPlayer",
                "Add Entry",
                ""),
      actionButton("submit", ("Submit"))
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      actionButton("shuffle", "Shuffle!"),
      tableOutput("racingbars")
    )
  )
)

server <- function(input, output, session) {
  
  df <- reactiveVal(data.frame(Player = character(), 
                               X1 = character()))
  
  observeEvent(input$submit, {
    new_dat <- rbind(df(), data.frame(Player = input$AddPlayer, X1 = ""))
    df(new_dat)
    updateTextInput(session, "AddPlayer", value = "")
  })
  
  output$racingbars <- renderTable({
    df()   
  })
  
  observeEvent(input$shuffle, {
    
    
    session$sendCustomMessage(type = 'testmessage',
                              message = 'Thank you for clicking')
  })
}

# Run the application 
shinyApp(ui = ui, server = server)