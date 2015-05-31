\name{classnetfun}
\alias{classnetfun}
\title{Funcion utilitaria que calcula el error y la respuesta de la red neuronal.}
\description{Esta funcion es de bajo nivel usada por classnet y gen, y no deberia ser llamada por el usuario. 
}
\usage{
classnetfun(beta)
}
\arguments{
  \item{beta}{Los pesos de la red neuronal}
}
\details{
Cacula el error y la respuesta de la red neuronal. \cr
}
\value{
Devuelve una lista conteniendo 4 elementos: \cr
1. LIK3: La entropia. \cr
2. A3: La respuesta de la red neuronal. \cr
3. PDERIVNET: Las derivadas parciales de la red neuronal. \cr
4. ERRCLASS: Error de clasificacion. \cr
}
\references{ 
\url{http://www.geocities.com/ricardo_rios_sv} 
}
\author{ Ricardo Salvador Rios Marquez. \email{ricardo\_rios\_sv@yahoo.com} }
\seealso{ 'classnet' }
        
\keyword{ neural }
