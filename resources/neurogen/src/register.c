#include <R_ext/Rdynload.h>
#include "neurogen.h"

static const R_CallMethodDef callMethods[] = {
    {"R_initNeurogen", (DL_FUNC) &R_initNeurogen, 1},
    {"R_killNeurogen", (DL_FUNC) &R_killNeurogen, 0}, 
    { NULL, NULL, 0 }    
};


void R_init_neurogen(DllInfo *dll) 
{
    R_useDynamicSymbols(dll, FALSE);              
     
    R_registerRoutines(dll, NULL, callMethods, NULL, NULL);
}
