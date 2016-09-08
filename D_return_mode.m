function [spmode,sprate_unique,H] = D_return_mode(tdate,fid1,fida)

    %Return sampling rates and frequescies 
    sprate = seconds(tdate(2:length(tdate))) - seconds(tdate(1:length(tdate)-1)); 
    sprate = seconds(sprate)*24*60*60; % elapsed time in seconds
    sprate = round(sprate,4);
    [spmode,spfreq] = mode(sprate); % returns the smallest number which happens more than any other in the set.  

    sprate_unique = unique(sprate); % method to return all modes
    H = histc(sprate,sprate_unique); % method to return all frequecies of the previous returened modes
    bar(sprate_unique,H,'histc');
        %     hist(sprate_num,[0.00003,0.00004,0.00005,0.00006,0.00007,0.00008,0.04,0.05,0.06,0.07,0.08])
        %     plot(H)
    sprate_unique(H==max(H)) % another way to get the first mode
    
    fprintf(fida,'%s%d\n','Number of different sampling rates used in the data: ',length(H));
    
    fprintf(fid1,'%s%s%s\n','sample rate(sec)','   ','number of time used');
    for ii = 1:length(H)
        fprintf(fid1,'%d%s%d\n',sprate_unique(ii),'                        ',H(ii));
    end

end