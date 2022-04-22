suppressMessages(library(pbdMPI))
suppressMessages(library(pbdIO))
library(parallel)

jakej <- comm.rank() # jakej
kolik <- comm.size() # kolik

print(paste("Ahoj, jmenuji se Empi", jakej, "jsem jeden z ", kolik, "identickych sourozencu!"))

x <- runif(1)

print(paste("Me nahode cislo od 0 do 1 je :", x))
soucet <- reduce(x)
finalize()

print(paste(jakej, "hlasi, ze jejich soucet je ", soucet))
