library(shiny)
library(ggplot2)
suppressPackageStartupMessages(library(googleVis))
# x<-read.delim("nccos_chem_data_RI_ALL.txt", stringsAsFactors=FALSE)  
# input_ID <- readRDS("chem_list.rds")
# yrs <- readRDS("yrs.rds")
input_ID <- readRDS("chem_list_rima.rds")
yrs <- readRDS("yrs_rima.rds")
#
shinyUI(
        tabsetPanel("Water Pollution Shiny Application",
                tabPanel("Water Pollution Documentation", fluidPage(fluidRow(includeHTML("prompt.html")))),   
                tabPanel("Water Pollution Application",              
        
        fluidPage(
  # Application Title
        titlePanel ("Chemical Based Water Pollution", windowTitle="New England Chemical Pollution"),
        #         
               fluidRow(column(6, plotOutput('lineplot')), column(6, htmlOutput('mapplot'))),          
               fluidRow(column(4,   
                  selectInput('parameter_id', "Please select a chemical parameter", input_ID, selected="Mercury")),
                  column(4,
                  selectInput('yr_id', 'Please Select a Year', yrs, selected=2011)),
                  column(4, br(),
                  submitButton("Submit"))
                  ),
             br(),
             fluidRow(column(12, textOutput('search_msg'))),
             fluidRow(column(12,tableOutput('table_id')))
 ))))