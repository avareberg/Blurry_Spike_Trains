function perf = eval_model_firingrates(spike_pre, spike_post, wm, bin_size, num_of_bins, sthresh)
	spike_post_m = false(size(spike_post));
    predicted = false(size(spike_post));
    actual = false(size(spike_post));
%     spike_pre = permute(spike_pre,[1 3 2]);
    for t = 1:size(spike_post,2)
		x = spike_pre(:,:,t);
		spike_post_m(:,t) = (x*wm)>sthresh;
    end
    
    for b = 1:num_of_bins % loop over bins
        predicted(b,:) = spikesToRates(spike_post_m, b, bin_size);
        actual(b,:) = spikesToRates(spike_post, b, bin_size);
    end
    
    perf = 1 - sum(sum(abs(predicted-actual)/bin_size))/(size(predicted,1)*size(predicted,2));
    
end






