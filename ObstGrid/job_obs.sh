#!/bin/bash --login
#SBATCH -A marine-cpu
#SBATCH -q batch
#SBATCH --nodes=1 
#SBATCH -t 08:00:00
#SBATCH -J ww3_obs
#SBATCH -o obsout.out
#SBATCH -p orion


module load contrib noaatools 
module use /work2/noaa/marine/jmeixner/stack/hpc-modules/modulefiles/stack
module load hpc/1.2.0
module load hpc-intel/2022.1.2
module load miniconda3/4.6.14
module load hpc-miniconda3/4.6.14
module load alphabeta/1.0.0

#Update this to be your python path: 
export PYTHONPATH=/work2/noaa/marine/jmeixner/unstructuredgrids/seniorprojHH2223/alphaBetaLab

ulimit -s unlimited

python obstFileBuilder.py 
