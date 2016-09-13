% Name: One_day_gap_check.m
% Purpose: 
%     checks:
%         time sequence
%         time duplicates
%         time gaps
%         nan values
%         zero values
%         negative values
%         fill values
%     returns:
%         parameters list
%         sampling rates and freuqencies
% Author: Leila Belabbassi
% Depatment: Marine and Coastal Science
% University: Rutgers the State University of New Jersey
% Date: September 09, 2016

clear all
close all

% Define input variables

	% data file
url = 'http://opendap.oceanobservatories.org/thredds/dodsC/rest-in-class/Coastal_Endurance/CE05MOAS/05-CTDGVM000/telemetered/CE05MOAS-GL319-05-CTDGVM000-ctdgv_m_glider_instrument-telemetered/CE05MOAS-GL319-05-CTDGVM000-ctdgv_m_glider_instrument-telemetered.ncml';
%'http://opendap.oceanobservatories.org/thredds/dodsC/rest-in-class/Coastal_Endurance/CE05MOAS/05-CTDGVM000/recovered_host/CE05MOAS-GL311-05-CTDGVM000-ctdgv_m_glider_instrument_recovered-recovered_host/CE05MOAS-GL311-05-CTDGVM000-ctdgv_m_glider_instrument_recovered-recovered_host.ncml';

    % deployment time info
deployment_num = '3';
d_strat_time = '2015-10-08T22:55:00';%'2014-04-20T18:26:00';
d_end_time = '2015-11-22T00:00:00';%'2014-05-28T00:00:00';
    
ds_date = datenum(d_strat_time,'yyyy-mm-ddTHH:MM:SS');
de_date = datenum(d_end_time,'yyyy-mm-ddTHH:MM:SS');
    
    % parent output directory
OutputDir = '/Users/leila/Documents/MATLAB/matlab-modules-4-ooi/';

    % output files
filea_name = 'Time_check_report.txt';
fileb_name = 'Parameter_list_check.csv';
file1_name = 'Time_sample_rate_frequency.txt';
file2_name = 'Time_data_in_sequence.txt';
file3_name = 'Time_gap.txt';
file4_name = 'Time_gap_id.txt';

% begin running programing functions 

disp('***create output files')
[filea,fida,fileb,fidb,file1,fid1,file2,fid2,file3,fid3,file4,fid4] = ...
     B_create_output_files(OutputDir,filea_name,fileb_name,file1_name,...
                                         file2_name,file3_name,file4_name);
 
disp('***read ncml file and extract the time parameter array')
[meta,t0,ti,tvar,file_id,refdes,subsite_id,time_data] = A_read_ncml(url,fidb);


if length(tvar) > 1
    
    disp('***report on data file time sequence')
    [tdate,tflag,sdate,h,pdr,psr] = C_time_seq_check(tvar,filea,fida,file2,fid2,...
                                                        url,time_data);
    disp('***return the mode(s) and frequency')
    [spmode,sprate_unique,H] = D_return_mode(tdate,fid1,fida);
    
    disp('***check for gaps')
    % modify tdate(:) to (1:10)select the indicies of the range of time you want to check  by 
    
    if ~isempty(deployment_num) 
         disp(['***deployment: ',deployment_num])
         ind_s = find(tdate >= ds_date);
         if isempty(ind_s)
             disp('start date of deployment could not be found in the file. Defaulting to first data 1')
             ind_si = 1;
         else
             ind_si = ind_s(1);
         end
         ind_e = find(tdate <= de_date);
         if isempty(ind_e)
             disp('end date of deployment could not be found in the file. Defautling to last data point')
             ind_ei = length(tdate);
         else
             ind_ei = ind_e(length(ind_e));
         end
         
         if ds_date ~= tdate(ind_si)
             disp('the deployment start date could not be matched in the data')
             fprintf(fida,'%s\n','!!! the deployment start date could not be matched in the data:');
             fprintf(fida,'%s%s\n','Deployment start date: ',datestr(ds_date));
             fprintf(fida,'%s%s\n','Date in Data: ',datestr(tdate(ind_si)));
         end
         if tdate(ind_ei) ~= tdate(length(tdate))
             disp('the deployment end date is different than the data end date')
             fprintf(fida,'%s\n','!!! the deployment end date is different than the data end date:');
             fprintf(fida,'%s%s\n','Deployment end date: ',datestr(de_date));
             fprintf(fida,'%s%s\n','Date in data: ',datestr(tdate(ind_ei)));
             if ind_ei+1 ~= length(tdate)
                fprintf(fida,'%s%s\n','next timestamp',datestr(tdate(ind_ei+1))); 
             else
                fprintf(fida,'%s%s\n','last timestamp',datestr(tdate(length(tdate))));
             end
         end      
    else
      ind_si = 1;
      ind_ei = length(tdate);
      deployment_num = 'all';
    end
    
    [ndate,cnt] = E_IDTimeGaps(tdate(ind_si:ind_ei),fid3,fida,fid4);  
    
    fprintf(fida,'%s%d%s\n','Common sampling interval : ',spmode,' sec');
    
    disp('***delete empty files')
    F_delete_empty_files(filea,file1,file2,file3,file4)
end

disp('*** move files to a folder assigned with the name of the file being assessed')
G_movefiles_2_folder(OutputDir,deployment_num,file_id,filea_name,fileb_name,file1_name,file2_name,file3_name,file4_name);