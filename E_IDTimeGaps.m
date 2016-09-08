function [bdate,cnt] = E_IDTimeGaps(tdate,fid3,fida,fid4)	

    tdate = tdate';

    fprintf(fid4,'%10s %10s %10s %27s\n',...
                 'Gap','start(id)','end(id+1)',' number of missing timestamps');
    
    fprintf(fid3,'%s %s %s %s %s\n',...
                      'time_i','time_i+1','gap(sec)','gap(day)','identified');
    D = length(tdate);
    id = 1;
    ti = 24*60*60;% ti = 1 day in seconds. %spmode % (1./(24*60*60))
    tia = ti ;%+0.0006;  % plus 1 Minute
    %tia = ti + (1/(24*60*60*15)); % 0.00347;  % plus 5 Minute
    cnt = 0;
    %Check for time gaps in series

    for j = 1:D-1
        disp(j)
        if j+1 <= length(tdate)
           spgap = seconds(tdate(j+1)) - seconds(tdate(j));            
           tgap = seconds(spgap)*24*60*60;
          
          if (tgap > tia)
              disp(tgap)
              cnt = cnt+1;
              bdate(1,id) = tdate(1,j);
              fprintf(fid3,'%s %s %3.0f %3.0f %s \n',...
                      datestr(tdate(j),31),datestr(tdate(j+1),31),...
                                                tgap,tgap/86400,'gap');

              % add and count how many timestamps are missing 
              ni = round(tgap/ti+0.0000000005);%(ti*0.1)
              id = id + 1;
              in = 1;
              for ia = 2:ni
                   in = in + 1;
                   bdate(1,id)  = tdate(j)+ ti*(ia-1);
                   ngap = bdate(1,id) - bdate(1,id-1);
    %                fprintf(fid3,'%s %3.0f %s \n',...
    %                datestr(bdate(id),31),ngap*24*60*60,'missing');
                   id = id+1;
              end 

              fprintf(fid4,'%10d%10d%10d%10d\n',cnt,j,j+1,in); 

              tgap2 = tdate(j+1) - bdate(id-1);
              if(tgap2 > tia)
                   bdate(1,id)  = bdate(id-1)+ ti;
                   ngap2 = bdate(1,id) - bdate(id-1);
    %               fprintf(fid3,'%s %3.0f %s \n',...
    %               datestr(bdate(id),31),ngap2*24*60*60, 'missing');
                   id = id+1;
              end
          else 
              %disp('no gap of 1 day or more')
              bdate(1,id) = tdate(1,j);                   
              id = id +1;          
              %fprintf(fid3,'%s %s %3.0f %s\n',...
              %    datestr(bdate(id),31),tgap,tgap/86400,'no gap');          
         end    
       end  
    end

    Dl = length(tdate);
    j = Dl;
    bdate(1,id)  = tdate(1,j);
    kgap = seconds(bdate(1,id))  - seconds(tdate(1,j-1));
    ttgap = seconds(kgap)*24*60*60;

    if ttgap > tia
        disp('gap found at the last timestamp')
        fprintf(fid3,'%s %s %3.2f %s \n',...
            datestr(tdate(j-1),31),datestr(tdate(j),31),ttgap,ttgap/86400,'gap');
    else
        disp('no gap of 1 day or more at the last timestamp')
        %fprintf(fid3,'%s %s %3.0f %s \n',...
        %    datestr(bdate(id),31),sttgap,ttgap,'no gap');   
    end

    fclose(fid3);
    fclose(fid4);

    fprintf(fida,'%s%d\n','Number of Gaps = ',cnt);
end
  