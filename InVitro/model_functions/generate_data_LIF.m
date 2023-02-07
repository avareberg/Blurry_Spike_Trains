function [spike_post] = generate_data_LIF(conmat,tlength,spike_pre)
        sthresh = 20;
        spike_post = false(size(spike_pre,1),size(spike_pre,2)/5);
        numPre = size(spike_pre,3);
        for ti = 1:tlength
            x = squeeze(sum(reshape(squeeze(spike_pre(ti,:,:)),5,1000,numPre),1));
            spike_post(ti,:) = logical((x*conmat)>sthresh);
        end
end

