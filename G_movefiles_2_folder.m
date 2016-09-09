function G_movefiles_2_folder(OutputDir,file_id,filea_name,fileb_name,file1_name,file2_name,file3_name,file4_name)

% create an output directory with reference to file name
output_dir = [OutputDir,file_id];
%mkdir(output_dir);
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

cd(OutputDir)