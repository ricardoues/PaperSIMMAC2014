\name{neurogen-package}
\alias{neurogen-package}
\alias{neurogen}
\docType{package}
\title{Redes Neuronales con algoritmos geneticos}
\description{Un paquete en R para estimar modelos de redes neuronales MLP usando como metodo de estimacion de los parametros algoritmos geneticos. 
}
\details{
\tabular{ll}{
Package: \tab neurogen\cr
Type: \tab Package\cr
Version: \tab 1.0\cr
Date: \tab 2007-01-02\cr
License: \tab GPL \cr
}
}
\author{
Ricardo Salvador Rios Marquez. 

Maintainer: Ricardo Salvador Rios Marquez. \email{ricardo\_rios\_sv@yahoo.com}
}
\references{
\url{http://www.geocities.com/ricardo_rios_sv}
}
\keyword{ neural }

\seealso{
 \code{\link{classnet}}, \code{\link{predictclassnet}}
}
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
