\name{classnet}
\alias{classnet}
\title{Red neuronal}
\description{Red neuronal MLP con variable respuesta dicotomica.
}
\usage{
classnet(assetx, coldep, percent, errpercent, errweight, limit, info, gendum = 1, maxgen, helge = 0, visual = TRUE, beta0init)
}
\arguments{
  \item{assetx}{Una arreglo numerico que contiene una observacion en cada fila y las variables en cada columna.}
  \item{coldep}{El numero de la columna correspondiente a la variable dependiente o respuesta en assetx.}
  \item{percent}{Porcentaje de datos para la estimacion dentro de la muestra.}
  \item{errpercent}{Error maximo o tolerancia en la clasificacion.}  
  \item{errweight}{Peso que se le asigna a los falsos positivos.}
  \item{limit}{Punto de corte.}
  \item{info}{Un arreglo numerico con longitud igual al numero de capas de la red neuronal y conteniendo la cantidad de neuronas en cada una de las capas de la red neuronal.}
  \item{gendum}{Un valor numerico conteniendo el tipo de optimizacion (1 = Algoritmos geneticos).}
  \item{maxgen}{Maximo numero de generaciones.}
  \item{helge}{Tipo de preprocesamiento (0 = sin preprocesamiento, 1 = escalamiento en el intervalo [0,1] y 2 = normalizacion).}
  \item{visual}{Un valor logico que activa o desactiva la visualizacion del proceso de entrenamiento.}  
  \item{beta0init}{Pesos de la red neuronal (opcional).}
}
\details{
Una red neuronal que busca clasificar datos donde la variable respuesta es dicotomica. La funcion de activacion en la capa oculta y en la capa de salida es la funcion logistica. \cr
Este modelo usa algoritmos geneticos para encontrar el conjunto de pesos optimos, teniendo como funcion objetivo la entropia de los datos. \cr
Si el valor de visual es TRUE se activa la visualizacion del proceso de entrenamiento el cual imprime la siguiente informacion:\cr
1. La generacion actual. \cr
2. El maximo numero de generaciones. \cr
3. La funcion de error (entropia) del mejor individuo. \cr
4. El porcentaje del error de clasificacion del mejor individuo. \cr
5. La media de la funcion de error (entropia) de la generacion actual. \cr
}
\value{
Devuelve una lista conteniendo siete elementos: \cr
1. NETRES: El porcentaje de falsos positivos y falsos negativos dentro y fuera de la muestra. \cr
2. LIKELIHOOD: La funcion de error (entropia). \cr
3. PROB\_IN: La respuesta de la red neuronal dentro de la muestra. \cr
4. PROB\_OUT: La respuesta de la red neuronal fuera de la muestra. \cr
5. beta: El conjunto de pesos o coeficientes. \cr
6. info: La arquitectura de la red neuronal. \cr
7. helge: Datos del preprocesamiento. \cr
}
\references{ 
\url{http://www.geocities.com/ricardo_rios_sv} 
}
\author{ Ricardo Salvador Rios Marquez. \email{ricardo\_rios\_sv@yahoo.com}}
\seealso{ 'predictclassnet' }
        
\keyword{ neural }

\examples{ 
data(cancer)
coldep <- ncol(cancer)
percent <- 1
errpercent <- 0.1
errweight <- 0.5
limit <- 0.5
info <- array(data=c(ncol(cancer)-1,3,1), dim=c(1,3))
optim <- 1
maxgen <- 100
helge <- 2
visual <- TRUE
train <- classnet(cancer,coldep,percent,errpercent,errweight,limit,info,optim,maxgen,helge,visual)
cancer <- cancer[,1:(coldep-1)]; 
predict <- predictclassnet(cancer,train$info,train$helge,train$beta); 	
}
