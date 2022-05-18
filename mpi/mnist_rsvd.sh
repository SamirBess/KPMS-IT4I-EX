#!/bin/bash
#PBS -N mnist_rsvd
#PBS -l select=1:mpiprocs=32
#PBS -l walltime=00:15:00

cd ~/KPMS-IT4I-EX/mpi
pwd

module load R
echo "loaded R"

## --args blas fork
mpirun --map-by ppr:4:node Rscript mnist_rsvd.R

#time Rscript mnist_rsvd.R 1
#time Rscript mnist_rsvd.R 2
#time Rscript mnist_rsvd.R 4
#time Rscript mnist_rsvd.R 8
#time Rscript mnist_rsvd.R 16
#time Rscript mnist_rsvd.R 32
#time Rscript mnist_rsvd.R 64
#time Rscript mnist_rsvd.R 128
#time Rscript mnist_rsvd.R 256


