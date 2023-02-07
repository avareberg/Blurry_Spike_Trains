function x_guessed = redistributeSpikes(bin_size, bin_width)

    x_guessed = zeros(1000,200); % x_guessed is a random firing pattern
    x_guessed_count = 0;
    for b = 1:bin_width % loop over bins
        x_addition = zeros(bin_size,Nc); % addition to x_guessed
        bin_spikes = sum(x((bin_size*b-(bin_size-1)):(bin_size*b),:),1);
        for cell_number = 1:size(bin_spikes,2)
            for spikes = 1:bin_spikes(cell_number)
                position = [randi([1,bin_size]), cell_number];
                while(x_addition(position(1), position(2)) == 1) % check to see if the position already has a spike
                    position = [randi([1,bin_size]), cell_number];
                end
                x_addition(position(1), position(2)) = 1; % fully random spiking scheme
            end
        end
        for mm = 1:size(x_addition,1)
            x_guessed_count = x_guessed_count + 1;
            x_guessed(x_guessed_count,:) = x_addition(mm,:); % 1000 ms by 200 neuron guessed spike matrix
        end
    end
end