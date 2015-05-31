predictclassnet<-function(assetx,info,helge,beta) 
{   
   nneuron1 <- info[2];         
   rp <- nrow(assetx); 
   cp <- ncol(assetx);      
   x <- array(data=assetx, dim=c(rp,cp) ) ;
   
   if (helge$helge == 0) 
   {
      
   } 
   
   if (helge$helge == 1) 
   {   
      for ( i in 1:cp ) 
      {
         x[,i] <-(x[,i]-(helge$minimos[,i]))/((helge$maximos[,i])-(helge$minimos[,i]));   
      }               
   } 
      
   if (helge$helge == 2) 
   {     
      for ( i in 1:cp ) 
      {
         x[,i] <- (x[,i] - (helge$medias[,i])) / (helge$desv[,i]);   
      }                        
   } 
               
   nn1 <- array(dim=c(rp,nneuron1));      
   nn2 <- array(dim=c(rp,nneuron1)); 
   
   for (j in 1:nneuron1)
   {
      nn1[ ,j] <- x %*% t( array( data=beta[(1+(j-1)*cp):(j*cp)], dim=c(1, (j*cp)-(1+(j-1)*cp)+1 ) ) ) + beta[nneuron1*cp+j];
   }    

   for (j in 1:nneuron1)
   {
      nn2[ ,j] <- 1 /(1 + exp(-nn1[,j]));
   }
  
   yhat <- ( nn2[ ,1:nneuron1] %*% t( array(data = beta[(nneuron1*cp+nneuron1+1):(nneuron1*cp+2*nneuron1)], dim=c(1,(nneuron1*cp+2*nneuron1)-(nneuron1*cp+nneuron1+1) + 1 ) ) ) );  
   yhat <- yhat +  beta[nneuron1*cp+2*nneuron1+1]   ;    
   yhat <- 1 /(1 + exp(-yhat));
   A3 <- yhat;   
            
   return(list( PROB=A3));   
}

