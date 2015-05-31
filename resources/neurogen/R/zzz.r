.NeurogenEvalEnv <- new.env(); 
assign("nneuron1", NULL, envir=.NeurogenEvalEnv);
assign("limit", NULL, envir=.NeurogenEvalEnv);
assign("P", NULL, envir=.NeurogenEvalEnv);
assign("T", NULL, envir=.NeurogenEvalEnv);
assign("toler", NULL, envir=.NeurogenEvalEnv);
assign("INTERVISION", NULL, envir=.NeurogenEvalEnv);

.onLoad <- function(lib, pkg)
{
    library.dynam( "neurogen", pkg, lib )    
    environment(.NeurogenEvalEnv) <- asNamespace("neurogen")
    .Call("R_initNeurogen", .NeurogenEvalEnv, PACKAGE="neurogen")
    .neurogen.loaded <<- TRUE
}

.onUnload <- function(libpath)
{
    if (.neurogen.loaded) 
    {
        .Call("R_killNeurogen", PACKAGE="neurogen")
    }
    
    library.dynam.unload("neurogen", libpath)
}




cat("Universidad de El Salvador ", "\n" ); 
cat("Facultad de Ciencias Naturales y Matematica ", "\n" ); 
cat("Escuela de Matematica ", "\n");
cat("Paquete: Neurogen ", "\n"); 
cat("Version: 1.0 ", "\n");  
cat("Descripcion: Redes Neuronales con algoritmos geneticos ", "\n"); 
cat("Licencia: GPL ", "\n"); 
