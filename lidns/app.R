#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(dplyr)
library(ggplot2)
library(foreign)
library(plotly)
lidns <- read.spss("full dataset.sav")

vars <- names(lidns)[which(unlist(lapply(lidns, is.double)))]
cats <- names(lidns)[which(unlist(lapply(lidns, is.factor)) |unlist(lapply(lidns, is.character)) )]
  
# Define UI for application that draws a histogram
ui <- fluidPage(
   
   # Application title
   titlePanel("Low In Diet and Nutrition dataset"),
   
   # Sidebar with a slider input for number of bins 
   sidebarLayout(
      sidebarPanel(
         selectInput(inputId = "category",label = "Select a category",
                    choices = cats,selected = "BMI.category"),
         selectInput(inputId = "variable",label = "Select a variable",
                     choices = vars,selected = "EnergykJkJ"),
         checkboxInput("by2Groups",label="Group by two categories?",value=FALSE),
         selectInput(input = "category2", label="Select a second grouping variable",
                     choices = cats, selected = "Sex")
      ),
      
      # Show a plot of the generated distribution
      mainPanel(
         plotOutput("distPlot")
         #plotlyOutput("distPlot")
      )
   )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
   
   output$distPlot <- renderPlot({
     #output$distPlotly <- renderPlot({
      # generate bins based on input$bins from ui.R
     
     if (input$by2Groups) df <- data.frame(x=lidns[[input$category]],y=lidns[[input$variable]],z=lidns[[input$category2]])
     else  df <- data.frame(x=lidns[[input$category]],y=lidns[[input$variable]])

     if(input$by2Groups) p <- ggplot(df, aes(x=as.factor(x), y,fill=as.factor(x))) + geom_boxplot() + geom_jitter(width=0.1) + facet_wrap(~z) + xlab(input$category) + ylab(input$variable)
     else p<- ggplot(df, aes(x=as.factor(x), y,fill=as.factor(x))) + geom_boxplot() + geom_jitter(width=0.1) + xlab(input$category) + ylab(input$variable)
     
     #ggplotly(p)
     p
   })
}

# Run the application 
shinyApp(ui = ui, server = server)

