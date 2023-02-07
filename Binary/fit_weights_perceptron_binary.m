function [weights,performance] = fit_weights_perceptron_binary(Nc, tlength, num_of_iterations, binSize, learningRate, path)

    load(path);
    load(insertAfter(path,'DataSets\','lagcorr'));
    % Include the path to all of the required files/functions
    addpath('.\model_functions\')
    
    % Variables specified in driver, retrofit to this function
    w = zeros(Nc,1);
	Niter = num_of_iterations;
	lr = learningRate; % learning rate of weight matrix according to the algorithm
    bin_size = binSize; % bin size for spike counting (in ms)
    num_of_bins = 1000/bin_size; %s
    
    % Variables local to function
    sthresh = 20;
	wrange = 8;
 	load(path);
	cutoff = 0;
	inds_pre_i = find(corrvec < -cutoff);
	inds_pre_e = find(corrvec > cutoff);
	inds_pre = union(inds_pre_i,inds_pre_e); % both excitatory and inhibitory
	Npre = length(inds_pre);
	i_mid = round(tlength/2);
	train_pre = spike_pre(:,inds_pre,1:i_mid);
	train_post = spike_post(:,1:i_mid);
	test_pre = spike_pre(:,inds_pre,(i_mid+1):end);
	test_post = spike_post(:,(i_mid+1):end);
	wm = wrange*(-1 + 2*rand(Npre,1)); % random weight matrix range
	performance = zeros(Niter,1);
    weights = zeros(Niter,200);
    % Main Loop for Iterations
    for i=1:Niter
        
        % Loop over each 1000 ms interval
		for k=1:size(train_post,2) % every second, 2=columns
           
            x = squeeze(train_pre(:,:,k)); % neuron 1 to 200 for one second (1000 ms)
            x_test = squeeze(test_pre(:,:,k));
            x_guessed = zeros(1000,200); % x_guessed is a random firing pattern
            x_guessed_count = 0;
                
                % Loop over each bin
                for b = 1:num_of_bins 
                    bin_spikes = spikesToRates(x, b, bin_size); % Spikes observed by each cell in time bin
                    bin_spikes_pre(b,:,k) = bin_spikes;
                    
                    x_addition = ratesToRandomSpikes(bin_spikes, bin_size, Nc);

                    % Add new redistruted bin to a full 'guessed' matrix
                    for mm = 1:size(x_addition,1)
                        x_guessed_count = x_guessed_count + 1;
                        x_guessed(x_guessed_count,:) = x_addition(mm,:); % 1000 ms by 200 neuron guessed spike matrix
                    end
                end
                
                % Update the weight matrix
                counter = 1;
                second_counter = 1;
                for j = 1:num_of_bins % every ms, 1=rows
                    
                    total_bin_error = 0;
                    
                    for c = 1:bin_size
                        ym = (x_guessed(counter,:)*wm) > sthresh; 
                        err = train_post(counter,k) - ym;
                        total_bin_error = total_bin_error + err;
                        counter = counter + 1;
                    end
                    
                    for ii = 1:bin_size
                        inds = find(x_guessed(second_counter,:) == 1);
                        wm(inds) = wm(inds) + lr*total_bin_error; % updating/adjusting our guess
                        second_counter = second_counter +1;
                    end
                end
   
            % WANT TO CHANGE TO UPDATE ERROR BASED ON ERROR IN EACH BIN
            % seperate loop or within same loop?
% 			for j=1:size(train_post,1) % every ms, 1=rows
%                     ym = (x_guessed(j,:)*wm)>sthresh; 
%                     err = train_post(j,k) - ym;
%                     inds = find(x_guessed(j,:) == 1);
%                     wm(inds) = wm(inds) + lr*err; % updating/adjusting our guess
%             end
        end
        
        performance(i) = eval_model_firingrates(test_pre, test_post, wm, bin_size, num_of_bins);
       
        %performance(i) = round(eval_model(test_pre,test_post,wm),3);
		disp(['iteration ',int2str(i),': ',num2str(performance(i))])
		w(inds_pre) = wm;
        weights(i,:) = wm;
		%save(['models/wm_perc_',int2str(Nc),'c_',int2str(tlength),'lr_',lr,'s.mat'],'w','performance')
    end
    
end








