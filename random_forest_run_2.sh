#!/bin/bash
#SBATCH --job-name utk
#SBATCH --account=bckj-delta-cpu
#SBATCH --partition=cpu
#SBATCH --mem=20g
#SBATCH --nodes=1
#SBATCH --cpus-per-task=48
#SBATCH --time 04:50:00
#SBATCH -e ./utk_3.e
#SBATCH -o ./utk_3.o

pwd

module load r
module list

time Rscript random_forest_parallel.R --args 4
time Rscript random_forest_parallel.R --args 16
