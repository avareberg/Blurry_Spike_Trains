function [w,performance] = fit_weights(Nc,spikes_pre,spikes_post,Vm_train_post)
w = zeros(Nc,1); %initiate weight matrix
Niter = 100 % num_of_iterations
lr = 1e-2; % learning rate
wrange = 8; % range of weights
load('VM setup.mat');
inds_pre = 1:Nc;
Npre = Nc;
tlength = size(spikes_post,1);
i_mid = round(tlength/5*4); % divide the dataset to 4:1 (80% for training, 20% for validating)
train_pre = spikes_pre(1:i_mid,:,inds_pre);
train_post = spikes_post(1:i_mid,:);
test_pre = spikes_pre((i_mid+1):end,:,inds_pre);
test_post = spikes_post((i_mid+1):end,:);
Vm_train_pre = Vm_train_post(1:i_mid,:);
Vm_test_post = Vm_train_post((i_mid+1):end,:);
wm = wrange*(-1 + 2*rand(Npre,1));
performance = zeros(Niter,1);
for i=1:Niter
    for k=1:size(train_post,1)
        for j=1:size(train_post,2)
            x = squeeze(train_pre(k,j,:));
            I = (x'*wm)*10^(-9);
            v = Vm_train_pre(k,j) + dt * ( -(Vm_train_pre(k,j) - V_e) + I * Rm) / tau_m;
            ym = (v>V_th);
            err = train_post(k,j) - ym;
            inds = find(x == 1);
            wm(inds) = wm(inds) + lr*err;
        end
    end
    performance(i) = round(eval_model(test_pre,test_post,wm,Vm_test_post),3);
    %     if i ==1 || i == 100 || i == 500
    disp(['iteration ',int2str(i),': ',num2str(performance(i))])
    %     end
    w(inds_pre) = wm;
    matrix_w(:,i) = w;
end
end

    

    