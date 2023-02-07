function [stimed_spikes_pre,time] = stimulate(spikes_pre,stim_fr,stim_pulse)
f = size(spikes_pre,2); %frame rate
tlength = size(spikes_pre,1); % recording time, seconds
Nc = size(spikes_pre,3); % number of pre-synaptic neurons
num_pulse = 5; % number of pulses in a second
stimed_spikes_pre = spikes_pre;
% Generate a tlength-by-num_pulse, each row vector has uniformly distributed numbers 
% in the time interval (stim_pulse,f-stim_pulse);
% e.g. if stim_pulse = 6 ms; f = 5000; stim_t is in (6, 4994)

stim_pulse = round(stim_pulse*f);
for nn = 1:Nc
    stim_t = randi([1 f-stim_pulse],tlength,num_pulse);  
    for t = 1:tlength
        time(t,nn) = min(stim_t(t,:));
        for j = 1:num_pulse
            stimed_spikes_pre(t,round(stim_t(t,j):(stim_t(t,j)+stim_pulse-1)),nn)=(rand(1,stim_pulse,1)< stim_fr/f);
        end
    end
end
end