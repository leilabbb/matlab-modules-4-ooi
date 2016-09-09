function [meta,t0,ti,tvar,file_id,refdes,subsite_id,time_data] = A_read_ncml(url,fidb)

    % read data file  
    meta = ncinfo(url);

    % return file name references
    attri_name = {meta.Attributes.Name}';
    attri_value =  {meta.Attributes.Value}';
    
    file_ind = find(strcmp(attri_name,'id') == 1);   
    file_id = attri_value{file_ind};

    disp(['file id:', file_id]);
    
    subsite_ind = find(strcmp(attri_name,'subsite') == 1);
    subsite_id = attri_value{subsite_ind};
    
    node_ind = find(strcmp(attri_name,'node') == 1);
    node_id = attri_value{node_ind};
    
    sensor_ind = find(strcmp(attri_name,'sensor') == 1);
    sensor_id = attri_value{sensor_ind};
    
    refdes = [subsite_id,'-',node_id,'-',sensor_id];
    
    disp(['Reference Designator:', refdes]);
    
    % make a parameter array and gets its attribute
    NCML_par_list = {meta.Variables.Name}';
    NCML_par_type = {meta.Variables.Datatype}';
    
    pref_time_ind = find(strcmp(NCML_par_list,'preferred_timestamp') == 1);
    if ~isempty(pref_time_ind)
        time_name = NCML_par_list(pref_time_ind);
        parameter_data = ncread(url,NCML_par_list{pref_time_ind});
        time_text = parameter_data';
        time_data = time_text(1,1:64);                   
        disp(['preferred_timestamp:', time_data]);
        fprintf(fidb,'%32s,',char(time_name));
        fprintf(fidb,'%32s,%23s,\n','listed as: ',time_data);
    else
        fprintf(fidb,'%32s,\n','preferred_timestamp is not listed in the file')
    end
    
    fprintf(fidb,'%s,\n','____');
    fprintf(fidb,'%31s,%31s,%20s,%20s,%20s,%20s,%20s,%20s,%20s,\n',...
           'parameter_name  ','parameter_unit  ',...
           'parameter_size','min_val  ','max_val  ','isnan_val  ',...
           'iszeros_val  ','isnegatif_val  ','isFill_val');
  
    for ii = 1:length(NCML_par_list)
        if strcmp(NCML_par_type(ii),'char') == 0
            disp(NCML_par_list(ii))
            ind_qc = strfind(NCML_par_list(ii),'_qc_');
            disp(ind_qc{1,1})
            ind_qc_check = isempty(ind_qc{1,1});
            disp(ind_qc_check)
            if ind_qc_check == 1
                parameter_name = NCML_par_list(ii);
                parameter_size = {meta.Variables(ii).Size}; parameter_size_num  = cell2mat(parameter_size);
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
                            
                if strcmp(parameter_name,cellstr(time_data)) == 1
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

