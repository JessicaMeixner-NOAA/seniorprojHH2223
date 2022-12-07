clear all
%clear all cleans everything in the workspace
clc
%Path to observation output:
obspath='/work2/noaa/marine/jmeixner/Data/2021/buoy/NDBC/ncformat/wparam/OneMonth';
outputfilepath='/work2/noaa/marine/jmeixner/unstructuredgrids/v0/PlotBuoy/out01';
filename1='/work2/noaa/marine/jmeixner/unstructuredgrids/v0/grids/glo_depthC/pnt.glo_depthC.tab.nc';
windfilename1='/work2/noaa/marine/jmeixner/unstructuredgrids/v0/grids/glo_depthC/inp.glo_depthC.tab.nc' ;
smallfile1='/work2/noaa/marine/jmeixner/unstructuredgrids/v0/grids/glo_depthC/ww3.glo_depthC.20211001T00Z_tab.nc';



filename2='/work2/noaa/marine/jmeixner/unstructuredgrids/v0/grids/glo_coast3km/pnt.glo_coast3km.tab.nc';
windfilename2='/work2/noaa/marine/jmeixner/unstructuredgrids/v0/grids/glo_coast3km/inp.glo_coast3km.tab.nc' ;
smallfile2='/work2/noaa/marine/jmeixner/unstructuredgrids/v0/grids/glo_coast3km/ww3.glo_coast3km.20211001T00Z_tab.nc';



filename3='/work2/noaa/marine/jmeixner/unstructuredgrids/v0/grids/glo_m1gfsv16/pnt.glo_m1gfsv16.tab.nc';
windfilename3='/work2/noaa/marine/jmeixner/unstructuredgrids/v0/grids/glo_m1gfsv16/inp.glo_m1gfsv16.tab.nc' ;
smallfile3='/work2/noaa/marine/jmeixner/unstructuredgrids/v0/grids/glo_m1gfsv16/ww3.glo_m1gfsv16.20211001T00Z_tab.nc';




stationname=ncread(smallfile1, 'station_name');
m1=strcat(stationname');
stationname=ncread(smallfile2, 'station_name');
m2=strcat(stationname');
stationname=ncread(smallfile3, 'station_name');
m3=strcat(stationname');
clearvars stationname

%get "allbuoyslist" a list of integers of all buoys data exists for

allbouys;


for ibuoy=1:length(allbuoyslist)
    thisbuoyint=allbuoyslist(ibuoy);
    thisbuoy=string(thisbuoyint)

    fileobs=strcat(obspath,'/',thisbuoy,'h2021.nc')
    
    for i=1:length(m1)
        somevar=m1(i,:);
        somevar2=strfind(somevar,thisbuoy);

        if somevar2==1
            thisbuoynum=i;
        end
    end
    clearvars somevar somevar2

    for i=1:length(m2)
        somevar=m2(i,:);
        somevar2=strfind(somevar,thisbuoy);

        if somevar2==1
            thisbuoynum2=i;
        end
    end
    clearvars somevar somevar2

    for i=1:length(m3)
        somevar=m3(i,:);
        somevar2=strfind(somevar,thisbuoy);

        if somevar2==1
            thisbuoynum3=i;
        end
    end
    clearvars somevar somevar2 

    
    %read data from model files 
    time=ncread(filename1,'time')+datenum(1990,1,1,0,0,0); % Add the "days-since" to the time
    hs=ncread(filename1,'hs');
    wnd=ncread(windfilename1,'wnd');
    %longitude=double(ncread(filename1,'longitude'));
    %latitude=double(ncread(filename1,'latitude'));

    time2=ncread(filename2,'time')+datenum(1990,1,1,0,0,0); % Add the "days-since" to the time
    hs2=ncread(filename2,'hs');
    wnd2=ncread(windfilename2,'wnd');

    time3=ncread(filename3,'time')+datenum(1990,1,1,0,0,0); % Add the "days-since" to the time
    hs3=ncread(filename3,'hs');
    wnd3=ncread(windfilename3,'wnd');




    %Read Observations:
    timeobs=double(ncread(fileobs,'time'))/(24*60*60)+datenum(1970,1,1,0,0,0);
    hstemp=ncread(fileobs,'wave_height');
    hsobs(:)=hstemp(1,1,:);
    wndtemp=ncread(fileobs,'wind_spd');
    wndobs(:)=wndtemp(1,1,:);
    %tpobs=ncread(fileobs,'dominant_wpd');
    %tpavgobs=ncread(fileobs,'average_wpd');

    longitudeobs=double(ncread(fileobs,'longitude'));
    latitudepbs=double(ncread(fileobs,'latitude'));

    datestr(time);
    %show string of time
    %%

    figure
    subplot(2,1,1)
    plot(time,wnd(thisbuoynum,:),'c',time2,wnd2(thisbuoynum2,:),'b',time3,wnd3(thisbuoynum3,:),'m',timeobs,wndobs,'k')
    xlim([min(time) max(time)])
    datetick('x',23,'keeplimits')
    legend('grid a','grid b','grid c','obs')
    ylabel('wind speed [ m/s ]')
    %xlabel('time [days since 1990 01 01]')
    titletext='Buoy ' + thisbuoy + ' (' + longitudeobs + ', ' + latitudepbs + ')'
    title(titletext)
    %%
    %figure
    subplot(2,1,2)
    plot(time,hs(thisbuoynum,:),'c',time2,hs2(thisbuoynum2,:),'b',time3,hs3(thisbuoynum3,:),'m',timeobs,hsobs,'k')
    legend('grid a', 'grid b','grid c', 'obs')
    xlim([min(time) max(time)])
    datetick('x',23,'keeplimits')
    ylabel('hs [ m ]')
    %xlabel('time [days since 1990 01 01]')
    outputfile=strcat(outputfilepath,'/',thisbuoy,'.png')

    saveas(gcf,outputfile)

    close all
    clearvars time  hs wnd time2 hs2 wnd2 time3  hs3 wnd3 
    clearvars timeobs hsobs wndobs thisbuoynum thisbuoynum2 thisbuoynum3 
    clearvars hstemp  wndtemp longitudeobs latitudepbs

end





















