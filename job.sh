#!/bin/bash -l

#SBATCH --job-name=toy-gpu
#SBATCH --account=pawsey0001
#SBATCH --clusters=zeus
#SBATCH --partition=debugq
#SBATCH --time=10:00
#SBATCH --export=none

unset SBATCH_EXPORT
module load singularity
module load nextflow

export SLURM_CLUSTERS="topaz"

nextflow run main.nf -profile pawsey
