#!/bin/sh --login
#SBATCH -A marine-cpu
#SBATCH -n 1
#SBATCH -q batch
#SBATCH --nodes=1                 
#SBATCH -t 08:00:00
#SBATCH -J combinencpnt
#SBATCH -o combinencpnt.out
#SBATCH -p orion

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
module load cdo nco

ulimit -s unlimited
ulimit -c 0


grid=tri_15min

cdo mergetime pnt.*Z_spec.nc pnt.${grid}.spec.nc 


echo "done"
