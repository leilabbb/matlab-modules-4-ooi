function [tdate,tflag,sdate,h,pdr,psr] = C_time_seq_check(datain,filea,fida,file2,fid2,filesource,sname)
                                           
    % NAME:
    %   Asequence.m    
    % PURPOSE:
    %   To write a time sequenced format of sensor data
    %   
    % HISTORY:
    %   L. Belabbassi, March 2015
    %   Department of Marine and Coastal Science
    %   Rutgers University
    %   Copyright Rutgers
    %*********************************************************************************************************
    %indf = fopen(file0,'wt');  % raw data flagged
    %fiind = fopen(file1,'wt'); % duplicated data

    vartime = datain(:,1);

    fprintf(fida,'%s\n',...
    '-----------------------------');      
    fprintf(fida,'%s\n',...
    'Rest-In-Class Data Evaluation'); 
    fprintf(fida,'%s\n',...
    '-----------------------------');
    fprintf(fida,'%s\n%s\n',...
    'Test Case 1___','The parameter''s record is complete');
    fprintf(fida,'%s\n',' ');
    
    fprintf(fida,'%s\n%s\n',...
    'File Source___',filesource); 
    fprintf(fida,'%s\n',' ');
    fprintf(fida,'%s\n%s%s\n',...
    'Parameter Examined___',...
    '   ',sname);
    fprintf(fida,'%s\n','  ');
    fprintf(fida,'%s\n',...
    'Assessment___');
    fprintf(fida,'%s\n',' ');
    % Sort the date column in ascending order

    [sdate,h] = sort(vartime,'ascend');
    checkseq = vartime - sdate;

    fprintf(fida,'%s%d\n%s\n','Number of Timestamps: ',length(vartime),' ');
    fprintf(fida,'%s%s\n%s\n','Start Date: ', datestr(sdate(1),31),' ');
    fprintf(fida,'%s%s\n%s\n','End Date: ', datestr(sdate(length(vartime)),31),' ');
   
    % Define VARIABLE SIZE

    fdate = ((1:length(sdate)))';
    fdate(:) = -999;

    flag = ((1:length(sdate)));  
    flag(:) = -999;

    if size(fdate) ~= size(sdate) 
       disp('problem in matrix dim')
    end   

    for jl = 1:length(sdate)
        if vartime(h(jl)) ~= sdate(jl)
           disp('problem sorting date column in ascending order')
        end
        fdate(jl) = vartime(h(jl));
    end
    
    if length(sdate) == 1
        disp 'length of column date = 1'
        fprintf(fid2,'%s %d\n',datestr(fdate(1),31),0);
        tdate=0;tflag=0;sdate=0;h=0;pdr=0;psr=0;
    else
        disp 'length of column > 1'
        flag(1) = 0;%index to Generate file with sequenced stamps
        fdd(1) = fdate(1);
        %fprintf(indf,'%s %d\n', datestr(fdd(1),31),flag(1));

        for n = 1:length(sdate)-1           
            if sdate(n) ~= sdate(n+1)
                   flag(n+1) = 0; %index to Generate file with sequenced stamps
                   fdd(n+1) = fdate(n+1);
                  % fprintf(indf,'%s %d\n',...
                           %datestr(fdd(n+1),31),flag(n+1));
             else
                   flag(n+1) = 1; %index to Generate file with extra stamps 
                   fdd(n+1) = fdate(n+1);
                   %fprintf(indf,'%s %d\n',...
                          %datestr(fdd(n+1),31),flag(n+1));
             end
        end

    %   Generating a sequence file...
        ind1 = find(flag(:) == 0);     
        if isempty(ind1) == 0
            sequence_I = ind1;                   
            disp('generating a sequence file')
           for jj = 1:length(ind1) 
               seqdate(jj) = fdate(sequence_I(jj));
               seqflag(jj) = flag(sequence_I(jj));
               if seqflag(jj) ~= 0
                  disp('problem in filtering sequence time column')
               end
               fprintf(fid2,'%s %d\n',...
                    datestr(seqdate(jj),31),seqflag(jj));         
           end

           fclose(fid2);
           of4 = dir(file2);
           if of4.bytes == 0
              delete(file2)
           end
           
           
        %  read data column into the output arguments
           fxd = fopen(file2,'r');
           l1 = textscan(fxd,'%s %s %d');

           [nrows,ncols]= size(l1);

           if isempty(l1{1})
              disp('check the size of the input var')
           end
           % convert date time to matlab usuable format
           at1 = l1{1};
           bt1 = l1{2};
           ct1 ='!';
           dt1 = strcat(at1,ct1);
           et1 = strcat(dt1,bt1);

           DateTime = regexprep(et1,'!',' ');

           tdate = datenum(DateTime);
           tflag = l1{3};
        end
         psr = (length(tdate)/length(vartime))*100; %percent of sequence records

        if isempty(find(checkseq ~= 0))
            fprintf(fida,'%s\n','Time array in ascending order.');
        else
            fprintf(fida,'%s\n','Time array is not in ascending order.');
            fprintf(fida,'%s%s\n',...
             '            Start Date of sequenced data: ',datestr(tdate(1),31));
             fprintf(fida,'%s%s\n',...
             '                  End Date of sequenced data: ',datestr(tdate(length(tdate)),31));
             fprintf(fida,'%s\n',...
             '                  ');
        end

    %   generate the duplicate stamps file 
        ind2 = find(flag == 1);
        if isempty(ind2) == 0
            disp('extracting duplicated date and moving them to a different file')
            extdate = ((1:length(ind2)));
            extdate(:) = -999;
            extra_I = ind2; %h(ind2);                   
            %sprintf(1,'outfile2 %s\n',outfile2(77:end));
            for l = 1:length(ind2)
                extdate(l) = fdate(extra_I(l));
                extflag(l) = flag(extra_I(l));
                if extflag ~= 1
                    disp('problem filtering duplicate time column')
                end
                %fprintf(fiind,'%s %d\n',...
                  %datestr(extdate(l),31),extflag(l)); 
            end
    %         fclose(fiind);
    %         of2=dir(file1);
    %         if of2.bytes == 0
    %             delete(file1)
    %         end 
             pdr= (length(extdate)/length(vartime))*100;%percentDuplicateRecord

             fprintf(fida,'%s\n','   ');          
             fprintf(fida,'%s%d\n',...
             'Number of Duplicate Timestamps: ',length(extdate));
             fprintf(fida,'%s\n','  ');
             fprintf(fida,'%s%d%s%3.0f%s\n',...
             'Total Timestamps After Removing Duplicates: ',length(tdate),'(Represents:',pdr,'%)');
             fprintf(fida,'%s%s\n',...
                'Date of Occurrence of First Duplicate timestamp: ',datestr(extdate(1),31));
             fprintf(fida,'%s%s\n',...
                ' Date of Occurrence of Last Duplicate timestamp: ',datestr(extdate(length(ind2)),31)); 

        else  
            pdr = 0;
            fprintf(fida,'%s\n','   ');
             fprintf(fida,'%s%d\n',...
            'Number of Duplicate Timestamps: ',0);        
        end


    %          Generate same stamps file                
    %             ind3 = find(flag == 2);
    %             if isempty(ind3) == 0
    %                 stamps_I = h(ind3);
    %                 %sprintf(1,'outfile3 %s\n',outfile3(77:end));
    %                 for n = 1:length(ind3)
    %                     jdate(n) = vartime(1,stamps_I(n));
    %                     jx(1,n) = varpres(1,stamps_I(n));
    %                     fprintf(fiisd,'%s %f \n',...
    %                     datestr(jdate(n),31),jx(n));
    %                 end
    %            end
    %       fclose(fiisd);
    %         of3=dir(outfile3);
    %         if of3.bytes == 0
    %             delete(outfile3)
    %         end        


    end
    %fclose(indf);   
    %of0=dir(file0);
    % if of0.bytes == 0
    % delete(file0)
    % end

end



