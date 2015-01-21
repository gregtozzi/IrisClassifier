library(shiny)
library(rCharts)
library(caret)
library(e1071)
library(randomForest)

inTrain <- createDataPartition(y = iris$Species,
                               p = 0.7,
                               list = FALSE)

trainSet <- iris[inTrain, ]

shinyServer(
        function(input, output) {
                
                output$ui <- renderUI({
                        if(length(input$coVars > 0)) {
                                return(actionButton("Go", label = "Go"))
                        }
                        return(tags$b(style="color:red", "Select one or more covariate."))
                })
                
                output$uiy <- renderUI({
                        availVars <- names(iris)[which(!names(iris)[1:4] %in% input$xaxis)]
                        return(selectInput("yaxis", "Choose y-axis",
                                           choices = availVars,
                                           selected = availVars[1]))
                })
                
                output$uiy2 <- renderUI({
                        availVars <- names(iris)[which(!names(iris)[1:4] %in% input$xaxis2)]
                        return(selectInput("yaxis2", "Choose y-axis",
                                           choices = availVars,
                                           selected = availVars[1]))
                })
                
                output$plot1 <- renderChart2({
                        h1 <- hPlot(y = input$yaxis, x = input$xaxis, data = trainSet(),
                                    type = "scatter",
                                    group = "Species")
                        h1$plotOptions(series = list(marker = list(symbol = "circle")))
                        h1$chart(width = 400)
                        h1
                })
                
                inTrain <- reactive({
                        set.seed(20)
                        createDataPartition(y = iris$Species,
                                            p = input$testTrain / 100,
                                            list = FALSE)
                })
                
                trainSet <- reactive({
                        iris[inTrain(), ]
                })
                
                testSet <- reactive({
                        iris[-inTrain(), ]
                })
                
                xSet <- reactive({
                        trainSet()[, input$coVars]
                })
                
                
                modPredict <- reactive({
                      modFit <- train(x = xSet(), y = trainSet()$Species,
                            method = input$modelMethod)
                      TestS <- testSet()
                      predictRes <- predict(modFit, TestS)
                      newDF <- cbind(TestS, predictRes)
                      names(newDF) <- c(names(iris), "Prediction")
                      return(newDF)
                })
                
                output$plot2 <- renderChart2({
                        if(length(input$coVars) >=2){
                                ModP <- modPredict()
                                h2 <- hPlot(y = input$yaxis2,
                                        x = input$xaxis2,
                                        data = ModP,
                                        type = "scatter",
                                        group = "Prediction"
                                        )
                                falseGroup <- ModP[which(ModP$Species != ModP$Prediction), ]
                                h2$data(y = falseGroup[, input$yaxis2],
                                        x = falseGroup[, input$xaxis2],
                                        type = "scatter",
                                        name = "False Predictions")
                                h2$plotOptions(series = list(marker = list(symbol = "circle", radius = 6)))
                                h2$chart(width = 400)
                                return(h2)}
                        h2 <- Highcharts$new()
                        return(h2)
                })
                
                output$view <- renderTable({
                        if(length(input$coVars) >=2){
                                return(table(modPredict()[,"Species"], modPredict()[,"Prediction"]))
                        }
                        return(NULL)
                })
                
                output$warnMsg <- renderText({
                        if(length(input$coVars) < 2){
                                '<b style="color:red">Please choose at least two covariates</b>'
                        }
                })

        }
        )