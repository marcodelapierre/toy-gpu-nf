#!/bin/bash -l

#SBATCH --job-name=toy-gpu
#SBATCH --account=pawsey0001
#SBATCH --clusters=zeus
#SBATCH --partition=workq
#SBATCH --time=10:00
#SBATCH --export=none

unset SBATCH_EXPORT
module use /group/director2172/software/sles12sp3/modulefiles #not needed for users whose default project is director2172
module load singularity
module load nextflow/20.07.1-multi

nextflow run main.nf -profile zeus
