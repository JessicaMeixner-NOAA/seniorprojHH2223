#!/bin/sh --login
#SBATCH -A marine-cpu
#SBATCH -n 1
#SBATCH -q batch
#SBATCH --nodes=1                 
#SBATCH -t 08:00:00
#SBATCH -J ww3_prep
#SBATCH -o prep.out
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
export METIS_PATH=/work/noaa/marine/ali.abdolali/Source/hpc-stack/parmetis-4.0.3

ulimit -s unlimited
ulimit -c 0

export OMP_NUM_THREADS=1
export KMP_AFFINITY=disabled
export KMP_STACKSIZE=2G

export IOBUF_PARAMS='*:size=1M:count=4:vbuffer_count=4096:prefetch=1'

WW3EXECDIR=/work2/noaa/marine/jmeixner/unstructuredgrids/GFSv17/exec

echo "Make mod_def" 
${WW3EXECDIR}/ww3_grid > ww3_grid.out

echo "prep wind" 
cp ww3_prnc_wnd.inp ww3_prnc.inp
ln -sf /work2/noaa/marine/jmeixner/unstructuredgrids/InputForcing/wind.nc wind.nc 
${WW3EXECDIR}/ww3_prnc > ww3_prnc_wnd.out

echo "prep ice" 
cp ww3_prnc_ice.inp ww3_prnc.inp
ln -sf /work2/noaa/marine/jmeixner/unstructuredgrids/InputForcing/ice.nc ice.nc
${WW3EXECDIR}/ww3_prnc > ww3_prnc_ice.out

echo "prep current" 
cp ww3_prnc_cur.inp ww3_prnc.inp
ln -sf /work2/noaa/marine/jmeixner/unstructuredgrids/InputForcing/current.nc current.nc
${WW3EXECDIR}/ww3_prnc > ww3_prnc_cur.out

echo "ww3_strt" 
${WW3EXECDIR}/ww3_strt > ww3_strt.out
#save this as something else since restart.ww3 will have to be replaced when restarts are needed
cp restart.ww3 fromstrt.restart.ww3
echo "done"
