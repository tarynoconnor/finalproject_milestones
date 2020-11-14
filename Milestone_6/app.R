
library(shiny)
library(tidyverse)

superpac_app = readRDS("superpac.RDS")

# Here is my setup for my model, discussion, and about tabs.
ui <- navbarPage(
    "Milestone 6",
    tabPanel("Model",
             fluidPage(
                 titlePanel("Individual Contributions to Super PACS with > 
                            1,000 Contributions in 2020"),
                 sidebarLayout(
                     sidebarPanel(
                         selectInput("committee",
                                     "Super PAC:",
                                     choices = superpac_app$committee_name,
                                     selected = " ")),
                     mainPanel(
                         plotOutput("distPlot")))
             )),
    tabPanel("Discussion",
             titlePanel("Discussion"),
             p("Right now, I am working on downloading FEC total contribution data from
             senate and presidential campaigns from several election cycles. I 
             plan to clean up this data and use election result data to possibly
             generate a model involving the relationship between campaign
             contributions and election outcomes. I am also looking at data from
             the MIT Election Lab and the Database on Ideology, Money in Politics, 
             and Elections.")),
    tabPanel("About",
             titlePanel("About"),
             h3("About Me"),
             p("My name is Taryn O'Connor and I study Applied Mathematics.
               You can reach me at tarynoconnor@college.harvard.edu."),
             h3("Repository Link"),
             p("https://github.com/tarynoconnor/milestone4.git")
    ))


# Define server logic required to draw a histogram
server <- function(input, output) {
    
    output$distPlot <- renderPlot({
        superpac_app %>% 
            filter(committee_name == input$committee) %>% 
            
            # In order to get the months on the graph in order, I used factor() and set levels
            # equal to the first 9 entries in month.name
            
            ggplot(aes(x = factor(months, levels = month.name[1:9]), 
                       y = month_sum)) +
            geom_col() +
            labs(x = "Month", y = "Total Contributions (USD)") +
            
            # I used labels = scales::comma to get commas on the y axis
            
            scale_y_continuous(labels = scales::comma) +
            theme(text = element_text(size = 20), 
                  axis.text = element_text(size = 15), 
                  axis.title = element_text(size = 20,face = "bold"))
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
