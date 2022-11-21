#!/bin/sh --login
#SBATCH -A marine-cpu
#SBATCH -q batch
#SBATCH --nodes=30                    # Number of nodes
#SBATCH --ntasks-per-node=20          # How many tasks on each node
#SBATCH -t 08:00:00
#SBATCH -J runww3
#SBATCH -o multi.out
#SBATCH -p orion
#SBATCH --exclusive

module purge
module use /apps/contrib/NCEP/libs/hpc-stack/modulefiles/stack
module load hpc/1.1.0
module load hpc-intel/2018.4
module load hpc-impi/2018.4
module load netcdf/4.7.4
module load jasper/2.0.25
module load zlib/1.2.11
module load png/1.6.35
module load hdf5/1.10.6
module load bacio/2.4.1
module load g2/3.4.2
module load w3nco/2.4.1
export METIS_PATH=/work/noaa/marine/ali.abdolali/Source/hpc-stack/parmetis-4.0.3

ulimit -s unlimited

export KMP_AFFINITY=disabled
export KMP_STACKSIZE=2G

export IOBUF_PARAMS='*:size=8M:count=4:vbuffer_count=4096:prefetch=1'

srun --label -n 600 ${WW3EXECDIR}/ww3_multi
