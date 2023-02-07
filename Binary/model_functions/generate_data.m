function [spike_pre, spike_post] = generate_data(Nc,tlength, hz, numSets)
	sthresh = 20;
	Nc_conE = 80;
	Nc_conI = 20;
    pspike = hz/1000;
	wmax = 8;
    for jj = 1:numSets
        conmat = generate_conmat(Nc,Nc_conE,Nc_conI,wmax);
        spike_pre = false(1000,Nc,tlength);
        spike_post = false(1000,tlength);
        for ti = 1:tlength
            ti
            x = (rand(1000,Nc)<pspike);
            spike_pre(:,:,ti) = x;
            spike_post(:,ti) = (x*conmat)>sthresh;
        end
        save(['../DataSets/',num2str(hz),'Hz_Set',num2str(jj),'_',int2str(Nc),'c_',int2str(tlength),'s.mat'],'conmat','spike_pre','spike_post')
     end
end