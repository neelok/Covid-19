

server <- function(input, output, session) {
  
  output$bubbles <- renderBubbles({
    
    doc_id <- as.numeric(input$doc)
    makeplot(df_maintext$text[doc_id], input$num)
    
  })
  
  output$impBubbles <- renderBubbles({
    
    doc_id <- as.numeric(input$doc)
    makeImpPlot(corpus = df_main_tf_f, x = input$num, n = doc_id)
    
  })
  
}