clear all
close all

%% User Input %%
numSubsets      = 1; % Number of datasets to train on
numIter         = 3; % Number of perceptron iterations
learningRate    = [1e-2 5e-3 1e-3 5e-4 1e-4 5e-5 1e-5]; % List of learning rates to use
binSize         = [1]; % List of bin sizes to use

corrVecFile     = 'corrvec_nolag.mat';

parentSavePath  = '.\TestSaves\'; % Desired path to save outputs
savePathList    = {'TestTest\'};

%% Run algorithm %%

addpath('..\model_functions\')
addpath('..\CorrVecs\')
addpath  = ('.\MEA\'); % Path to data
dataFile = 'FisherCells-210215-181709.mat'; % Specific datafile
load(dataFile,'channel_values','length_rec','num_chans');
load(corrVecFile);
lag = 1;
if contains(corrVecFile, 'nolag')
    corrvec = corrvec_nolag;
    lag = 0;
end

for subsetIter = 1:numSubsets
    
    currSubsetStr = savePathList{subsetIter};
    savePath = [parentSavePath, currSubsetStr];
    
    for neuronIter = 1:num_chans
        
        if ~exist([savePath,'figs\'],'dir')
            mkdir([savePath,'figs\'])
            mkdir([savePath,'data\'])
        end
        
        optimalLR = zeros(length(binSize),3);
        
        for bsIter = 1:length(binSize)
            currBS = binSize(bsIter);
            fullPerf = [];
            fullWeights = [];
            lastPerf = zeros(1,length(learningRate));
            parfor lrIter = 1:length(learningRate)
                currLR = learningRate(lrIter);
                [WW, PP] = fit_weights_perceptron_InVitro(num_chans - 1, length_rec, numIter, currBS, currLR, channel_values, neuronIter, corrvec, lag);
                weights = WW;
                performance = PP;
                
                % For a given number of iterations, grab the bin size, max
                % performance, and associated learning rate
                lastPerf(lrIter) = PP(end);
                
                fullPerf = [fullPerf, {num2str(learningRate(lrIter)); performance}];
                fullWeights = [fullWeights,{num2str(learningRate(lrIter)); weights}];
                
            end
            save([savePath,'\data\Neuron',num2str(neuronIter),'_Iterations_',num2str(numIter),'_BinSize_',num2str(binSize(bsIter)),'_Performances.mat'],'fullPerf');
            save([savePath,'\data\Neuron',num2str(neuronIter),'_Iterations_',num2str(numIter),'_BinSize_',num2str(binSize(bsIter)),'_Weights.mat'],'fullWeights');
            optimalLR(bsIter,1) = binSize(bsIter);
            maxPerfIdx = find(max(lastPerf));
            optimalLR(bsIter,2) = learningRate(maxPerfIdx);
            optimalLR(bsIter,3) = max(lastPerf);
        end
        maximumPerfTable = array2table(optimalLR,'VariableNames',{'BinSize', 'LearningRate', 'Performance'});
        writetable(maximumPerfTable,[savePath,'data\',num2str(numIter),'Iterations_MaximumPerformance.dat'])
    end
end