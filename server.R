library(shiny)
library(ggplot2)
library(dplyr)
suppressPackageStartupMessages(library(googleVis))
x<-readRDS("nccos_chem_data_rima.rds")

pcnt_tot <- NULL
tip <- NULL

shinyServer(
        function(input, output) {
observe({
                
            parm_unit <- reactive(paste("Parameter Level",x[x$Parameter==input$parameter_id & x$Fiscal.Year==input$yr_id,15]))  

            plot_title <- reactive(paste(input$yr_id, input$parameter_id, "Levels"))
                                        
                map_tbl <- reactive({
                        tmp <- x[x$Parameter==input$parameter_id & x$Fiscal.Year==input$yr_id,c(3,4,5,8,9,10,13,14,15,17)]
                        tip <- NULL
                      if (nrow(tmp) > 0) {     
                        for(i in 1:length(tmp$Value)) tip <- c(tip, paste(tmp[i,2], "-", tmp[i,8]))              
                      y1<-data.frame("locationvar"=tmp[,10],"tipvar"=tip)
                      }else{
                        y1<-data.frame("locationvar"=tmp[,10],"tipvar"=tmp[,9])      
                      }
                      return(y1)
              })
              
             search_res <- reactive({
                     srch_tmp <- x[x$Parameter==input$parameter_id & x$Fiscal.Year==input$yr_id,c(3,4,5,8,9,10,13,14,15,17)]    
               if(nrow(srch_tmp) > 0) {
                       for(i in 1:length(srch_tmp[,8])) pcnt_tot <- c(pcnt_tot, round(srch_tmp[i,8]/sum(srch_tmp[,8])*100,1))
               data.frame(srch_tmp[,1:8],"Percent"=pcnt_tot,"Unit"=srch_tmp[,9],"Location"=srch_tmp[,10])
               }else{
                  return(srch_tmp)     
               }
         })

             output$lineplot <- renderPlot(ggplot(data=search_res(), aes(x=Specific.Location, y=Value)) + 
                                                         geom_bar(stat="identity", width=.5, fill="blue") + 
                                                         xlab("Specific Location - ") + 
                                                         ylab(parm_unit())+ggtitle(plot_title())+
                                                         theme(plot.title = element_text(lineheight=.8, face="bold"), axis.text.x  = element_text(angle=90, vjust=0.5, size=16)))
#   
# 
                if (nrow(search_res()) > 0) {
                        output$search_msg <- renderText(c("Your search returned ", nrow(search_res()), " records."))
                } else output$search_msg <- renderText("Your seach didn't return any records, please try to change the year or parameter.")      
  
                   output$table_id <-renderTable(search_res())
#                     
                    output$mapplot <- renderGvis(gvisMap(map_tbl(), locationvar='locationvar', tipvar='tipvar'))


        }) 

})
