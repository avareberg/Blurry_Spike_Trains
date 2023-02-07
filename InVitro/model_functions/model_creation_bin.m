for iter = 11:20
clearvars -except iter; close all;
addpath(genpath('model_functions'));

Nc          = 200; % 200 feedforward neuron
firing_rate = 5; % firing rate of pre-synaptic neurons: 5Hz
tlength     = 10; % recording duration: 60 seconds
f           = 5000;     % frame rate: 5000 frames/second
num_of_iterations = 100;
stim_fr = 150; % firing rate under stimulation: 100Hz
stim_pulse = 0.012; % stimulation duration : 6 ms
spikes_post_iter = false(1,tlength,1000);
spikes_post_LIF_iter = false(1,tlength,5000);
Nc_LIF = 200; % 200 LIF  
conmat = zeros(Nc,Nc_LIF);
Vm_mid = zeros(Nc_LIF,tlength+1,5001);
spikes_post_LIF = false(5,tlength,f,Nc);
for j = 1:Nc
    conmat(:,j) = generate_conmat(Nc);
end
conmat_LIF= generate_conmat(Nc_LIF); % connectivity matrix
[~,midN] = min(conmat_LIF);
% stimed_spikes_pre = false(tlength,5000,200,200);
for k = 1:1
    k
for i = 1:Nc_LIF
    tic()
    currConmat = conmat(:,i);
    spikes_pre = logical((rand(tlength,f,Nc)<  firing_rate/f)); % pre-synaptic spikes
%     [stimed_spikes_pre(:,:,:,i),t] = stimulate(spikes_pre,stim_fr,stim_pulse);
    [stimed_spikes_pre,t] = stimulate(spikes_pre,stim_fr,stim_pulse);
%     if i == midN
%         stimSpikes = stimed_spikes_pre;
%     end
% %     spikes_pre = [];
%     if i == 200
%         save_stim = stimed_spikes_pre;
%     end
    [Vm_mid(i,:,:),spikes_post] = generate_spike_post(currConmat,stimed_spikes_pre,f);
%     [Vm_mid(i,:,:),spikes_post] = generate_spike_post(currConmat,stimed_spikes_pre(:,:,:,i),f);
    spikes_post = logical(spikes_post);
    spikes_post_LIF(k,:,:,i) = spikes_post;
    spikes_post = [];
    toc()
end
%%
% stimSpikes = stimed_spikes_pre(:,:,:,midN);

[Vm_post,spikes_post_LIF_iter(k,:,:)] = generate_spike_post(conmat_LIF,squeeze(spikes_post_LIF(k,:,:,:)),f);
[spikes_post_iter(k,:,:)] = generate_data_LIF(conmat_LIF,tlength,squeeze(spikes_post_LIF(k,:,:,:)));

end
spikes_post_LIF = reshape(permute(spikes_post_LIF,[2 1 3 4]),tlength*5,5000,200);
spikes_post_LIF_IF = reshape(permute(spikes_post_iter,[2 1 3]),tlength,1000);
spikes_post_LIF_LIF = reshape(permute(spikes_post_LIF_iter,[2 1 3]),tlength,5000);

% spikes_post_LIF = reshape(permute(spikes_post_LIF,[2 1 3 4]),5000,5000,200);
% spikes_post_LIF_IF = reshape(permute(spikes_post_iter,[2 1 3]),5000,1000);
% spikes_post_LIF_LIF = reshape(permute(spikes_post_LIF_iter,[2 1 3]),5000,5000);
try
save(['data_forFig_auto',num2str(iter),'_I.mat'],'conmat_LIF','spikes_post_LIF_LIF','spikes_post_LIF_IF','spikes_post_LIF','Vm_post','Vm_mid','conmat','stimSpikes','-v7.3');
catch
end
burstPlot(iter);
end
% [w,performance] = fit_weights(Nc,spikes_post_LIF,spikes_post_LIF_LIF,Vm_post_LIF);
% 
% save('data_bin1.mat','-append','w','performance');