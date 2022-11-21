#!/bin/bash --login
#SBATCH -A marine-cpu
#SBATCH -q batch
#SBATCH --nodes=1 
#SBATCH -t 08:00:00
#SBATCH -J ww3_plot
#SBATCH -o gridplot.out1
#SBATCH -p orion


module load contrib noaatools 
module use /work2/noaa/marine/jmeixner/stack/hpc-modules/modulefiles/stack
module load hpc/1.2.0
module load hpc-intel/2022.1.2
module load miniconda3/4.6.14
module load hpc-miniconda3/4.6.14
module load emcpyplot/1.0.0    


ulimit -s unlimited

# -g path/to/msh file 
# -d grididentifier
python plot_elementinfo_unstr.py -g global_15kmwhole_0_360_tmp2.msh  -d grid_15km

