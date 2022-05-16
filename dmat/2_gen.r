library(pbdDMAT, quiet=TRUE)
init.grid()

zero.dmat <- ddmatrix(0, nrow=10, ncol=10)
zero.dmat

id.dmat <- diag(1, nrow=10, ncol=10, type="ddmatrix", bldim=c(2,2))
id.dmat

comm.print(submatrix(id.dmat), all.rank=TRUE)

comm.set.seed(seed=1234567, diff=TRUE)
rand.dmat <- ddmatrix("rnorm", nrow=100, ncol=100, mean=10, sd=100)


finalize()
