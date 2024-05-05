#!/bin/bash
#SBATCH --job-name utk
#SBATCH --account=bckj-delta-cpu
#SBATCH --partition=cpu
#SBATCH --mem=40g
#SBATCH --nodes=2
#SBATCH --cpus-per-task=64
#SBATCH --time 04:50:00
#SBATCH -e ./utk_2.e
#SBATCH -o ./utk_2.o

pwd

module load r
module list

time Rscript random_forest_parallel.R --args 64
time Rscript random_forest_parallel.R --args 16
