function  randomSpikeMatrix = ratesToRandomSpikes(bin_spikes, bin_size, Nc)
    randomSpikeMatrix = zeros(bin_size,Nc); % addition to x_guessed
    % Loop over each cell in specified bin
    idx = find(bin_spikes > 0);
    for cellIter = 1:length(idx)
        cell_number = idx(cellIter);
        % For each spike observed, randomize into new binary matrix
        for spikes = 1:bin_spikes(cell_number)
            position = [randi([1,bin_size]), cell_number];
            while(randomSpikeMatrix(position(1), position(2)) == 1) % check to see if the position already has a spike
                position = [randi([1,bin_size]), cell_number];
            end
            randomSpikeMatrix(position(1), position(2)) = 1; % fully random spiking scheme
        end
    end
end
