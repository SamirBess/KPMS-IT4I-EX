#!/bin/bash
#PBS -N mnist_rsvd
#PBS -l select=1:mpiprocs=32
#PBS -l walltime=00:15:00

cd ~/KPMS-IT4I-EX/mpi
pwd

module load R
echo "loaded R"

## prevent warning when fork is used with MPI
export OMPI_MCA_mpi_warn_on_fork=0
export RDMAV_FORK_SAFE=1

## Fix for warnings from libfabric/1.12 bug
module swap libfabric/1.12.1-GCCcore-10.3.0 libfabric/1.13.2-GCCcore-11.2.0

## --args blas fork
mpirun --map-by ppr:4:node Rscript mnist_rsvd.R --args 2 8