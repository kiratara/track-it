library(shiny)
library(shinydashboard)
library(DT)
library(rhandsontable)


## Header Content
header = dashboardHeader(
    title = "Track Your progress"
)

## Sidebar content
sidebar = dashboardSidebar(
    sidebarMenu(
        menuItem("Quick View", tabName = "dashboard", icon=icon("dashboard")),
        menuItem("Update", tabName = "update", icon = icon("pen")),
        menuItem("Explore", tabName = "explore", icon = icon("wpexplorer")),
        menuItem("Source code", icon = icon("file-code-o"), 
                 href = "https://github.com/rstudio/shinydashboard/")
    )
)

## Body content
body = dashboardBody(
    tags$head(
        tags$link(rel = "stylesheet", type = "text/css", href = "styles.css")
    ),

    tabItems(
        #### DASHBAORD TAB CONTENT ####
        tabItem(
            tabName = "dashboard",
            fluidRow(
                # dynamic infoBoxes, updated in the serverside
                infoBoxOutput("appliedBox"),
                infoBoxOutput("progressBox"),
                infoBoxOutput("toApplyBox")
            ),
            fluidRow(
                box(plotOutput('statusBarPlot', height = 250)),
                box(plotOutput('locationBarPlot', height = 250)),
            ),
            fluidRow(
                   box(title = h4(textOutput('newPostMessage')),
                       dataTableOutput('newTable'),
                       # DT::dataTableOutput("newTable"),
                       width = 12,
                       status = "warning"
                    )
            )
        ),
        
        tabItem(
            tabName = "update",
            fluidRow(
                box(
                    title = "Your applications.",
                    # dataTableOutput('allTable'),
                    rHandsontableOutput("allTable", width = "100%"),
                    br(),
                    actionButton("saveBtn", "Update"),
                    actionButton("resetBtn", "Reset"),
                    br(),
                    textOutput("invalidStatusUpdateMsg"),
                    width = 12,
                    status = "primary"
                )
            )
        ),
        
        #### EXPLORE tab content ####
        tabItem(
            tabName = "explore",
            h2("Placeholder page for explore:"),
        )
    )
)

## dashboard with header, sidebar, and the body with all tabs and content
dashboardPage(
    header, 
    sidebar, 
    body)
