suppressMessages(library(pbdMPI))
suppressMessages(library(pbdIO))
#library(parallel)

pars = seq(80.0, 95, .2)
amount.of.work.for.one <- length(pars)/comm.size() 
# Code probably rely on comm.size from shell file which I will set
# comm.size() should divide 76 without zbytek
pars = pars[(worker.number*amount.of.work.for.one + 1):(worker.number*(amount.of.work.for.one + 1))]

print(paste("Worker ", worker.number, " has to work on ", pars))

finalize()
