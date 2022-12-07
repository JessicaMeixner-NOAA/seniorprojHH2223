#!/bin/sh --login
#SBATCH -A marine-cpu
#SBATCH -n 1
#SBATCH -q batch
#SBATCH --nodes=1                 
#SBATCH -t 08:00:00
#SBATCH -J ww3_point
#SBATCH -o point3.out
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


export METIS_PATH=/work/noaa/marine/ali.abdolali/Source/hpc-stack/parmetis-4.0.3

ulimit -s unlimited
ulimit -c 0

export OMP_NUM_THREADS=1
export KMP_AFFINITY=disabled
export KMP_STACKSIZE=2G

export IOBUF_PARAMS='*:size=1M:count=4:vbuffer_count=4096:prefetch=1'

WW3EXECDIR=/work2/noaa/marine/jmeixner/unstructuredgrids/v0/exec



NDATE=/apps/contrib/NCEP/libs/hpc-stack/intel-2018.4/prod_util/1.2.2/bin/ndate

CycleStart=2021092400
CycleEnd=2021102500
CDATE=$CycleStart
CYC_STEP=1
while [ $CDATE -le $CycleEnd ]; do
  TZ=${CDATE:8:2}
  DATE=${CDATE:0:8}

  WW3DATE="${DATE} ${TZ}0000" 

    ln -sf ${DATE}.${TZ}0000.out_pnt.ww3 out_pnt.ww3

  sed -e "s/WW3DATE/$WW3DATE/g" \
                ww3_ounp.inp.tmpl3 > ww3_ounp.inp
  echo "running ounp for $WW3DATE"
  ${WW3EXECDIR}/ww3_ounp
 
  rm out_pnt.ww3 ww3_ounp.inp

  CDATE=`${NDATE} ${CYC_STEP} ${CDATE}`
done

echo "combine" 

grid=glo_m1gfsv16

cdo mergetime inp.*Z_tab.nc  inp.${grid}.tab.nc


echo "done"
