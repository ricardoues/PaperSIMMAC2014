gen<-function(beta0, popsize, maxgen)
{      
   returned_data = .Call('gen', beta0, as.integer(popsize), as.integer(maxgen), PACKAGE = "neurogen" );    

   return(returned_data); 
}

