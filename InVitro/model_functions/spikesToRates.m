function rateMatrix = spikesToRates(spikeMatrix, iter_num, bin_size)
    rateMatrix = sum(spikeMatrix((bin_size*iter_num-(bin_size-1)):(bin_size*iter_num),:),1);
end