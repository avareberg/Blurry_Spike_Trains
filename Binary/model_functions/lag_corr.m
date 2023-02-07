function [] = lag_corr(Nc, tlength, hz, numSets)
    maxlag = 5;
    pspike = hz/1000;
    for mm = 1:numSets
        load(['../DataSets/',num2str(pspike*1000),'Hz_Set',num2str(mm),'_',int2str(Nc),'c_',int2str(tlength),'s.mat'])
        corrvec = [];
        for jj = 1:length(conmat)
            x = zeros(2*maxlag+1,1);
            for k = 1:tlength
                ypre = spike_pre(:,jj,k);
                ypost = spike_post(:,k);
                [x2,~] = xcorr(ypost,ypre,maxlag);
                x = x+x2;
            end
            m1 = mean(x([1:maxlag,(maxlag+2):end]));
            s1 = std(x([1:maxlag,(maxlag+2):end]));
            corrvec(jj) = (x(maxlag+1)-m1)/s1;
        end
        save(['../DataSets/lagcorr',num2str(pspike*1000),'Hz_Set',num2str(mm),'_',int2str(Nc),'c_',int2str(tlength),'s.mat'],'corrvec')
    end
end




