
function [filea,fida,fileb,fidb,file1,fid1,file2,fid2,file3,fid3,file4,fid4] = ...
         B_create_output_files(OutputDir,filea_name,fileb_name,file1_name,...
                              file2_name,file3_name,file4_name)


    
    % report on time channel data
    filea = [OutputDir filea_name] ;
    if exist(filea,'file') ~= 0 
       delete(filea);
       filea = [OutputDir filea_name];
    end
    fida = fopen(filea,'a');  

    % list parameters, attributes and checks
    fileb = [OutputDir fileb_name] ;
    if exist(fileb,'file') ~= 0 
       delete(fileb);
       fileb = [OutputDir fileb_name];
    end
    fidb = fopen(fileb,'wt');      
    
    
    % report on mode(s) and frequency(ies)
    file1 = [OutputDir file1_name] ;
    if exist(file1,'file') ~= 0 
       delete(file1);
       file1 = [OutputDir file1_name];
    end
    fid1 = fopen(file1,'wt');  

    % write sequenced data to a file
    file2 = [OutputDir file2_name];
    if exist(file2,'file') ~= 0 
       delete(file2);
       file2 = [OutputDir file2_name];
    end
    fid2 = fopen(file2,'wt');
    
    % write gap duration to a file    
    file3 = [OutputDir file3_name];
    if exist(file3,'file') ~= 0 
       delete(file3);
       file3 = [OutputDir file3_name];
    end   
    fid3 = fopen(file3,'wt');
        
    % write gap occurences and duration to a file
    file4 = [OutputDir file4_name];
    if exist(file4,'file') ~= 0 
       delete(file4);
       file4 = [OutputDir file4_name];
    end
    fid4 = fopen(file4,'wt');
    
end