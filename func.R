
#
# Cleans up the text but doesnt rearranges anything
#


cleanText <- function(text){
    # Remove functuation marks
    text <- str_replace_all(text, pattern = "[:punct:]", replacement = " ")
    
    # Remove numbers unless they are part of other charater like 21-Moleculte
    text <- str_replace_all(text, pattern = "[:alnum:]*[:digit:]+[:alnum:]*", replacement = "")
    
    # Replace Texts that are in brackets mostly refering to authors and other special symbols
    text <- str_replace_all(string = text, pattern = "\\([[:alnum:][:space:]]+\\)", replacement = "")
    
    # Bring the texts to lower case
    text <- tolower(text)
    
    
    # remove stop words
    test.data.df <- unlist(str_split(text, pattern = " "))
    test.data.df <- data.frame(word = test.data.df, stringsAsFactors = FALSE)
    test.data.df.clean <- anti_join(test.data.df, stop_words, by = "word")
    text <- paste(test.data.df.clean$word, collapse = " ")
    
    # remove extra whote space between the characters
    text <- str_replace_all(text, pattern = "[[:space:]]{2,}", replacement = " ")
    
    
    return(text)
}

#
# Build a function that will take the text and calculate top 25 words and 
# find out 2 left and 2 right words
#

context <- function(corpus,text){
  pattern_ <- paste0("([:alnum:]+) ([:alnum:]+) ", text, " ([:alnum:]+) ([:alnum:]+)")
  test <- str_match_all(corpus, pattern = pattern_)
  test <- paste(test[[1]][,1], collapse = "  <>  ")
  
  return(test)
}


#
# Build a function to grab top x most frequent words of the documents
#

topX <- function(corpus, x = 20, stop_vec = "copyright"){
  
  df <- freq_terms(corpus, top = x, stopwords = stop_vec)[1:x,]

  return(df)
}


makeplot <- function(corpus, x =20){

  df <- topX(corpus, x)
  col <- brewer.pal(5, "Dark2")
  ref <- collectRefs(corpus, x)
  bubbles(label = df$WORD, value = df$FREQ, 
          color = col, tooltip = ref)

}

collectRefs <- function(corpus, x= 20){
  
  df <- topX(corpus, x)
  txt <- c()
  for(i in 1:nrow(df)){
    this <- context(corpus, df$WORD[i])
    txt <- c(txt, this)
    
  }
  return(txt)
  
}

## Input data frame in coorect format col containing text  be names text and then there has to be a column 

fit_Idf <- function(df_corpora){
  unn <- unnest_tokens(df_corpora, output = word, input = text) %>% 
    count(doc_id, word, sort = TRUE) %>% bind_tf_idf(term = word, document = doc_id, n = n)
  return(unn)
  
}

## to fit lda on a corpora

fit_LDA <- function(corpora, x=2, train = "beta"){

# to make dtm from data frame the input data frame has to be in a prescribed format
# col1 to be doc_id and col2 is text
# there cann be any empty row in text columns else lda will throw as error
  library(topicmodels)
  library(tidytext)
  mod <- DocumentTermMatrix(VCorpus(DataframeSource(corpora))) %>% LDA(k =x,
                                                                       method = "gibbs",
                                                                       control = list(alpha=1,
                                                                                      delta=0.1,
                                                                                      seed =1234))

  return(tidy(mod, matrix = train))

}

pickId <- function(df, n){
  all <- unique(df$doc_id)
  return(all[n])
  
}

# This time i am making a plot basing on th eimportance of the word and it will be taken from 
# 


makeImpPlot <- function(corpus, x =20, n){
  
 num <- pickId(corpus, n)
 temp <- corpus %>% filter(doc_id == num) %>% arrange(desc(tf_idf)) %>% top_n(x)
 
 col <- brewer.pal(5, "Dark2")
 # ref <- collectRefs(corpus, x)
 bubbles(label = temp$word[1:x], value = temp$freq[1:x], 
         color = col) #, tooltip = ref)
  
}






