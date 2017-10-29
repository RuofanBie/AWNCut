\name{NCut}
\alias{NCut}
\title{Cluster the rows of X into K clusters using the NCut method.}
\usage{
NCut(X,K=3,B=300)
}
\arguments{
\item{X}{is an n x p1 matrix of n observations and p1 variables. The rows of 
X into K clusters using the NCut method.}

\item{K}{is the number of clusters.}

\item{B}{is the number of iterations in the simulated annealing algorithm.}

\item{L}{is the temperature coefficient in the simulated annealing algorithm.}
}
\value{
A list with the final value of the objective function and the clusters.
}
\description{
This function will output K clusters of  the rows of X.
}
\details{
The algorithm maximizes a modified version of NCut through simulated annealing.
The clusters correspond to partitions that maximize this objective function.
}
\examples{
#This sets up the initial parameters for the simulation.
lambda <- seq(2,6,1) #Tuning parameter lambda
Tau <- seq(0.2,0.8,0.2) #Tuning parameter tau 
n=90; n1=30; n2=30; n3=n-n1-n2 #Sample size
p1=300; p2=500; r1=280; r2=480; #Number of variables and noises in each dataset 
K=3; #Number of clusters 
mu=1; #Mean of the marginal distribution
u1=0.5; #Range of enties in the coefficient matrix

library(mvtnorm)
epsilon <- matrix(rnorm(n*(p1-r1),0,1), n, (p1-r1)) #Generation of random error in the regression model

Sigma1 <- matrix(rep(0.8,(p1-r1)^2),(p1-r1),(p1-r1)) #Generation of the covariance matrix
diag(Sigma1) <- 1

T1 <- matrix(rmvnorm(n1,mean=rep(-mu,(p1-r1)),sigma=Sigma1),n1,(p1-r1)) #Generation of the original distribution of the three clusters
T2 <- matrix(rmvnorm(n2,mean=rep(0,(p1-r1)),sigma=Sigma1),n2,(p1-r1))
T3 <- matrix(rmvnorm(n3,mean=rep(mu,(p1-r1)),sigma=Sigma1),n3,(p1-r1))

X1 <- sign(T1)*(exp(abs(T1))) #Generation of signals in X
X2 <- sign(T2)*(exp(abs(T2)))
X3 <- sign(T3)*(exp(abs(T3)))
ep1 <- (matrix(rnorm(n*r1,0,1),n,r1)) #Generation of noises in X
X <- rbind(X1,X2,X3)

X <- cbind(X,ep1)
#Our method
NCut.result <- NCut(X,K=3,B=300)
Cs <- NCut.result$Cs

#This is the true error of the clustering solution.
ErrorRate(Cs)
}