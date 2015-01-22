library(shiny)
library(rCharts)

#shinyUI(fluidPage(theme = "css/cosmo.css",

shinyUI(fluidPage(
        
        # Application title
        titlePanel("Iris Classifier"),
        
        fluidRow(
                column(12,
                       h4("Overview"))),
        
        fluidRow(
                 column(6,
                        p("Your goal is to identify species of irises based on physical measurements. This app provides access to two methods of solving this classification problem: random forests and regression trees. Follow the step-by-step directions below to select a training set, build a machine learning model, and apply the model to the test set."))),
        
        fluidRow(
                column(12,
                h4("1. Build and Explore the Training Set"))),
        
        fluidRow(
                column(3,
                        p("Start by dividing the iris data into a test set and a training set using the slider. Explore the training set using the pull down menus to set the plot's x- and y-axes.")),
                column(3,
                        sliderInput("testTrain",
                                label = "Percent of data to use as a training set",
                                min = 50,
                                max = 80,
                                value = 70),
                        selectInput("xaxis",
                                label = "Choose x-axis",
                                choices = names(iris)[-5],
                                selected = names(iris)[1]),
                        uiOutput("uiy")),
                column(6,
                        showOutput("plot1", "highcharts"))
        ),
        
        fluidRow(
                
                column(12,
                        h4("2. Pick Covariates and Choose Model Settings"))
        ),
        
        fluidRow(
                
                column(3,
                        p("Now that you've taken a look at the training set, consider which covariates are most likely to produce a good classification model.")),
                column(3,
                        div("Not sure which model to choose? Each model type offers advantages and disadvantages. If you need some background, consider Wikipedia's articles on", a(href="http://en.wikipedia.org/wiki/Decision_tree_learning", "decision trees"), "and", a(href="http://en.wikipedia.org/wiki/Random_forest", "random forests."))),
                column(6,
                        htmlOutput("warnMsg"),
                        selectizeInput(inputId = "coVars",
                                label = "Choose covariates",
                                choices = names(iris[, 1:4]),
                                selected = names(iris[, 1:4]),
                                multiple = TRUE,
                                options = list(plugins = I("['remove_button']"))
                        ),
                        radioButtons("modelMethod",
                                label = "Choose a method",
                                choices = list("Regression Tree" = "rpart",
                                               "Random Forest" = "rf")))
                
                
                ),
        
        fluidRow(
                
                column(12,
                       h4("3. Evaluate your model's performance"))),
        
        fluidRow(
                
                column(2,
                       p('The scatterplot shows the test set. The flowers that your model misclassified are highlighted with large orange dots. You can change how the covariates are plotted against one another to see where the model did well and where it ran into challenges. You can also toggle the orange dots on and off by clicking "False Predictions" in the legend')),
                column(4,
                       selectInput("xaxis2", label = "Choose x-axis",
                                   choices = names(iris)[1:4],
                                   selected = names(iris[1])),
                       uiOutput("uiy2"),
                       tableOutput("view"),
                       p("The table gives a detailed breakdown of the model's performance.")),
                column(6,
                       showOutput("plot2", "highcharts")))
        

))

