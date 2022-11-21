#! /usr/bin/env bash
set -x


#The next three lines need to be updated based on switch, ww3 directory path and final exec path 
THISDIR="/work2/noaa/marine/jmeixner/unstructuredgrids/v0"
export SWITCHFILE="$THISDIR/switch_PDLIB"
export WW3_DIR="$THISDIR/ww3"
export finalexecdir="$THISDIR/exec"

#Determine machine and load modules
set +x
 module load cmake/3.22.1 
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
set -x

# Build exes for prep jobs and post jobs:
prep_exes="ww3_grid ww3_prep ww3_prnc ww3_grid ww3_strt"
post_exes="ww3_outp ww3_outf ww3_outp ww3_gint ww3_ounf ww3_ounp"
run_exes="ww3_shel ww3_multi"

#create exec dir 
if [[ ! -d "${finalexecdir}" ]]; then
  mkdir -p ${finalexecdir}
fi

#create SHRD build directory: 
path_build="$WW3_DIR/build_SHRD"
mkdir -p "$path_build" || exit 1
cd "$path_build" || exit 1
echo "Forcing a SHRD build" 

echo $(cat "${SWITCHFILE}") > "${path_build}/tempswitch"

cat "${path_build}/tempswitch"
sed -e "s/DIST/SHRD/g"\
    -e "s/OMPG / /g"\
    -e "s/OMPH / /g"\
    -e "s/MPIT / /g"\
    -e "s/MPI / /g"\
    -e "s/B4B / /g"\
    -e "s/PDLIB / /g"\
       "${path_build}/tempswitch" > "${path_build}/switch"
rm "${path_build}/tempswitch"

echo "Switch file is $path_build/switch with switches:" 
cat "${path_build}/switch "

cp ${path_build}/switch ${finalexecdir}/switch_SHRD

#Build executables: 
cmake "${WW3_DIR}" -DSWITCH="${path_build}/switch" -DCMAKE_INSTALL_PREFIX=install 
rc=$?
if [[ ${rc} -ne 0 ]] ; then
  echo "Fatal error in cmake."
  exit ${rc}
fi
make -j 8 
rc=$?
if [[ ${rc} -ne 0 ]] ; then
  echo "Fatal error in make."
  exit ${rc}
fi
make install 
if [[ ${rc} -ne 0 ]] ; then
  echo "Fatal error in make install."
  exit ${rc}  
fi

# Copy to top-level exe directory
for prog in ${prep_exes} ${post_exes}; do
  cp "${path_build}/install/bin/${prog}" "${finalexecdir}/"
  rc=$?
  if [[ ${rc} -ne 0 ]] ; then
    echo "FATAL: Unable to copy ${path_build}/${prog} to ${finalexecdir} (Error code ${rc})"
    exit ${rc}
  fi
done

#clean-up build directory:
echo "executables are in ${finalexecdir}" 
echo "cleaning up ${path_build}" 
rm -rf "${path_build}"

#create build directory: 
path_build="$WW3_DIR/build_MPI"
mkdir -p "$path_build" || exit 1
cd "$path_build" || exit 1
echo "Forcing a SHRD build" 

echo $(cat "${SWITCHFILE}") > "${path_build}/tempswitch"

sed -e "s/OMPG / /g"\
    -e "s/OMPH / /g"\
    -e "s/MPIT / /g"\
       "${path_build}/tempswitch" > "${path_build}/switch"
rm "${path_build}/tempswitch"

echo "Switch file is $path_build/switch with switches:" 
cat "${path_build}/switch "

cp ${path_build}/switch ${finalexecdir}/switch 

#Build executables: 
cmake "${WW3_DIR}" -DSWITCH="${path_build}/switch" -DCMAKE_INSTALL_PREFIX=install
rc=$?
if [[ ${rc} -ne 0 ]] ; then
  echo "Fatal error in cmake."
  exit ${rc}
fi
make -j 8
rc=$?
if [[ ${rc} -ne 0 ]] ; then
  echo "Fatal error in make."
  exit ${rc}
fi
make install
if [[ ${rc} -ne 0 ]] ; then
  echo "Fatal error in make install."
  exit ${rc}
fi

# Copy to top-level exe directory
for prog in ${run_exes}; do
  cp "${path_build}/install/bin/${prog}" "${finalexecdir}/"
  rc=$?
  if [[ ${rc} -ne 0 ]] ; then
    echo "FATAL: Unable to copy ${path_build}/${prog} to ${finalexecdir} (Error code ${rc})"
    exit ${rc}
  fi
done

#clean-up build directory:
echo "executables are in ${finalexecdir}" 
echo "cleaning up ${path_build}" 
rm -rf "${path_build}"

exit 0
