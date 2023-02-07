function [Vm,spike_post] = generate_spike_post(conmat,spikes_pre,f)
tlength = size(spikes_pre,1);
f = size(spikes_pre,2);
spike_post = false(tlength,f);
load('VM setup.mat');
Vm = zeros(tlength+1,f+1);
% V_th = -0.055;
% V_th = 	V_e + .02;
Vm(1,1)=V_reset;
spikes_pre_perm = permute(spikes_pre, [3,1,2]);
for s = 1:tlength
    for t = 1:f
        x = spikes_pre_perm(:,s,t);
        I = (x'*conmat)*10^(-9); % nA          
        if Vm(s,t) > V_th        % reset Vm to V_rest if fire action potential
            Vm(s,t) = V_th + 0.08;
            Vm(s,t+1) = V_reset;
            spike_post(s,t) = 1;
        else
            Vm(s,t+1) = Vm(s,t) + dt * ( -(Vm(s,t) - V_e) + I * Rm) / tau_m;
        end
        if t == f
            Vm(s+1,1) = Vm(s,t+1);
        end
    end
end
spike_post = logical(spike_post);
end