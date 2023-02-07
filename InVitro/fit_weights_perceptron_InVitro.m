function [weights, performance] = fit_weights_perceptron_InVitro(Nc, tlength, num_of_iterations, binSize, learningRate, data, neuron, corrvec, lag)

    if lag
        for ii = 1:Nc+1
            currRow = data(ii,:);
            newSpikeRow = circshift(currRow,[0 lagvec(neuron,ii)]);
            data(ii,:) = newSpikeRow;
        end
    end
    
    spikes = reshape(data,size(data,1),size(data,2)/tlength,tlength);
    spikes = permute(spikes,[2 1 3]);
    inds_pre = [1:neuron-1 neuron+1:Nc+1];
    spike_pre = spikes(:, inds_pre,:);
    spike_post = spikes(:,neuron,:);

    % Variables specified in driver, retrofit to this function
    w = zeros(Nc+1,1);
	Niter = num_of_iterations;
	lr = learningRate; % learning rate of weight matrix according to the algorithm
    bin_size = binSize; % bin size for spike counting (in ms)
    num_of_bins = 1000/bin_size; %
    wrange = 8;
%     setup = load('VM setup.mat');
%     inds_pre = 1:Nc;
    Npre = Nc;
    i_mid = round(tlength); % divide the dataset to 4:1 (80% for training, 20% for validating)
    train_pre = spike_pre(:,1:Nc,1:i_mid);
	train_post = spike_post(:,1:i_mid);
% 	test_pre = spike_pre(:,inds_pre,(i_mid+1):end);
% 	test_post = spike_post(:,(i_mid+1):end);
%     Vm_train_pre = Vm_train_post(:,1:i_mid);
%     Vm_test_post = Vm_train_post(:,(i_mid+1):end);
    nWidx = find(corrvec(neuron,:)<0);
    nmin = min(corrvec(neuron,nWidx));
    normNVals = corrvec(neuron,nWidx)/nmin;
    pWidx = find(corrvec(neuron,:)>0);
    pmax = max(corrvec(neuron,pWidx));
    normPVals = corrvec(neuron,pWidx)/pmax;
    wm = zeros(Nc+1,1);
    wm(nWidx)= (-wrange*rand(length(nWidx),1)).*normNVals';
    wm(pWidx)= (wrange*rand(length(pWidx),1)).*normPVals';
    wm(neuron) = [];
%     wm = wrange*(-1 + 2*rand(Npre,1));
    performance = zeros(Niter,1);
    weights = zeros(Niter+1,Nc);
    weights(Niter+1,:) = wm;
    sthresh = 20; 
    % Main Loop for Iterations
    for i=1:Niter
        % Loop over each 1000 ms interval
        bin_spikes_pre = zeros(num_of_bins,Nc,size(train_post,2));
		for k=1:size(train_post,2) % every second, 2=columns
           
            x = squeeze(train_pre(:,:,k)); % neuron 1 to 200 for one second (1000 ms)
%             x_test = squeeze(test_pre(:,:,k));
            x_guessed = zeros(1000,Nc); % x_guessed is a random firing pattern
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
                    
                    if total_bin_error ~=0
                        for ii = 1:bin_size
                            inds = find(x_guessed(second_counter,:) == 1);
                            wm(inds) = wm(inds) + lr*total_bin_error; % updating/adjusting our guess
%                             wm(wm>8) = 8; %% UNCOMMENT IF BOUNDED
%                             wm(wm<-8) = -8; %% UNCOMMENT IF BOUNDED
                            second_counter = second_counter +1;
                        end
                    else
                        second_counter = second_counter + bin_size;
                    end
                end
        end
        
%         performance(i) = eval_model_firingrates(test_pre, test_post, wm, bin_size, num_of_bins, sthresh);
        performance (i) = 1;
        %performance(i) = round(eval_model(test_pre,test_post,wm),3);
% 		disp(['iteration ',int2str(i),': ',num2str(performance(i))])
		w(inds_pre) = wm;
        w(neuron) = 0;
        weights(i,:) = wm;
		%save(['models/wm_perc_',int2str(Nc),'c_',int2str(tlength),'lr_',lr,'s.mat'],'w','performance')
    end
end








