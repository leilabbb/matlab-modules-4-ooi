% Name: uFrameDataread
% Purpose: Generate a report on UFrame ADCP datasets
% Author: Leila Belabbassi
% Depatment: Marine and coastal science
% University: Rutgers
% Date: April 08, 2015

clear all
close all

% Define input variables
	% data file
url = 'http://opendap.oceanobservatories.org/thredds/dodsC/rest-in-class/Coastal_Endurance/CE05MOAS/05-CTDGVM000/recovered_host/CE05MOAS-GL319-05-CTDGVM000-ctdgv_m_glider_instrument_recovered-recovered_host/CE05MOAS-GL319-05-CTDGVM000-ctdgv_m_glider_instrument_recovered-recovered_host.ncml';
%'http://opendap.oceanobservatories.org/thredds/dodsC/rest-in-class/Coastal_Endurance/CE05MOAS/05-CTDGVM000/recovered_host/CE05MOAS-GL311-05-CTDGVM000-ctdgv_m_glider_instrument_recovered-recovered_host/CE05MOAS-GL311-05-CTDGVM000-ctdgv_m_glider_instrument_recovered-recovered_host.ncml';

    % parameter to check gaps
parameter = 'time';

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
[meta,t0,ti,tvar,file_id] = A_read_ncml(url,fidb);


if length(tvar) > 1
    
    disp('***report on data file time sequence')
    [tdate,tflag,sdate,h,pdr,psr] = C_time_seq_check(tvar,filea,fida,file2,fid2,...
                                                        url,parameter);
    disp('***return the mode(s) and frequency')
    [spmode,sprate_unique,H] = D_return_mode(tdate,fid1,fida);
    
    disp('***check time column gaps')
    [ndate,cnt] = E_IDTimeGaps(tdate,fid3,fida,fid4);   
    
    fprintf(fida,'%s%d%s\n','Common sampling interval : ',spmode,' sec');
    
    disp('***delete empty files')
    F_delete_empty_files(filea,file1,file2,file3,file4)

end

disp('*** move files to a folder assigned with the name of the file being assessed')
movefiles_2_folder(OutputDir,file_id,filea_name,fileb_name,file1_name,file2_name,file3_name,file4_name);