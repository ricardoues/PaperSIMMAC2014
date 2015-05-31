classnet<-function(assetx,coldep,percent,errpercent,errweight,limit,info,gendum=1,maxgen,helge=0,visual=TRUE, beta0init ) 
{   

   if (length(info)<3)
   {
      stop('El valor de info debe ser un arreglo conteniendo el numero de entradas, el numero de neuronas en la capa de salida y el numero de variables de salida.'); 
   }
   
   if (gendum!=1) 
   {
      stop('El valor de gendum debe ser uno.'); 
   }
   
   if ( helge!=0 && helge!=1 && helge!=2 )
   {
      stop('El valor de helge debe estar entre cero y dos.');    
   }
               
   assign("nneuron1", info[2], envir= .NeurogenEvalEnv );   
   nneuron1 <- get("nneuron1", envir= .NeurogenEvalEnv );      
   assign("toler", errpercent, envir= .NeurogenEvalEnv );                  
   assign("limit", limit, envir=.NeurogenEvalEnv );      
   limit <- get("limit", envir=.NeurogenEvalEnv );                
   
   if (visual)
   {
      assign("INTERVISION", as.integer(1), envir=.NeurogenEvalEnv );         
   }
   
   else 
   {
      assign("INTERVISION", as.integer(0), envir=.NeurogenEvalEnv );               
   }
         
   popsize <- 100;          
   rr <- nrow(assetx); 
   cc <- ncol(assetx);            
   y <- array(data=assetx[,coldep], dim=c(rr, 1));
   
   if (coldep==1)
   {
      x <- array(data=assetx[,2:cc], dim=c(rr,(cc-1))) ;         
   }

   else if (coldep==cc) 
   {
      x <- array(data=assetx[,1:(coldep-1)], dim=c(rr, cc-1));   
   }
            
   else 
   {
      x <- cbind(assetx[,1:(coldep-1)], assetx[,(coldep+1):cc]);   
   }
                     
   nrow <- nrow(x); 
   ncol <- ncol(x);    
   nrowy <- nrow(y); 
   ncoly <- ncol(y);        
   nrow1 <- round(percent * nrow);
   nrow11 <- nrow1 + 1;             
   rx <- nrow(x); 
   cx <- ncol(x);
   ry <- nrow(y); 
   cy <- ncol(y); 
      
   if (helge == 0) 
   {
      PN <- x; 
      TN <- y;      
   } 
   
   if (helge == 1) 
   {   
      minimos <- array(dim=c(1,cx)); 
      maximos <- array(dim=c(1,cx)); 
      
      for ( i in 1:cx ) 
      {
         minimos[i] <- min(x[,i]); 
         maximos[i] <- max(x[,i]); 
      }   
   
      for ( i in 1:cx ) 
      {
         x[,i] <-(x[,i]-min(x[,i]))/(max(x[,i])-min(x[,i]));   
      }   
         
      PN <- x; 
      TN <- y;                     
   }
      
   if (helge == 2) 
   {         
      medias <- array(dim=c(1,cx)); 
      desv <- array(dim=c(1,cx)); 
                  
      for ( i in 1:cx ) 
      {
         medias[i] <- mean(x[,i]); 
         desv[i] <- sd(x[,i]); 
      }                     
      
      for ( i in 1:cx ) 
      {
         x[,i] <- (x[,i] - mean(x[,i])) / (sd(x[,i]));   
      }   
                           
      PN <- x; 
      TN <- y;                     
   }
                 
   assign("P", PN[1:nrow1,], envir=.NeurogenEvalEnv );   
   P <- get("P", envir=.NeurogenEvalEnv ); 
      
   rp <- nrow(P); 
   cp <- ncol(P); 
                  
   assign("T", array(data=TN[1:nrow1,], dim=c(nrow1,1)), envir=.NeurogenEvalEnv );   
   T <- get("T", envir=.NeurogenEvalEnv ); 
            
   nparm = nneuron1 * cp + nneuron1 + (nneuron1) + 1;
              
   if ( nargs() > 11 ) 
   {
      beta0 <- beta0init; 
   }
         
   else 
   {
      beta0 = array( data=runif(nparm), dim=c(1,nparm));       
   }  
      
   if (gendum >= 1) 
   {
      beta = gen(beta0,popsize,maxgen);
   }
   
   else
   {
      beta = beta0   
   }
   
   if (gendum>=1) 
   {
      output_net <- classnetfun(beta);      
      LIK3 <- output_net$LIK3; 
      A3 <- output_net$A3;                
   }
         
   A3n <- A3; 
   A3real <- A3n;
   A3 <- A3>limit;         
   err3 <- A3 - T;
   err3a <- err3>0;
   err3b <- err3<0;
   err3ap <- sum(err3a) / nrow;
   err3bp <- sum(err3b) / nrow;   
   err3p <-  errweight * err3ap + (1-errweight) * err3bp;
   netres_in <- cbind(err3ap, err3bp, err3p);
               
   if (percent<1) 
   {
      xout <- cbind(x[nrow11:nrow,]); 
      yout <- cbind(y[nrow11:nrow,]);      
      n1 <- nrow(yout);
      c1 <- ncol(yout);
      T1 <- cbind(y[(nrow1+1):nrowy,]);       
                    
      assign("T", cbind(TN[(nrow1+1):ry,]), envir=.NeurogenEvalEnv );   
      T <- get("T", envir=.NeurogenEvalEnv );                   
      
      assign("P", cbind(PN[(nrow1+1):rx,]), envir=.NeurogenEvalEnv );   
      P <- get("P", envir=.NeurogenEvalEnv ); 
      
      output_net2 <- classnetfun(beta);                  
      A31 <- output_net2$A3;      
      A31n <- A31;       
      A31real <- A31;
      A31 <- A31>limit;      
      err31 <- A31 - T1;
      err31a <- err31>0;
      err31b <- err31<0;
      err31ap <- sum(err31a) / n1;
      err31bp <- sum(err31b) / n1;
      err31p <-  errweight * err31ap + (1-errweight) * err31bp;      
      netres_out <- cbind(err31ap, err31bp, err31p);      
   }

   else 
   {
      A31n <- cbind(1);
      netres_out <- cbind(1,1,1);   
   }
            
   NETRES <- rbind(netres_in, netres_out); 
      
   if (helge==0) 
   {
      helge = list(helge=helge);       
   }
   
   if (helge==1) 
   {         
      helge = list(helge=helge,minimos=minimos, maximos=maximos);    
   }
   
   if (helge==2) 
   {         
      helge = list(helge=helge, medias=medias, desv=desv);    
   }
         
   return(list(NETRES=NETRES, LIKELIHOOD=LIK3, PROB_IN=A3n, PROB_OUT=A31n, beta=beta, info=info, helge=helge ));    
}

