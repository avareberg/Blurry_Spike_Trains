clearvars -except jj
close all
set(0, 'DefaultFigureRenderer', 'painters');
RMSEFull = [];
LRlist = [];
valList = [20 50 100];
% Loads all of the RMSE data

for valIter = 1:length(valList)
    currVal = num2str(valList(valIter));
    for dataIter = 2
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
    end
    
    %         RMSEFull = RMSEFull(:,[2,5,4,1,3],:);
    legList = {};
    stdList = squeeze(std(RMSEFull));
    standardError = stdList/sqrt(size(RMSEFull,1));
    meanList = squeeze(mean(RMSEFull,1));
    cmapsize = size(meanList, 1);
    cmap = hsv(cmapsize);
    rmseFig = figure();
    hold all
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
            plot(osList(:,mm),squeeze(RMSEFull(nn,mm,:)),'o','Color',0.65*(1-currcolor)+currcolor,'MarkerFaceColor',0.65*(1-currcolor)+currcolor)
            hold all
        end
        plot(osList(:,mm),meanList(mm,:),'o','Color',currcolor,'MarkerFaceColor',currcolor)
        N = 4;
        tot = 0;
        box on
        grid on
%         set(gca,'xscale','log','yscale','log','FontWeight','bold','FontSize',12)
        set(gca,'xscale','log','FontWeight','bold','FontSize',12)
        
    end
     ylim([1 7])
    if dataIter == 1
        saveas(rmseFig,[savePath,currVal,'_RMSE_IF_072622.fig'])
        saveas(rmseFig,[savePath,currVal,'_RMSE_IF_072622.png'])
        saveas(rmseFig,[savePath,currVal,'_RMSE_IF_072622.svg'])
    else
        saveas(rmseFig,[savePath,currVal,'_RMSE_LIF_072622.fig'])
        saveas(rmseFig,[savePath,currVal,'_RMSE_LIF_072622.png'])
        saveas(rmseFig,[savePath,currVal,'_RMSE_LIF_072622.svg'])
    end
end
% for mm = 1:5
% plot(minLR(mm), minPoint(mm), 'd','Color','k','MarkerFaceColor',color(mm,:))
% end
% saveas(rmseFig,[savePath,'RMSEPoints_20Hz.png'])
% saveas(rmseFig,[savePath,'RMSEPoints_20Hz.svg'])


% for iter = 1:length(rmseFileList)
%     legList = [legList, strrep(extractBetween(rmseFileList{iter},'Iterations_100_','_RMSE.mat'),'_',' ')];
% end

% X = categorical(LRlist(1:7));
% X = renamecats(X,{'1e-05','5e-05','1e-04','5e-04','1e-03' '5e-03','1e-02'});
% barFig = figure();
% b = bar(X,meanList','grouped');
% hold all
% offset = get(b,'XOffset');
% for cc = 1:cmapsize
%     b(cc).FaceColor = cmap(cc,:);
% end
% box on
% set(gca,'yscale','log','FontWeight','bold','FontSize',12)
% h = get(gca,'Children');
% set(gca,'Children',[h(3) h(5) h(2) h(1) h(4)])
% saveas(barFig,[savePath,'RMSEBars.png'])

%         for eb = 1:7
%             x(eb,:) = [offset{:}]+ double(string(b(1).XData(eb)));
%             errorbar(x(eb,:),meanList(:,eb),meanList(:,eb)-standardError(:,eb),meanList(:,eb)+standardError(:,eb),'.','Color','k')
%         end

% Plot the errorbars

%         plot(x,meanList',standardError','.','Color','k');
%         plot(x(1,:),percent_nostim,'o','Color',[0.5 0.5 0.5],'MarkerSize',3);
%         plot(x(2,:),percent_stim,'o','Color',[0.5 0.5 0.5],'MarkerSize',3);

%
%     )    legend(legList,'Location','Northwest')
%         h = get(gca,'Children');
%         set(gca,'Children',[h(3) h(5) h(2) h(1) h(4)]
%         saveas(rmseFig,[savePath,'RMSE.png'])

