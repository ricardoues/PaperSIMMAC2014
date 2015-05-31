classnetfun<-function(beta) 
{         
   nneuron1 <- get("nneuron1", envir=.NeurogenEvalEnv );      
   limit <- get("limit", envir= .NeurogenEvalEnv );             
   P <- get("P", envir= .NeurogenEvalEnv );       
   T <- get("T", envir=.NeurogenEvalEnv );             
   
   rp <- nrow(P); 
   cp <- ncol(P);    
   x <- P; 
      
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
   TT <- T;
   y <- T;
   A3 <- yhat;
   lik <- y * log(yhat) + (1-y) * log(1-yhat);
   LIK3 <- -sum(lik);
     
   xmean = array(data=apply(P, 2, mean),  dim=c(1,cp) );  
   BETA <- array(data=beta[(nneuron1*cp+nneuron1+1):(nneuron1*cp+2*nneuron1)], dim=c(1, (nneuron1*cp+2*nneuron1)-(nneuron1*cp+nneuron1+1)+1 ) );                                                                                                        
   GAMMA <- array( data = beta[(1:(nneuron1*cp))], dim=c(1, ((nneuron1*cp)-1+1) ) ) ;
   GAMMA1 <- array(data = GAMMA, dim=c(cp,nneuron1));      
   nn1mean <- array(dim=c(1,nneuron1));

   for (j in 1:nneuron1)
   {
      nn1mean [,j] <- xmean %*% t(array( data= beta[(1+(j-1)*cp):(j*cp)], dim=c(1,(j*cp)-(1+(j-1)*cp)+1))); 
      nn1mean [,j] <- nn1mean[,j] + beta[nneuron1*cp+j];     
   }

   nn2mean <- array(dim=c(1,nneuron1));

   for (j in 1:nneuron1)
   {
      nn2mean [,j] <- 1 / (1+exp(-nn1mean[,j]));        
   }
            
   nn3mean <- nn2mean[,1:nneuron1] %*% t(array(data = beta[(nneuron1*cp+nneuron1+1):(nneuron1*cp+2*nneuron1)], dim=c(1,(nneuron1*cp+2*nneuron1)-(nneuron1*cp+nneuron1+1)+1))); 
   nn3mean <- nn3mean + beta[nneuron1*cp+2*nneuron1+1]; 
   nn3mean = 1 /  (1 + exp(-nn3mean));          
   junk <- array(dim=c( nneuron1 , cp)); 

   for (i in 1:cp) 
   {
      for (j in 1:nneuron1)
      {
         junk[j,i] <- BETA[j] * nn2mean[j] * (1-nn2mean[j]) * GAMMA1[i,j];
      }
   }
       
   PDERIVNET <- nn3mean * (1-nn3mean) * apply(junk,2,sum);
    
   nrow <- nrow(P);   
   A3n <- A3; 
   A3n <- A3n>limit;        
   err3 <- abs(A3n - T);
   err3<- sum(err3) / nrow;
   ERRCLASS <- err3; 
       
  return(list(LIK3=LIK3, A3=A3, PDERIVNET=PDERIVNET, ERRCLASS=ERRCLASS));
}

