#!/bin/bash
#PBS -N mnist_svd_cv
#PBS -l select=1:ncpus=128,walltime=00:50:00
#PBS -q qexp
#PBS -e mnist_svd_cv.e
#PBS -o mnist_svd_cv.o

cd ~/KPMS-IT4I-EX/mpi
pwd

module load R
echo "loaded R"

## --args blas fork
#time Rscript mnist_rsvd.R --args 64 64 64
time Rscript mnist_rsvd.R 1
time Rscript mnist_rsvd.R 2
time Rscript mnist_rsvd.R 4
time Rscript mnist_rsvd.R 8
time Rscript mnist_rsvd.R 16
time Rscript mnist_rsvd.R 32
time Rscript mnist_rsvd.R 64
time Rscript mnist_rsvd.R 128
time Rscript mnist_rsvd.R 256
