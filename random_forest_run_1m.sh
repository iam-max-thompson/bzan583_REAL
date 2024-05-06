#!/bin/bash
#SBATCH --job-name utk
#SBATCH --account=bckj-delta-cpu
#SBATCH --partition=cpu
#SBATCH --mem=240g
#SBATCH --nodes=1
#SBATCH --cpus-per-task=120
#SBATCH --time 01:50:00
#SBATCH -e ./utk_full.e
#SBATCH -o ./utk_full.o

pwd

module load r
module list

time Rscript random_forest_1m.R --args 120



