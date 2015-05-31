#include <R.h>
#include <Rdefines.h>
#include <Rinternals.h>
#include <math.h> 

typedef struct vector_struct
{	   
   float *www; 	
   float sse;    
}vector; 


int quicksort(vector www[], vector tempwww, int ini,int fin, int nparm)
{      
   int _ini_,_fin_,pos,band;
   int popsize;
   int k; 
        
   popsize = fin;       
   _ini_=ini;
   _fin_=fin;
   pos=ini;
   band=1;
                          
   while (band==1)
   {
      band=0;
            
      while((www[pos].sse<=www[_fin_].sse)&&(pos!=_fin_))            
      {
         _fin_--;
      }
                  
      if (pos!=_fin_)
      {         
         tempwww.sse = www[pos].sse; 

         for (k=0; k<nparm; k++)
            tempwww.www[k] = www[pos].www[k];                                               
         
         www[pos].sse = www[_fin_].sse; 
         
         for (k=0; k<nparm; k++)
            www[pos].www[k] =  www[_fin_].www[k]; 
                                                      
         www[_fin_].sse = tempwww.sse; 
         
         for (k=0; k<nparm; k++)
            www[_fin_].www[k] = tempwww.www[k]; 
                           
         pos=_fin_;
         
         while ( (www[pos].sse >= www[_ini_].sse)  &&(pos!=_ini_) )
         {
            _ini_++;
         }
         
         
         if(pos!=_ini_)
         {
            band=1;            
            tempwww.sse = www[pos].sse; 

            for (k=0; k<nparm; k++)
               tempwww.www[k] = www[pos].www[k]; 
                                                            
            www[pos].sse = www[_fin_].sse; 
         
            for (k=0; k<nparm; k++)
               www[pos].www[k] =  www[_fin_].www[k];             

            www[_ini_].sse = tempwww.sse; 
         
            for (k=0; k<nparm; k++)
               www[_ini_].www[k] = tempwww.www[k];                         
            
            pos=_ini_;
         }
                                         
      }
                                         
   }
         
   
   if ((pos-1)>ini)
   {      
      quicksort(www,tempwww,ini,pos-1,nparm);
   }
                 
   if (fin>(pos+1))
   {
      quicksort(www,tempwww,pos+1,fin,nparm);
   }
            
   return 0;
                  
}




extern SEXP R_neurogenEvalEnv;   


SEXP gen(SEXP beta0, SEXP popsize, SEXP maxgen) 
{
   	
   SEXP toler; 	
   SEXP intervision; 	
   SEXP fun, pch;   
   SEXP e;          
   SEXP sse2;   
   SEXP SEXPCONTROLB; 
   
   R_len_t nparm;    	      
      
   vector *www; 
   vector tempwww;                            
   vector *nwww;   
   
   float PMSTART; 
   float PCONTROL; 
   float PMEND; 
   float PLINEAR; 
   float PSHUFFLE; 
   float SCALE; 
   float EXPONB; 
   float PDES; 
   float CURVAU; 
   float TOLER;                    
   float sumutilb; 
   float *CONTROLB;  

   float *aaa;   
   float *child1;
   float *child2;
   float schild1; 
   float schild2;           
   float *rr1; 
   float *s; 
   float temp1; 
   float temp2;             
   float rand; 
   float randy;
   float ssemean;  
   float sse1001;
   float pm;
   float suma;   
   float maxg; 
   float *lwww;      
   float *swww;      
   float *tempswww;                        
   float nnr;    

   int INTERVISION;         
   int *rrr;      
   int i,j, ii, iii;
   int repl; 
   int *ptrpopsize = INTEGER(popsize);       
   int *ptrmaxgen = INTEGER(maxgen);       
   int *nnrow;          
   int ind; 
   int p1; 
   int p2; 
   int cutpoint;      
            
   toler = findVar(install("toler"), R_neurogenEvalEnv);             
   intervision = findVar(install("INTERVISION"), R_neurogenEvalEnv);          
            
   PROTECT(e = allocVector(LANGSXP, 2));
          
   fun = findFun(install("classnetfun"), R_GlobalEnv);
   
   if(fun == R_NilValue) 
   {
      fprintf(stderr, "No definition for function classnetfun. Source classnetfun.R and save the session.\n");
	  UNPROTECT(1);
      exit(1);
   }
   	        
   suma = 0.0;          
   TOLER   = *REAL(toler);   
   INTERVISION = *INTEGER(intervision);      
   PMSTART = 0.35;
   PCONTROL = 0.95;
   PMEND   = 0.15;
   PLINEAR = 0.33;
   PSHUFFLE = 0.33;
   SCALE   = 1;
   EXPONB  = 2;
   PDES    = 0.050;
   CURVAU  = 0.75;
   nparm = length(beta0);             
   PROTECT(SEXPCONTROLB = allocVector(REALSXP, nparm));

   if ((*ptrpopsize) < (2*nparm) ) 		     
     *ptrpopsize = 2*nparm; 		    
                         
   www = (vector *) malloc( (*ptrpopsize) * sizeof(vector));    
      
   for (i=0; i<(*ptrpopsize); i++) 
      www[i].www = malloc( (nparm) * sizeof(float));  
      
   tempwww.www = malloc( (nparm) * sizeof(float));  
                  
   nwww = (vector *) malloc( (*ptrpopsize) * sizeof(vector));    
      
   for (i=0; i<(*ptrpopsize); i++) 
      nwww[i].www = malloc( (nparm) * sizeof(float));  
                                           
   for (i=0; i<nparm; i++)
      www[0].www[i] = REAL(beta0)[i];    
            
   lwww = (float *) malloc((*ptrpopsize)*sizeof(float));
      
   for (i=0; i<(*ptrpopsize); i++) 
      lwww[i] = (*ptrpopsize)-i; 
      
   for (i=0; i<(*ptrpopsize); i++)
      lwww[i] = (float) pow(lwww[i], CURVAU);        

   swww = (float *) malloc((*ptrpopsize)*sizeof(float));        
   tempswww = (float *) malloc((*ptrpopsize)*sizeof(float));        
   
   for (i=0; i<(*ptrpopsize); i++)
      suma = suma + lwww[i];  
      
   for (i=0; i<(*ptrpopsize); i++)
      swww[i] = lwww[i]/suma;  
      
   for (i=1; i<(*ptrpopsize); i++)
   {
	   suma = 0.0; 
	   suma = swww[i-1] + swww[i]; 	   
       swww[i] = suma; 	   	    
   }
                  
   nnrow = (int *) malloc((2)*sizeof(int));              
   CONTROLB = (float *) malloc((nparm) * sizeof(float)); 
   rrr = (int *) malloc((nparm) * sizeof(int));
   aaa = (float *) malloc((nparm) * sizeof(float));      
   rr1 = (float *) malloc((nparm) * sizeof(float));
   s = (float *) malloc((nparm) * sizeof(float));            
   child1 = (float *) malloc((nparm) * sizeof(float)); 
   child2 = (float *) malloc((nparm) * sizeof(float));    
      
   SETCAR(e, fun);	
   pch = allocVector(REALSXP, nparm);
               
   for (j=0; j<nparm; j++) 
      REAL(pch)[j] = www[0].www[j]; 

   SETCADR(e, pch);                  
   sse2 = eval(e, R_GlobalEnv);   
   www[0].sse = REAL(VECTOR_ELT(sse2, 0))[0];
            
   GetRNGstate();
   
   for (repl=1; repl<=(*ptrmaxgen); repl++)
   {  	    	   	   	
      if (unif_rand() < PDES || repl==1)
      {
	     if (repl == 1) 
	     {		                 
            for (i=1; i<(*ptrpopsize); i++)
            for (j=0; j<nparm; j++) 	            
               www[i].www[j] = norm_rand() * SCALE;                 
	            
            for (i=1; i<(*ptrpopsize); i++)
            {    		                                          	
          	   SETCAR(e, fun);	
               pch = allocVector(REALSXP, nparm);
               
               for (j=0; j<nparm; j++) 
                 REAL(pch)[j] = www[i].www[j]; 

               SETCADR(e, pch);                  
               sse2 = eval(e, R_GlobalEnv);                              
               www[i].sse = REAL(VECTOR_ELT(sse2, 0))[0];              	           
            }   
		     
	     } 
	     	     
	     else 
	     {		     
            for (i=nparm; i<(*ptrpopsize); i++)             
            for (j=0; j<nparm; j++) 	            
	           www[i].www[j] = norm_rand() * SCALE;                 
	         	         	    	           
            for (i=nparm; i<(*ptrpopsize); i++)            
            {               
          	   SETCAR(e, fun);	
               pch = allocVector(REALSXP, nparm);               
               
               for (j=0; j<nparm; j++) 
                 REAL(pch)[j] = www[i].www[j]; 

               SETCADR(e, pch);                  
               sse2 = eval(e, R_GlobalEnv);                                             
               www[i].sse = REAL(VECTOR_ELT(sse2, 0))[0];                                     		     
            }
		     		     		     
	     } 
	        	     
         quicksort(www,tempwww,0,(*ptrpopsize)-1,nparm); 	     	     	     	                                	     
         sumutilb = www[0].sse;
                           
         for (i=0; i<nparm; i++) 	            
         {  	            
	         CONTROLB[i] = www[0].www[i] ;     	           
         }
         	     
      }

      maxg = unif_rand()/EXPONB/repl;                                 
      
      for (ii=0; ii<(*ptrpopsize); ii+=2) 
      {        	       
         for(i=0; i<2; i++) 
         {
	        nnr = unif_rand();             	        
	        
	        for(iii=0; iii<(*ptrpopsize); iii++)
	        {
		       tempswww[iii] = (float) fabs(swww[iii] - nnr);     		       		        
	        }
	        	        	        
	        ind = 0; 
	        
	        for(iii=1; iii<(*ptrpopsize); iii++)
	        {
		       if (tempswww[iii] < tempswww[ind] )
		       {
			      ind = iii;  			          			       
		       }		                   		        
	        }
	        	        	        
		    if (swww[ind] - nnr < 0) 
		    {
			   ind = ind + 1;     			          
		    }
	        	        	        
	        nnrow[i] = ind;		       
         }   
	        	        
         p1 = nnrow[0]; 
         p2 = nnrow[1];                                       
         rand = unif_rand(); 
            
         if ( rand <= PCONTROL )            
         {
	        randy = unif_rand();  
	           
	        if (randy < PSHUFFLE )
	        {
               for(i=0; i<nparm; i++)
               {
	              if (unif_rand() > 0.5) 
	                rrr[i] = 1; 
	              else    
	                rrr[i] = 0; 	                  	                  
               }
		           
               for(i=0; i<nparm; i++)
               {	                 	                  
	              if (rrr[i] == 0)
	              {
	                 child1[i] = www[p1].www[i];  	                 
	                 child2[i] = www[p2].www[i];     		                 		                 
	              }     
	                 
	              else 
	              {		                 
	                 child1[i] = www[p2].www[i];  	                 
	                 child2[i] = www[p1].www[i];     		                 		                 		                 		                 
	              }	              	              	                  	                  
               }                                                                                     		           		           		           
	        }

            else if (randy < (PSHUFFLE + PLINEAR))
            {         
               for (i=0; i<nparm; i++)
               {
                  aaa[i] = unif_rand(); 	
                  child1[i] = aaa[i] * www[p1].www[i] + (1-aaa[i]) * www[p2].www[i];  
                  child2[i] = aaa[i] * www[p2].www[i] + (1-aaa[i]) * www[p1].www[i];                                                                       
               }                             	
            }
	        	        
	        else 
	        {
	           cutpoint = (int) round(unif_rand()*(nparm-2))+1; 	

               for (i=0; i<cutpoint; i++)
               {               	
	              child1[i] = www[p1].www[i];  	                 
	              child2[i] = www[p2].www[i];     		                 		                                	                  
               }
	                           
               for (i=cutpoint; i<nparm; i++)
               {                                    
	              child1[i] = www[p2].www[i];  	                 
	              child2[i] = www[p1].www[i];     		                 		                                                                                       
               }  	        	
	        }   	           	               	            	            
         }
                              
         else 
         {
            for(i=0; i<nparm; i++)
            {	                 	                  
	           child1[i] = www[p1].www[i];  	                 
	           child2[i] = www[p2].www[i];     		                 		                 
            } 	            	            	            
         }
           
         pm      = PMEND + (PMSTART - PMEND) / repl;             
                              
         for(i=0; i<nparm; i++) 
         {
	        if (unif_rand() <= pm)
	          temp1 = 1; 
	          
	        else 
	          temp1 = 0; 

	        if (unif_rand() > 0.5)
	          temp2 = 1; 
	          
	        else 
	          temp2 = 0; 
	             	             
	        rr1[i] = temp1*((temp2*2)-1 );   	      	              	        	                
         }
                              
         for(i=0; i<nparm; i++) 
         {
	        temp1 = unif_rand(); 
	        temp2 = (float) pow(unif_rand(),maxg);
	        temp2 = 1 - temp2;  	                	             	           
	        s[i] = temp1 * temp2; 	        	        	                
         }
            
         for(i=0; i<nparm; i++) 
         {
	        child1[i] = child1[i] + rr1[i] * s[i];	             	               
         }
           
         SETCAR(e, fun);	
         pch = allocVector(REALSXP, nparm); 
                       
         for (j=0; j<nparm; j++) 
            REAL(pch)[j] = child1[j]; 

         SETCADR(e, pch);                  
         sse2 = eval(e, R_GlobalEnv);                                    
         schild1 = REAL(VECTOR_ELT(sse2, 0))[0];                                 

         for(i=0; i<nparm; i++) 
         {
	        if (unif_rand() <= pm)
	          temp1 = 1; 
	          
	        else 
	          temp1 = 0; 

	        if (unif_rand() > 0.5)
	          temp2 = 1; 
	          
	        else 
	          temp2 = 0; 
	             	             
	        rr1[i] = temp1*((temp2*2)-1 );   	            	                
         }
            
         for(i=0; i<nparm; i++) 
         {
	        temp1 = unif_rand(); 
	        temp2 = (float) pow(unif_rand(),maxg);
	        temp2 = 1 - temp2;  	                	             	           
	        s[i] = temp1 * temp2; 	                
         }
            
         for(i=0; i<nparm; i++) 
         {
	        child2[i] = child2[i] + rr1[i] * s[i];	             	               
         }
           
         SETCAR(e, fun);	
         pch = allocVector(REALSXP, nparm);
                        
         for (j=0; j<nparm; j++) 
            REAL(pch)[j] = child2[j]; 

         SETCADR(e, pch);                  
         sse2 = eval(e, R_GlobalEnv);                                                                              
         schild2 = REAL(VECTOR_ELT(sse2, 0))[0];         
	              	     	     
	     for (i=0; i<nparm; i++) 
	     {
		    nwww[ii].www[i] = child1[i];    
		    nwww[ii+1].www[i] = child2[i]; 
	     }
	     	    
	     nwww[ii].sse = schild1; 
	     nwww[ii+1].sse = schild2;                          
      } 	         
      
      quicksort(nwww,tempwww,0,(*ptrpopsize)-1,nparm); 	     
	  	  	  	  	 	            
      for(i=1; i<(*ptrpopsize); i++) 
      {
      	 www[i].sse = nwww[i].sse; 
      	 
         for (j=0; j<nparm; j++) 
            www[i].www[j] = nwww[i].www[j];                  
      } 
      
      for(i=0; i<(*ptrpopsize); i++) 
      {
      	 nwww[i].sse = www[i].sse; 
      	 
         for (j=0; j<nparm; j++) 
            nwww[i].www[j] = www[i].www[j];       
      } 
                         
      quicksort(nwww,tempwww,0,(*ptrpopsize)-1,nparm); 	           
	  	 	                 
      for(i=0; i<(*ptrpopsize); i++) 
      {
      	 www[i].sse = nwww[i].sse; 
      	 
         for (j=0; j<nparm; j++) 
            www[i].www[j] = nwww[i].www[j];       
      } 
	               
      for (i=0; i<nparm; i++)
      {
         CONTROLB[i] = nwww[0].www[i]; 
      }          	  
      
      ssemean = 0.0; 
      
      for (i=0; i<(*ptrpopsize); i++)
      {
	     ssemean = ssemean + www[i].sse;     	      
      }
      
      ssemean = ssemean / (*ptrpopsize); 
      sse1001 = www[0].sse;             
      SETCAR(e, fun);	
      pch = allocVector(REALSXP, nparm);     
                
      for (j=0; j<nparm; j++) 
         REAL(pch)[j] = CONTROLB[j]; 
         
      SETCADR(e, pch);                  
      sse2 = eval(e, R_GlobalEnv);                                             
      sumutilb = REAL(VECTOR_ELT(sse2, 3))[0];
      
      if (INTERVISION==1)
      {         
         Rprintf("%d\t%d\t%f\t%f\t%f\n", repl,*INTEGER(maxgen),sse1001,sumutilb,ssemean);                            
      }      
           
      if (sumutilb<TOLER)
      { 
         PutRNGstate();
         Rprintf("tolerancia superada \n");        
     	     	     	     	
     	 for(i=0; i<nparm; i++) 
     	    REAL(SEXPCONTROLB)[i] = CONTROLB[i];      	        	        	   

         for(i=0; i<(*ptrpopsize); i++) 
            free(www[i].www); 
           
         free(www);            
         free(tempwww.www); 

         for(i=0; i<(*ptrpopsize); i++) 
            free(nwww[i].www); 
            
         free(nwww);                          
         free(lwww);    
         free(swww);       
         free(tempswww);          
         free(nnrow);                       
         free(CONTROLB); 
         free(rrr);
         free(aaa);        
         free(child1);       
         free(child2);          
         free(rr1);   
         free(s);   
         UNPROTECT(2);        	
     	
         return( SEXPCONTROLB );
      }	  	  	  	   	    	   
   } 
   
   PutRNGstate();

   for(i=0; i<nparm; i++) 
      REAL(SEXPCONTROLB)[i] = CONTROLB[i]; 
           
   for(i=0; i<(*ptrpopsize); i++) 
      free(www[i].www); 
      
   free(www);    
        
   free(tempwww.www); 

   for(i=0; i<(*ptrpopsize); i++) 
      free(nwww[i].www); 
      
   free(nwww);                          
   free(lwww);    
   free(swww);       
   free(tempswww);          
   free(nnrow);                       
   free(CONTROLB); 
   free(rrr);
   free(aaa);        
   free(child1);       
   free(child2);          
   free(rr1);   
   free(s);   

   UNPROTECT(2);   
   
   return(SEXPCONTROLB);       
}
