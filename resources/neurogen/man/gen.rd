\name{gen}
\alias{gen}
\title{Algoritmo Genetico}
\description{Esta funcion es de bajo nivel usada por classnet y no deberia ser llamada por el usuario. 
}
\usage{
gen(beta0, popsize, maxgen )
}
\arguments{
  \item{beta0}{Pesos de la red neuronal.}
  \item{popsize}{Tamanho de la poblacion.}
  \item{maxgen}{Maximo numero de generaciones.}

}
\details{
Algoritmo genetico elitista que usa los operadores de seleccion, cruza y mutacion. \cr
}
\value{
Devuelve un vector conteniendo el mejor conjunto de pesos o coeficientes  para un numero de generaciones igual a maxgen. \cr
}
\references{ 
\url{http://www.geocities.com/ricardo_rios_sv} 
}
\author{ Ricardo Salvador Rios Marquez. \email{ricardo\_rios\_sv@yahoo.com} }
\seealso{ 'classnet' }
        
\keyword{ neural }
