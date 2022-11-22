# seniorprojHH2223


This is a repo to keep information for Holly's senior project work


# To clone and set-up this repo: 

'''
git clone https://github.com/JessicaMeixner-NOAA/seniorprojHH2223 foldername
cd foldername
git submodule update --init --recursive 
sh setupgrids.sh
'''

# To build WW3: 
Update SWITCHFILE to be the path to your switch file 
Update WW3_DIR to point to the path to ww3 (ie $fullpath/$foldername/ww3) 
Update finalexecdir to point to where you want to keep these execs 
Then run the build script: 

'''
build_ww3.sh
'''

note: don't save the exec directory to github 



# To plot figures of the grids: 

See the PlotGrid/jop_plot.sh jobcard where it has the general set-up.  
You need to give it the filename.msh file and  a nick-name for the 
grid, that will be used when saving the grid files. 

Update the values on the min/max for the size of grid plots by changing 
'''
  vpltmin=1
  vpltmax=50
'''
in 
PlotGrid/plot_elementinfo_unstr.py

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

#validation

Validation jobs will also eventually be added. 

#obstruction grid 

Lastly, I was able to get an ubstruction grid calculated for the 100km grid.  I have not yet made any runs from this yet, but we can make them!   See ObstGrid/job_obs.sh which has the job script (need to update python path) and then ou need to update ObstGrid/obstFileBuilder.py to point to your msh file and what the output directory should be called.  Lastly you could point to your own etopo file, but you can point to mine for now.  

#TODO -- add info about where to get etopo file

 







