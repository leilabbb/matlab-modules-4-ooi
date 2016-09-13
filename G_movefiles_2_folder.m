function G_movefiles_2_folder(OutputDir,deployment_num,file_id,filea_name,fileb_name,file1_name,file2_name,file3_name,file4_name)

% create an output directory with reference to file name
output_dir = [OutputDir,file_id];
if exist(output_dir,'dir') ~= 0 
   rmdir(output_dir,'s');
   mkdir(output_dir);
else
   mkdir(output_dir); 
end

% move to the assessed file folder
cd(output_dir)
movefile([OutputDir,filea_name])
movefile([OutputDir,fileb_name])
movefile([OutputDir,file1_name])
movefile([OutputDir,file2_name])
movefile([OutputDir,file3_name])
movefile([OutputDir,file4_name])

% create a sub_directory with reference to deployment
sub_dir = ['_',deployment_num,'_deploy'];
if exist(sub_dir,'dir') ~= 0 
   rmdir(sub_dir,'s');
   mkdir(sub_dir);
else
   mkdir(sub_dir); 
end

cd(sub_dir)
if strcmp(deployment_num,'all') == 1
    movefile([output_dir,'/',filea_name])
    movefile([output_dir,'/',fileb_name])
    movefile([output_dir,'/',file1_name])
    movefile([output_dir,'/',file2_name])
    movefile([output_dir,'/',file3_name])
    movefile([output_dir,'/',file4_name])    
else
    movefile([output_dir,'/',filea_name])
    movefile([output_dir,'/',file3_name])
    movefile([output_dir,'/',file4_name])
end



cd(OutputDir)