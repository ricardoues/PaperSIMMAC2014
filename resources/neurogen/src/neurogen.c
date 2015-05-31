#include "neurogen.h"

SEXP R_initNeurogen(SEXP NeurogenEvalEnv) 
{
 	
    R_neurogenEvalEnv = NeurogenEvalEnv;

    return R_NilValue;
}

SEXP R_killNeurogen() 
{
    return R_NilValue;
}
