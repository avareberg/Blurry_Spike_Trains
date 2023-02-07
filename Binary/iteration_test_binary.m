clear all
close all

parentSavePath = '.\TestSaves\';
numIter = 100;
Nc = 200;
tlength = 5000;
learningRate = [1e-5, 5e-5, 1e-4, 5e-4, 1e-3, 5e-3, 1e-2];
binSize = [1];
setList = 1:2;
hz = '20Hz';

for setNum = setList
    
    savePath = [parentSavePath,hz,'\',num2str(setNum),'\'];
    dataPath = ['.\DataSets\',hz,'_Set',num2str(setNum),'_',num2str(Nc),'c_',num2str(tlength),'s.mat'];
    if ~exist([savePath,'figs\'])
        mkdir([savePath,'figs\'])
        mkdir([savePath,'data\'])
    end
    
    optimalLR = zeros(length(binSize),3);
    
    for bsIter = 1:length(binSize)
        currBS = binSize(bsIter);
        fullPerf = [];
        fullWeights = [];
        fig = figure('Visible','off');
        box on; grid on;
        hold all
        title(['Bin Size = ',num2str(binSize(bsIter)),'ms'])
        xlabel('Iteration Number')
        ylabel('Performance')
        lastPerf = zeros(1,length(learningRate));
        maxPerf = 0;
        for lrIter = 1:length(learningRate)
            currLR = learningRate(lrIter);
            [WW, PP] = fit_weights_perceptron_binary(Nc, tlength, numIter, currBS, currLR, dataPath);
            weights = WW;
            performance = PP;
            
            % For a given number of iterations, grab the bin size, max
            % performance, and associated learning rate
            lastPerf(lrIter) = PP(end);

            fullPerf = [fullPerf, {num2str(learningRate(lrIter)); performance}];
            fullWeights = [fullWeights,{num2str(learningRate(lrIter)); weights}];
            scatter([1:numIter],performance,'o')
            Legend{lrIter} = ['LR = ',num2str(learningRate(lrIter))];
            saveas(fig,[savePath,'figs\','BinSize_',num2str(currBS),'.fig']);
            saveas(fig,[savePath,'figs\','BinSize_',num2str(currBS),'.png']);
        end
        save([savePath,'data\','Iterations_',num2str(numIter),'_BinSize_',num2str(binSize(bsIter)),'_Performances.mat'],'fullPerf');
        save([savePath,'data\','Iterations_',num2str(numIter),'_BinSize_',num2str(binSize(bsIter)),'_Weights.mat'],'fullWeights');
        optimalLR(bsIter,1) = binSize(bsIter);
        maxPerfIdx = find(max(lastPerf));
        optimalLR(bsIter,2) = learningRate(maxPerfIdx);
        optimalLR(bsIter,3) = max(lastPerf);
        legend(Legend,'Location','northeastoutside');
        saveas(fig,[savePath,'figs\','Iterations_',num2str(numIter),'_BinSize_',num2str(binSize(bsIter))],'fig');
    end
    maximumPerfTable = array2table(optimalLR,'VariableNames',{'BinSize', 'LearningRate', 'Performance'});
    writetable(maximumPerfTable,[savePath,'data\',num2str(numIter),'Iterations_MaximumPerformance.dat'])
end