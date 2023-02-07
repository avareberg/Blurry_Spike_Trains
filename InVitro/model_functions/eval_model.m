function perf = eval_model(spike_pre,spike_post,w,Vm_post)
load('VM setup.mat');
V_th = V_e +.02;
spike_post_m = false(size(spike_post));
spike_pre_perm = permute(spike_pre,[3,1,2]);
for k=1:size(spike_post,1)
    for j=1:size(spike_post,2)
        x = spike_pre_perm(:,k,j);
        I = (x'*w)*10^(-9);
        v = Vm_post(k,j) + dt * ( -(Vm_post(k,j) - V_e) + I * Rm) / tau_m;
        spike_post_m(k,j) = (v>V_th);
    end
end

if (length(find(spike_post_m==1))==0) || (length(find(spike_post==1))==0)
    if (length(find(spike_post_m==1))==0) && (length(find(spike_post==1))==0)
        perf = 1;
    else
        perf = 0;
    end
else
    perf = length(find(and(spike_post_m,spike_post)==1))/length(find(spike_post==1))+...
        length(find(and(spike_post_m,spike_post)==1))/length(find(spike_post_m==1));
    perf = perf/2;
end
end