clear all
close all
x = [1 5 20 100 200];
y = [20 50 80 85 90 95 100];
[X,Y] = meshgrid(x,y);
z = zeros(length(x),length(y));
directory = 'Z:\Shared\LIF model (for Adam)v2\FinishedData\040122_LIF_constrained\data';
files = dir(directory);
for ii = 1:length(files)
    currName = files(ii).name
    if ~contains(currName,'RMSE')
        continue;
    else
       currFrac = extractBetween(currName,'Fraction_','_RMSE');
       currSize = extractBetween(currName,'BinSize_','_Fraction');
       currData = load([directory,'\',currName]);
       [currRMSE,minIdx] = min(currData.RMSE);
       currMinLR = str2double(currData.LRs{minIdx}); 
       fracIdx = find(y == str2double(currFrac{:}));
       sizeIdx = find(x == str2double(currSize{:}));
       z(sizeIdx, fracIdx) = currMinLR;
    end
end
Z = z'  
% Z = [1.00E-02	1.00E-02	5.00E-03	5.00E-04	5.00E-04; 
%     1.00E-02	5.00E-03	5.00E-04	1.00E-04	5.00E-05; 
%     5.00E-03	1.00E-03	5.00E-04	5.00E-05	5.00E-05; 
%     1.00E-03	5.00E-04	1.00E-04	5.00E-05	5.00E-05; 
%     1.00E-03	5.00E-04	1.00E-04	5.00E-05	1.00E-05]
v = [.5 0.75 .85];    % Values of Z to plot isolines

fig = figure('Position',[100 100 1200 600])

hold on
pcolor(X, Y, Z); 
shading interp
 set(gca,'ColorScale','log')
% colormap(fig, flipud(colormap(fig)))
cb = colorbar();
cb.Ruler.Exponent = -2;
for k = 1:length(v)
    Ck = contourc(x,y,Z,[v(k) v(k)]);
    plot(Ck(1,2:end),Ck(2,2:end),'k-','LineWidth',2)
end

% set(gca, 'YScale', 'log','XScale','log')
set(gca,'XScale','log')
xlim([x(1) x(end)])
ylim([y(1) y(end)])