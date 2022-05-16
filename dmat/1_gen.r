library(pbdDMAT, quiet=TRUE)
init.grid()

# Common global on all processors --> distributed
x <- matrix(1:100, nrow=10, ncol=10)
x.dmat <- as.ddmatrix(x, bldim=c(2,2))

comm.print(x.dmat@Data, all.rank=TRUE)

# Global on processor 0 --> distributed
if (comm.rank()==0){
  y <- matrix(1:100, nrow=10, ncol=10)
} else {
  y <- NULL
}
y.dmat <- as.ddmatrix(y)

comm.print(y.dmat, all.rank=TRUE)

finalize()
