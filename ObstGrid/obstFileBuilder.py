import numpy as np

# importing from alphaBetaLab the needed components
from alphaBetaLab.abOptionManager import abOptions
from alphaBetaLab.abEstimateAndSave import triMeshSpecFromMshFile, abEstimateAndSaveTriangularEtopo1


#this is the example from alphabeta modified by Steven Brus and then Jessica 

# definition of the spectral grid
dirs = np.linspace(0, 2*np.pi, 36)
#offset by 0.5:
offset = 0.05*pi/180 
dirs = dirs + offset
nfreq = 50
minfrq = .035
frqfactor = 1.07
freqs = [minfrq*(frqfactor**i) for i in range(1,nfreq + 1)]

# definition of the spatial mesh
gridname = 'glo_unst100km'
mshfile = 'unst_glo_100km.msh'
mshfile = '/work2/noaa/marine/jmeixner/unstructuredgrids/v0/grids/glo_100km/unst_glo_100km.msh'
triMeshSpec = triMeshSpecFromMshFile(mshfile)

# path of the etopo1 bathymetry
#etopoFilePath = '/users/sbrus/scratch4/WW3_unstructured/GEBCO_2019.nc'
#etopoFilePath = '/users/sbrus/scratch4/WW3_unstructured/etopo1_180.nc'
etopoFilePath = '/work2/noaa/marine/jmeixner/gridgeneration/gridgen/reference_data/etopo1.nc'

# output directory
outputDestDir = './output/'

# number of cores for parallel computing
nParWorker = 10 

# this option indicates that the computation should be skipped for cells smaller than 3 km
minSizeKm = 3
opt = abOptions(minSizeKm=minSizeKm)

# instruction to do the computation and save the output
#abEstimateAndSaveTriangularGebco(dirs, freqs, gridname, triMeshSpec, etopoFilePath, outputDestDir, nParWorker, abOptions=opt)
abEstimateAndSaveTriangularEtopo1(dirs, freqs, gridname, triMeshSpec, etopoFilePath, outputDestDir, nParWorker, abOptions=opt)

