close all
clear all

%% User input %%
Nc = 29; % Number of presynaptic channels
tlength = 900; % length of recording (ms)
maxlag = 0; % Maximum +- time lag ms)
savePath = '.\CorrVecs\';

%% Main %%
data = load('FisherCells-210215-181709.mat');
spikes = data.channel_values;
spike_pre = spikes(1:end-1,:);
spike_post = spikes(end,:);
corrvec = zeros(Nc +1);
lagvec = corrvec;
corrvec_nolag = lagvec;
for j = 1:Nc +1
    j
    x = zeros(2*maxlag+1,1);
    for k = 1:Nc +1
     
    ypre = spikes(k,:);
    ypost = spikes(j,:);
    [x2,lags] = xcorr(ypost,ypre,maxlag,'normalized');
    m1 = mean(x2([1:maxlag,(maxlag+2):end]));
    s1 = std(x2([1:maxlag,(maxlag+2):end]));
    [maxX2, idx] = max(x2);
    if maxX2 < 10^-4
        [maxX2, idx] = min(x2);
    end
    lagvec(j,k) = lags(idx);
    corrvec(j,k) = maxX2;
    
    corrvec_nolag(j,k) = x2(lags == 0);
    corrvec(j,k) = (x(maxlag+1)-m1)/s1;
    end
end
corrvec(corrvec == 1) = NaN;
save([savePath, 'corrvec_maxlag_', num2str(maxlag)], 'corrvec');
save([savePath, 'lagvec_maxlag_', num2str(maxlag)], 'lagvec');
save([savePath, 'corrvec_nolag_', num2str(maxlag)], 'corrvec_nolag');
