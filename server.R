library(shiny)
library(ggplot2)
wd  = getwd()
savePath = paste0(wd,  "/data/data.csv")
source("helperFunctions.R")

df = createDummyDf()
# df = getSavedData()

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    dfreact  = reactive({
        df = df
    })
    #### Dashboard tab ####
    # InfoBoxes: summary info on applied, in-progress, and to-apply categories
    output$appliedBox <- renderInfoBox({
        infoBox(
            "Total Applied", nrow(filter(df, (! df$status != "new"))), icon = icon("check-circle"),
            color = "teal",
            fill = TRUE
        )
    })
    output$progressBox <- renderInfoBox({
        infoBox(
            "In Progress", getInfoBoxCount(df=df, filterBy="progress"), icon = icon("spinner"),
            color = "olive",
            fill = TRUE
        )
    })
    output$toApplyBox <- renderInfoBox({
        infoBox(
            "New", getInfoBoxCount(df=df, filterBy="new"), icon = icon("exclamation"),
            color = "orange",
            fill = TRUE
        )
    })
    
    # bar plot - grouped by status
    output$statusBarPlot <- renderPlot({
        # group the df based on the status column and get count for each group
        groupByStatusDf = df  %>% 
            group_by(status) %>% 
            summarise(count=n())
        
        print (groupByStatusDf)
        # create barplot for the grouped by status and its count
        ggplot(groupByStatusDf, aes(x=as.factor(status), y=count, fill=as.factor(status))) + 
            geom_bar(stat = "identity") +
            scale_fill_hue(c = 40) +
            theme(legend.position="none") +
            labs(x="Status", y="Count", title="Count by status") +
            theme(plot.title = element_text(hjust = 0.5))
    })
    
    # bar plot - grouped by location
    output$locationBarPlot <- renderPlot({
        # group the df based on the status column and get count for each group
        groupByStatusDf = df  %>% 
            group_by(location) %>% 
            summarise(count=n())
        
        # create barplot for the grouped by status and its count
        ggplot(groupByStatusDf, aes(x=as.factor(location), y=count, fill=as.factor(location))) + 
            geom_bar(stat = "identity") +
            scale_fill_hue(c = 40) +
            theme(legend.position="none") +
            labs(x="Location", y="Count", title="Application count by location") +
            theme(plot.title = element_text(hjust = 0.5))
    })
    
    # df filtered for new statuses only
    newPostDf = createLink(filter(df, status=="new"))
    output$newTable <- renderDataTable((newPostDf), escape = FALSE)
    
    output$newPostMessage = renderText(createNewPostMessage(newPostDf))
    
    #### Update tab ####
    # output$allTable <- DT::renderDataTable((urlLinkAllDf), escape = FALSE)
    output$allTable <- renderRHandsontable({
        rhandsontable(df)
    })
    
    statusOptions = c("new", "applied", "inProgress", "rejected", "offered", "accepted", "declined")
    #Observe event
    observeEvent(input$saveBtn, {
            updatedDf = hot_to_r(input$allTable)
            invalidStatus = updatedDf$status[!updatedDf$status %in% statusOptions]
            print (invalidStatus)
            if (length(invalidStatus) > 0){
                output$invalidStatusUpdateMsg = renderText( paste("Invalid status: it can only be one of", statusOptions))
            } else {
                output$invalidStatusUpdateMsg = renderText("Updated!")
                write.csv(updatedDf, savePath)
                df = updatedDf
            }
        }
    )
    
    observeEvent(input$resetBtn, {
        output$invalidStatusUpdateMsg = renderText(" ")
        output$allTable <- renderRHandsontable({
            rhandsontable(df)
        })
    })
})
