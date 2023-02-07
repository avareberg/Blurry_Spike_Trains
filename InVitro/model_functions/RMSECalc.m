% function RMSECalc()

    for jj = 2
        jj
        load('data_040122.mat','conmat_LIF');
        if jj == 1
            dataPath = 'Z:\Shared\LIF model (for Adam)v2\FinishedData\040122_IF\data\';
        else
            dataPath = 'Z:\Shared\LIF model (for Adam)v2\FinishedData\040122_LIF_constrained\data\';
        end
        
        actualWeights = conmat_LIF;
        
        directory = dir(dataPath);
        matFileList = {};
        for iter = 1:size(directory, 1)
            if contains(directory(iter).name, 'Fraction_50_Weights.mat') %|| contains(directory(iter).name, 'Fraction_20_Weights.mat')
%             if ~contains(directory(iter).name, 'Fraction') && contains(directory(iter).name, 'Weights.mat')
                matFileList = [matFileList; directory(iter).name];
            end
        end
        
        for matFileIter = 1:length(matFileList)
            matFile = matFileList{matFileIter};
            rmseFile = strrep(matFile,'Weights','RMSE_V2');
            load([dataPath, matFile]);
            lenFW = length(fullWeights);
            RMSE = zeros(lenFW,1);
            Coeffs = zeros(lenFW,1);
            Pvals = zeros(lenFW,1);
            for ii = 1:lenFW
                
                currLR      = fullWeights{1,ii};
                currWeights = fullWeights{2,ii};
                
                %          fileName = strrep(strrep(matFile,'.mat','.gif'),'Weights',['LR_',strrep(num2str(currLR),'.','_')]);
                guessedWeights = currWeights(end,:);
                currIdx = 1:size(guessedWeights,2);
                RMSE(ii,1) = sqrt(mean((actualWeights(currIdx)' - guessedWeights).^2));
                [R, P] = corrcoef(actualWeights(currIdx)', guessedWeights');
                Coeffs(ii,1) = R(2,1);
                Pvals(ii,1) = P(2,1);
            end
            LRs = fullWeights(1,:)';
            savePath = [dataPath,'RMSE\',rmseFile];
            if ~exist([dataPath,'RMSE\'],'dir')
                mkdir([dataPath,'RMSE\'])
            end
%             save(savePath,'LRs','RMSE');
        end
    end
% end
