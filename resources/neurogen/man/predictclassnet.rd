\name{predictclassnet}
\alias{predictclassnet}
\title{Prediccion de nuevas observaciones}
\description{Es una funcion que calcula el resultado de un modelo neuronal MLP previamente estimado con la funcion classnet sobre un conjunto nuevo de observaciones.
}
\usage{
predictclassnet(assetx, info, helge, beta)
}
\arguments{
  \item{assetx}{Una arreglo numerico que contiene una observacion en cada fila y las variables de entrada o explicativas en cada columna.}
  \item{info}{Un arreglo numerico con longitud igual al numero de capas de la red neuronal y conteniendo la cantidad de neuronas en cada una de las capas de la red neuronal.}
  \item{helge}{Una lista conteniendo los datos del preprocesamiento.}               
  \item{beta}{Los pesos de la red neuronal.}
}
\details{
Calcula las probabilidades asociadas a los datos de entrada. \cr
}
\value{
Un vector conteniendo la respuesta de la red. \cr
}
\references{ 
\url{http://www.geocities.com/ricardo_rios_sv} 
}
\author{ Ricardo Salvador Rios Marquez. \email{ricardo\_rios\_sv@yahoo.com} }
\seealso{ 'classnet' }
        
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
cancer <- cancer[,1:(coldep-1)]
predict <- predictclassnet(cancer,train$info,train$helge,train$beta)
}

