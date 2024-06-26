#!/bin/bash
#SBATCH --job-name utk
#SBATCH --account=bckj-delta-cpu
#SBATCH --partition=cpu
#SBATCH --mem=240g
#SBATCH --nodes=4
#SBATCH --cpus-per-task=120
#SBATCH --time 18:50:00
#SBATCH -e ./utk_final.e
#SBATCH -o ./utk_final.o

pwd

module load r
module list

time Rscript random_forest_1m.R --args 120




