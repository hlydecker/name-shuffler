library(shiny)
library(tidyverse)
library(DT)
library(data.table)

key_listener <-'$(document).keyup(function(e) {
    if (e.key == "ArrowLeft") {
    $("#correct").click();
    }
    if (e.key == "ArrowRight") {
    $("#incorrect").click();
}
});' 

colClasses = c("factor", "numeric")
col.names = c("Name", "1")

#names <-data.frame(names = c("Gordon","Henry","Januar"))

df <- fread("www/names.csv") %>% select(Name) %>% {reactiveValues(data = .)}

ui <- fluidPage(tags$head(tags$script(HTML(key_listener))),
  
  # Application title
  titlePanel("Shuffler"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      textInput("AddName",
                "Add Entry",
                ""),
      actionButton("submit", ("Submit"))
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      actionButton("shuffle", "Shuffle!"),
      DT::dataTableOutput("table")
    )
  )
)

server <- function(input, output, session) {
  
  
  
  observeEvent(input$submit, {
    new_dat <- rbind(df$data, data.frame(Name = input$AddName))
    df$data <- new_dat
    updateTextInput(session, "AddName", value = "")
    fwrite(df$data, "www/new_names.csv") 
  })
  
  # Filter data based on selections
  output$table <- DT::renderDataTable(
    DT::datatable(data = df$data)
  )
  
  observeEvent(input$shuffle, {
    df$data <- df$data %>% slice_sample(prop = 1)
    fwrite(df$data, "www/new_names.csv") 
})
}
# Run the application 
shinyApp(ui = ui, server = server)