suppressMessages(library(pbdMPI))
suppressMessages(library(pbdIO))
library(parallel)

cat(comm.rank())
print(comm.size())

finalize()