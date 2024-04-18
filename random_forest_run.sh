#!/bin/bash
#SBATCH --job-name utk
#SBATCH --account=bckj-delta-cpu
#SBATCH --partition=cpu
#SBATCH --mem=20g
#SBATCH --nodes=1
#SBATCH --cpus-per-task=16
#SBATCH --time 00:50:00
#SBATCH -e ./utk.e
#SBATCH -o ./utk.o

pwd

module load r
module list

time Rscript random_forest_serial.R
time Rscript random_forest_parallel.R --args 1
time Rscript random_forest_parallel.R --args 2
time Rscript random_forest_parallel.R --args 4
time Rscript random_forest_parallel.R --args 8
time Rscript random_forest_parallel.R --args 16