# Load packages
library(shiny)
library(shinythemes)
library(dplyr)
library(readr)

# Define UI
ui <- fluidPage(titlePanel("Credit Risk Application (Predictive Modeling)"),
                theme = shinytheme("darkly"),
              
                sidebarPanel(
                  numericInput(inputId='DURATION', label='Duration', value = NA ,min = 1, max = 100, step = NA, width = NULL),
                  numericInput(inputId='AMOUNT', label='Amount', value = NA,min = 1, max = 20000, step = NA,width = NULL),
                  numericInput(inputId='INSTALL_RATE', label='Installment Rate', value = NA,min = 1, max = 4, step = NA,width = NULL),
                  numericInput(inputId='AGE', label='Age', value = NA, min = 18, max = 100, step = NA,width = NULL),
                  numericInput(inputId='NUM_CREDITS', label='Number of Credits', value = NA, min = 1, max = 4, step = NA,width = NULL),
                  numericInput(inputId='NUM_DEPENDENTS', label='Number of Dependents', value = NA, min = 1, max = 3, step = NA,width = NULL),
                  radioButtons( inputId='CHK_ACCT', label='Status of Checking Account', choiceNames = c("< 0 DM", "> 0 and < 200 DM", "> 200 DM", "No Checking Account"), choiceValues = c(0,1,2,3), selected = NULL, inline = FALSE,width = NULL),
                  radioButtons( inputId='SAV_ACCT', label='Status of Savings Account', choiceNames = c("< 100 DM", "> 100 DM and < 500 DM", "> 500 DM and <1000 DM", ">= 1000DM", "Unknown/no savings account"), choiceValues = c(0,1,2,3,4), selected = NULL, inline = FALSE,width = NULL),
                  radioButtons( inputId='PRESENT_RESIDENT', label='Years of Residency', choiceNames = c("< 1 year", "> 1 year and < 2 years", "> 2 year and < 3 years", "> 3 years and < 4 years"), choiceValues = c(1,2,3,4), selected = NULL, inline = FALSE,width = NULL),
                  radioButtons( inputId='HISTORY', label='Credit History', choiceNames = c("No credits taken, and all credits paid back duly", "All credits at this bank paid back duly", "Existing credits, paid back duly till now", "Delay in paying off in the past", "Critical amount / other credits existing (not at this bank)"), choiceValues = c(0,1,2,3,4), selected = NULL, inline = FALSE,width = NULL)
                ),
                
                fluidRow(column(width = 4, "Select the Purpose of Credit"), 
                         sidebarPanel(
                           radioButtons( inputId='NEW_CAR', label='New car', choiceNames = c("No", "Yes"), choiceValues = c(0,1), selected = NULL, inline = FALSE,width = NULL),
                           radioButtons( inputId='USED_CAR', label='Used car', choiceNames = c("No", "Yes"), choiceValues = c(0,1), selected = NULL, inline = FALSE,width = NULL),
                           radioButtons( inputId='FURNITURE', label='Furniture', choiceNames = c("No", "Yes"), choiceValues = c(0,1), selected = NULL, inline = FALSE,width = NULL),
                           radioButtons( inputId='RADIO_TV', label='Radio or TV', choiceNames = c("No", "Yes"), choiceValues = c(0,1), selected = NULL, inline = FALSE,width = NULL),
                           radioButtons( inputId='EDUCATION', label='Educated', choiceNames = c("No", "Yes"), choiceValues = c(0,1), selected = NULL, inline = FALSE,width = NULL),
                           radioButtons( inputId='RETRAINING', label='Retraining', choiceNames = c("No", "Yes"), choiceValues = c(0,1), selected = NULL, inline = FALSE,width = NULL),
                           hr(),
                           hr(),
                           radioButtons( inputId='CO_APPLICANT', label='Co-Applicant', choiceNames = c("No", "Yes"), choiceValues = c(0,1), selected = NULL, inline = FALSE,width = NULL),
                           radioButtons(inputId='OTHER_INSTALL', label='Has other installment plans', choiceNames = c("No", "Yes"), choiceValues = c(0,1), selected = NULL, inline = FALSE,width = NULL),
                           radioButtons( inputId='GUARANTOR', label='Has Guarantor', choiceNames = c("No", "Yes"), choiceValues = c(0,1), selected = NULL, inline = FALSE,width = NULL),
                           hr(),
                           actionButton("predict", "Make Prediction"),
                           textOutput("text")
                         ),
                         fluidRow(column(width = 4),
                                  sidebarPanel(
                                    radioButtons( inputId='MALE_DIV', label='Divorced or separated male', choiceNames = c("No", "Yes"), choiceValues = c(0,1), selected = NULL, inline = FALSE,width = NULL),
                                    radioButtons( inputId='MALE_SINGLE', label='Single male', choiceNames = c("No", "Yes"), choiceValues = c(0,1), selected = NULL, inline = FALSE,width = NULL),
                                    radioButtons( inputId='MALE_MAR_or_WID', label='Married or widowed male', choiceNames = c("No", "Yes"), choiceValues = c(0,1), selected = NULL, inline = FALSE,width = NULL),
                                    radioButtons(inputId='REAL_ESTATE', label='Owns real estate', choiceNames = c("No", "Yes"), choiceValues = c(0,1), selected = NULL, inline = FALSE,width = NULL),
                                    radioButtons(inputId='PROP_UNKN_NONE', label='Unknown or no property', choiceNames = c("No", "Yes"), choiceValues = c(0,1), selected = NULL, inline = FALSE,width = NULL),
                                    radioButtons(inputId='RENT', label='Housing as rent', choiceNames = c("No", "Yes"), choiceValues = c(0,1), selected = NULL, inline = FALSE,width = NULL),
                                    radioButtons(inputId='OWN_RES', label='Housing as own residence', choiceNames = c("No", "Yes"), choiceValues = c(0,1), selected = NULL, inline = FALSE,width = NULL),
                                    radioButtons( inputId='EMPLOYMENT', label='Employed Since', choiceNames = c("Unemployed", "< 1 year", "> 1 year and < 4 years", "> 4 years and < 7 years", ">= 7 years"), choiceValues = c(0,1,2,3,4), selected = NULL, inline = FALSE,width = NULL),
                                    radioButtons(inputId='JOB', label='Type of job', choiceNames = c("Unemployed/unskilled - non-resident", "Unskilled - resident", "Skilled employee/official", "Management/self-employed/highly qualified employee/officer"), choiceValues = c(0,1,2,3), selected = NULL, inline = FALSE,width = NULL),
                                    radioButtons(inputId='TELEPHONE', label='Has Telephone line', choiceNames = c("No", "Yes"), choiceValues = c(0,1), selected = NULL, inline = FALSE,width = NULL),
                                    radioButtons(inputId='FOREIGN', label='Foreign worker', choiceNames = c("No", "Yes"), choiceValues = c(0,1), selected = NULL, inline = FALSE,width = NULL)
                                  )
                   )
                         
                ))

# Define server function
server <- function(input, output){
  observeEvent(input$predict,{
    DURATION = as.numeric(input$duration)
    AMOUNT = as.numeric(input$amount)
    INSTALL_RATE = as.numeric(input$install_rate)
    AGE = as.numeric(input$age)
    NUM_CREDITS = as.numeric(input$num_credits)
    NUM_DEPENDENTS = as.numeric(input$num_dependents)
    CHK_ACCT = as.factor(input$chk_acct)
    HISTORY = as.factor(input$history)
    SAV_ACCT = as.factor(input$sav_acct)
    EMPLOYMENT = as.factor(input$employment)
    NEW_CAR = as.factor(input$new_car) 
    USED_CAR = as.factor(input$used_car)
    FURNITURE = as.factor(input$furniture)
    RADIO_TV = as.factor(input$radio_tv)
    EDUCATION = as.factor(input$education)
    RETRAINING = as.factor(input$retraining)
    MALE_DIV = as.factor(input$male_div)
    MALE_SINGLE = as.factor(input$male_single)
    MALE_MAR_OR_DIV = as.factor(input$male_mar_or_div)
    CO_APPLICANT = as.factor(input$co_applicant)
    GUARANTOR = as.factor(input$guarantor)
    PRESENT_RESIDENT = as.factor(input$present_resident)
    REAL_ESTATE = as.factor(input$real_estate)
    PROP_UNKN_NONE = as.factor(input$prop_unkn_none)
    OTHER_INSTALL = as.factor(input$other_install)
    RENT = as.factor(input$rent)
    OWN_RES = as.factor(input$own_res)
    JOB =as.factor(input$job)
    TELEPHONE =as.factor(input$telephone)
    FOREIGN =as.factor(input$foreign)
    val_data = data.frame(DURATION = DURATION, AMOUNT = AMOUNT, INSTALL_RATE = INSTALL_RATE, AGE = AGE, NUM_CREDITS = NUM_CREDITS, NUM_DEPENDENTS = NUM_DEPENDENTS, CHK_ACCT = CHK_ACCT, HISTORY = HISTORY,
                          SAV_ACCT = SAV_ACCT, EMPLOYMENT = EMPLOYMENT, NEW_CAR = NEW_CAR, USED_CAR = USED_CAR, FURNITURE = FURNITURE, RADIO_TV = RADIO_TV, EDUCATION = EDUCATION, RETRAINING = RETRAINING,
                          MALE_DIV = MALE_DIV, MALE_SINGLE = MALE_SINGLE, MALE_MAR_or_WID = MALE_MAR_or_WID, CO_APPLICANT = CO_APPLICANT, GUARANTOR = GUARANTOR, PRESENT_RESIDENT = PRESENT_RESIDENT, REAL_ESTATE = REAL_ESTATE,
                          PROP_UNKN_NONE = PROP_UNKN_NONE, OTHER_INSTALL = OTHER_INSTALL, RENT = RENT, OWN_RES = OWN_RES, JOB = JOB, TELEPHONE = TELEPHONE, FOREIGN = FOREIGN)
    
    model = load(file = "model.rda")
    pred = as.character(predict(get(model),val_data,type="class"))
    
    if(pred == "0"){
      output$text <- renderText(
        paste("Bad Applicant")
      )
    }
    if(pred == "1"){
      output$text <- renderText(
        paste("Good Applicant")
      )
    }
  })
}

# Create Shiny object
shinyApp(ui = ui, server = server)