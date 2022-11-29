# seniorprojHH2223


This is a repo to keep information for Holly's senior project work


# Step 1: Clone and set-up this repo: 

To clone and set-up your repo, follow the following steps to clone, 
get the submodules (ww3 and alphabeta lab which connect to their own repos), 
and then copy in the mesh grid files which are too large to put in GitHub: 

```
git clone https://github.com/JessicaMeixner-NOAA/seniorprojHH2223 foldername
cd foldername
git submodule update --init --recursive 
sh setupgrids.sh
```

# To build WW3: 

To build WW3 you will need to update three variables in the build ww3 script: 

SWITCHFILE   - the path to your switch file 
WW3_DIR      - path to ww3 (ie $fullpath/$foldername/ww3) 
finalexecdir - the folder destination for the executables to be built 

After updating these variables, run the build script: 

```
sh build_ww3.sh
```

Note: Please don't save/add the exec directory to github. 



# To plot figures of the grids: 

To plot the element structure, min/max size of grids and the bathymetry, you can 
use the job script PlotGrid/jop_plot.sh which has the correct modules to 
run PlotGrid/plot_elementinfo_unstr.py.   There are two inputs to the python
script that will need to be updated with path to your mesh file and what the 
descriptor should be when saving the files. 

You can copy the job_plot.sh script so that you submit many different jobs 
at the same time with different grids.  Just make sure to use a different 
descriptor so that they'll save the files as a different localtion. 

For the min/max grid size plots and to help with uniformity and making sure 
you have the right colorbar, you can update the min and max values which are named: 
```
  vpltmin=1
  vpltmax=50
```
in PlotGrid/plot_elementinfo_unstr.py

Note, the first time you run the python script, cartopy and other python plotting
will need to download shapefiles.  This is usually more successful from the 
command line so if your jobs time out with 'DownloadWarning: Downloading:' 
run the python script from the command line once with the smallest grid you have. 


# Make runs 

In grids there are folders with various grids which were created by Ali Abdolali. 
See info about them (here)[https://docs.google.com/spreadsheets/d/1DYgORKOEd_QJifl3F36tihRiw7_AZI7nOIfjRpxr8Ng/edit?usp=sharing] 
and you can use the PlotGrid scripts to plot figures of each of them. 

In each of the grid directories, there is a "job_prep.sh" and then a "job_run.sh" 
The job_prep will create all the input files in the directory and then 
the "job_run" will run multi.  Note you will need to change the path to the 
exe directory to use your own execs. These runs will have the spin-up and they will 
have individual outputs.  This means, that you can justupdate your ww3_multi.inp with 
the next restart time and keep running if you want instead of making new folders.  
Completely up to you. ww3_post.sh jobs are in progress but not yet finished.  

Steps to follow: 
1. Update WW3EXECDIR in job_prep.sh and job_run.sh scripts
2. In job_run.sh you can update the number of nodes, tasks per node and srun if you want 
3. sbatch < job_prep.sh 
4. After prep job runs, make sure you update WW3EXECDIR in job_run.sh and any other updates you want 
5. sbatch < jop_run.sh 
6. Make the netcdf output by running the following two jobs.  Make sure to update WW3EXECDIR in each first: 
   sbatch < job_post.sh 
   sbatch < job_post_pnt.sh
7. Combine the netcdf output to have one file: 
   sbatch < job_combine_grid.sh
   sbatch < job_combine_pnt.sh 

# validation

Validation jobs will also eventually be added. 

# obstruction grid 

Lastly, I was able to get an ubstruction grid calculated for the 100km grid.  I have not yet made any runs from this yet, but we can make them!   See ObstGrid/job_obs.sh which has the job script (need to update python path) and then ou need to update ObstGrid/obstFileBuilder.py to point to your msh file and what the output directory should be called.  Lastly you could point to your own etopo file, but you can point to mine for now.  




TODO -- add info about where to get etopo file

 







