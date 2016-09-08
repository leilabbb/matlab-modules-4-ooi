function [meta,t0,ti,tvar,file_id] = A_read_ncml(url,fidb)

    % read data file  
    meta = ncinfo(url);

    % return file name
    attri_name = {meta.Attributes.Name}';
    file_ind = find(strcmp(attri_name,'id') == 1);
    attri_value =  {meta.Attributes.Value}';
    file_id = attri_value{file_ind};

    disp(['file id:', file_id]);

    % make a parameter array and gets its attribute
    
    fprintf(fidb,'%31s,%31s,%20s,%20s,%20s,%20s,%20s,%20s,%20s,\n',...
           'parameter_name  ','parameter_unit  ',...
           'parameter_size','min_val  ','max_val  ','isnan_val  ',...
           'iszeros_val  ','isnegatif_val  ','isFill_val');
        
    NCML_par_list = {meta.Variables.Name}';
    NCML_par_type = {meta.Variables.Datatype}';
       
    for ii = 1:length(NCML_par_list)
        if strcmp(NCML_par_type(ii),'char') == 0
            disp(NCML_par_list(ii))
            ind_qc = strfind(NCML_par_list(ii),'_qc_');
            disp(ind_qc{1,1})
            ind_qc_check = isempty(ind_qc{1,1});
            disp(ind_qc_check)
            if ind_qc_check == 1
%         parameter_ind = find(strcmp(NCML_par_list,parameter) == 1);
%         parameter_name = NCML_par_list(parameter_ind);        
%         parameter_unit  = {meta.Variables(parameter_ind).Attributes(1).Value(1:end)};
%         parameter_size  = {meta.Variables(parameter_ind).Size}; 
%         parameter_size_num   = cell2mat(parameter_size);
%         parameter_data = ncread(url,NCML_par_list{parameter_ind});
                parameter_name = NCML_par_list(ii)
                parameter_size = {meta.Variables(ii).Size}; parameter_size_num   = cell2mat(parameter_size);
                parameter_data = ncread(url,NCML_par_list{ii});            
                min_val = min(parameter_data);
                max_val = max(parameter_data);
                nan_val = length(find(isnan(parameter_data)==1));
                zeros_val  = length(find(parameter_data == 0));
                negatif_val = length(find(parameter_data < 0));
                
                NCML_par_att = {meta.Variables(ii).Attributes};

                if ~isempty(NCML_par_att{1,1})
                    list_att = NCML_par_att{1,1};
                    ind_unit = find(cellfun(@(x)strcmp(x,'units'),{list_att.Name}) );
                    
                    if ~isempty(ind_unit)
                         parameter_unit  = {list_att(ind_unit).Value};
                    else
                         parameter_unit = {''};
                    end
                    
                    ind_fillvalues = find(cellfun(@(x)strcmp(x,'_FillValue'),{list_att.Name}));
                     if ~isempty(ind_fillvalues)
                         parameter_FV  = {list_att(ind_fillvalues).Value};
                         disp(parameter_FV{1})
                         Fill_val = length(find(parameter_data == parameter_FV{1}));
                    else
                         Fill_val = '';
                    end
                    
                else
                    parameter_unit = {''};
                    Fill_val = '';
                end

                fprintf(fidb,'%32s,',char(parameter_name));
                fprintf(fidb,'%32s,',char(parameter_unit{1}));
                fprintf(fidb,'%23d,',parameter_size_num);
                fprintf(fidb,'%15.4f,%15.4f,%15d,%15d,%15d,%15d\n',min_val,max_val,...
                                            nan_val,zeros_val,negatif_val,Fill_val);

                if strcmp(parameter_name,'time') == 1
                    tvar = ((parameter_data(:,1))/86400) + datenum(1900, 1, 1, 0, 0, 0);
                    t0 = tvar(1);
                    disp(['Start time:', datestr(t0)]);
                    ti = tvar(length(tvar));
                    disp(['End time:', datestr(ti)]);
                end
            end
        end
    end
    fclose(fidb);
end

