clearvars -except jj
close all
set(0, 'DefaultFigureRenderer', 'painters');
RMSEFull = [];
LRlist = [];
valList = [20 50 100];
markerList = {'o','x','s'};

% Loads all of the RMSE data
for dataIter = 1:2
    
    for valIter = 1:length(valList)
        rmseFig = figure();
        hold all
        currVal = num2str(valList(valIter));
        currMark = 'o';
        
        if dataIter == 1
            dataPath = 'Z:\Shared\LIF model (for Adam)v2\FinishedData\040122_IF_constrained\data\';
            savePath = 'Z:\Shared\LIF model (for Adam)v2\FinishedData\040122_IF_constrained\figs\';
        else
            dataPath = 'Z:\Shared\LIF model (for Adam)v2\FinishedData\040122_LIF_constrained\data\';
            savePath = 'Z:\Shared\LIF model (for Adam)v2\FinishedData\040122_LIF_constrained\figs\';
        end
        
        directory = dir(dataPath);
        matFileList = {};
        rmseFileList = {};
        
        for iter = 1:size(directory, 1)
            if (valList(valIter) == 100 && contains(directory(iter).name, '_Weights.mat') && ~contains(directory(iter).name, 'Fraction')) || (contains(directory(iter).name, ['Fraction_',currVal,'_Weights.mat']) && contains(directory(iter).name, currVal))
                matFileList = [matFileList; directory(iter).name];
                rmseFileList = [rmseFileList; strrep(directory(iter).name,'Weights','RMSE')];
            end
        end
        
        for matFileIter = 1:length(matFileList)
            
            rmseFile = rmseFileList{matFileIter};
            load([dataPath, rmseFile]);
            RMSEFull(1,matFileIter,:) = RMSE;
            
            for jj = 1:length(LRs)
                LRlist = [LRlist, str2num(LRs{jj})];
            end
            
        end
        
        %         RMSEFull = RMSEFull(:,[2,5,4,1,3],:);
        legList = {};
        stdList = squeeze(std(RMSEFull));
        standardError = stdList/sqrt(size(RMSEFull,1));
        meanList = squeeze(mean(RMSEFull,1));
        cmapsize = size(meanList, 1);
        cmap = hsv(cmapsize);
        
        for osIter = 1:7
            currlog = log10(LRlist(osIter));
            osList(osIter,:) = logspace(currlog/1.015, currlog*1.015,5);
        end
        
        
        
        for mm = 1:5
            color(mm,:) = cmap(mm,:);
            currcolor = color(mm,:);
            hold all
            
            set(gca,'xscale','log','FontWeight','bold','FontSize',12)
            oneBinPath = strrep(extractBetween(rmseFileList{mm},'Iterations_100_','_RMSE.mat'),'_','');
            
            for nn = 1:size(RMSEFull,1)
                plot(osList(:,mm),squeeze(RMSEFull(nn,mm,:)),currMark,'Color',0.65*(1-currcolor)+currcolor,'MarkerFaceColor',0.65*(1-currcolor)+currcolor)
                hold all
            end
            plot(osList(:,mm),meanList(mm,:),currMark,'Color',currcolor,'MarkerFaceColor',currcolor,'MarkerSize',8)
            N = 4;
            tot = 0;
            box on
            grid on
            set(gca,'xscale','log','FontWeight','bold','FontSize',12)
            set(gca,'YTickLabel',[]);
            set(gca,'XTickLabel',[]);
        end
        
        if dataIter == 1
            ylim([1 7])
            saveas(rmseFig,[savePath,currVal,'_RMSE_IF_072622.fig'])
            saveas(rmseFig,[savePath,currVal,'_RMSE_IF_061322.png'])
            saveas(rmseFig,[savePath,currVal,'_RMSE_IF_061322.svg'])
        else
            ylim([1 7])
            saveas(rmseFig,[savePath,currVal,'_RMSE_LIF_072622.fig'])
            saveas(rmseFig,[savePath,currVal,'_RMSE_LIF_072622.png'])
            saveas(rmseFig,[savePath,currVal,'_RMSE_LIF_072622.svg'])
        end
    end
end
