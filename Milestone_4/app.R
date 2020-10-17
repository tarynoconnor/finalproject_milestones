
library(shiny)
library(tidyverse)

superpac_app = readRDS("superpac.RDS")

# Here is my setup for my model, discussion, and about tabs.
ui <- navbarPage(
    "Milestone 4",
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
             p("Right now, I am still working on narrowing down exactly what 
               data I want to use, and am doing plenty of searches on the Federal
               Election Commission website. I have also sent a request for access 
               to OpenSecrets' bulk data. When looking into data sets, I am also
               taking size into account, as some data sets have millions of 
               entries (as they are records of all contributions to campaigns or
               PACS over a given time period). For now, I have focused on a data
               set I downloaded from the FEC detailing all contributions to Super
               PACs from 2019-2020. The data in the model shows the distribution
               of contributions by individuals to super PACs that have received 
               over 1,000 contributions this year. If I were to continue with something 
               related to this model, I could potentially look at changes in
               contributions over the years or compare the highest funded super 
               PACs with election results. However, one issue I have ran into is 
               that on the FEC site, you cannot download more than 500,000 contributions 
               into a single csv file. Instead, you have to download the bulk data, 
               which raises two issues. First, the file may be too large to load into 
               RStudio on my computer. Also, the data is saved in a .txt file, which 
               I'm not sure if it can be formatted into R at all, as when I used 
               read.delim(), for a small .txt file, there is one column for each 
               row containing multiple variables separated by |.")),
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
            
            scale_y_continuous(labels = scales::comma)
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
