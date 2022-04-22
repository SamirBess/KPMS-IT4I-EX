suppressMessages(library(pbdMPI))
suppressMessages(library(pbdIO))
library(parallel)

jakej <- comm.rank() # jakej
kolik <- comm.size() # kolik

print(paste("Ahoj, jmenuji se Empi", jakej, "jsem jeden z ", kolik, "identickych sourozencu!"))

finalize()