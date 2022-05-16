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

module swap libfabric/1.12.1-GCCcore-10.3.0 libfabric/1.13.2-GCCcore-11.2.0 
export OMPI_MCA_mpi_warn_on_fork=0
export RDMAV_FORK_SAFE=1


## --args blas fork
#time Rscript mnist_rsvd.R --args 64 64 64

#time Rscript mnist_rsvd.R 1
#time Rscript mnist_rsvd.R 2
#time Rscript mnist_rsvd.R 4
#time Rscript mnist_rsvd.R 8
#time Rscript mnist_rsvd.R 16
#time Rscript mnist_rsvd.R 32
#time Rscript mnist_rsvd.R 64
#time Rscript mnist_rsvd.R 128
#time Rscript mnist_rsvd.R 256



time mpirun -np 1 Rscript mnist_rsvd.r 
time mpirun -np 64 Rscript mnist_rsvd.r 