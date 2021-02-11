% Cluster data - discovery
clear all

load('Path_to_data\Discovery_SRET_data_with_controls.mat')
Data=SRET_data(find(group==2),:); %load just SAD data


%% Z score data
zscore_omit_nan = @(x) bsxfun(@rdivide, bsxfun(@minus, x, mean(x,'omitnan')), std(x, 'omitnan'));
Z_Data = zscore_omit_nan(Data);

%% Cluster data

k=2; %specify 2 clusters
%Cluster based on first 2 columns of the data file (SRET responses to pos
%and neg words)
[index,C,sumd,Dist] = kmeans(Z_Data(:,1:2),k); %index = cluster assignment; C = centroid; sumd = sum of point-to-centroid distances; Dist = distance from each point to centroid 

%Evaluate cluster solution using silhouette plot; 
%silhouette value = how similar that point is to all other points in the same cluster, compared to points in other clusters. 
%silhouette value ranges from -1 to +1
[silh,h] = silhouette(Z_Data,index);
AvgScore=nanmean(silh);


%% Plot data
FigData{1,1}=SRET_data(index==1,1); %SAD cluster 1
FigData{1,2}=SRET_data(index==2,1); %SAD cluster 2
FigData{1,3}=SRET_data(group==1,1); %controls
FigData{1,4}=SRET_data(index==1,2);
FigData{1,5}=SRET_data(index==2,2);
FigData{1,6}=SRET_data(group==1,2);

d=FigData;
fig_position = [200 200 600 400];

try
     % get nice colours from colorbrewer
     % (https://uk.mathworks.com/matlabcentral/fileexchange/34087-cbrewer---colorbrewer-schemes-for-matlab)
     [cb] = cbrewer('qual', 'Set3', 12, 'pchip');
catch
     % if you don't have colorbrewer, accept these far more boring colours
     cb = [0.5 0.8 0.9; 1 1 0.7; 0.7 0.8 0.9; 0.8 0.5 0.4; 0.5 0.7 0.8; 1 0.7 0.5; 0.7 1 0.4; 1 0.7 1; 0.6 0.6 0.6; 0.7 0.5 0.7; 0.9 0.9 1; 1 1 0.4];
end

% example 1
f7 = figure('Position', fig_position);
subplot(1, 2 ,1)
h1 = raincloud_plot(d{1}, 'box_on', 1, 'color', cb(4,:), 'alpha', 0.5,...
    'box_dodge', 1, 'box_dodge_amount', .15, 'dot_dodge_amount', .15,...
    'box_col_match', 0);
h2 = raincloud_plot(d{2}, 'box_on', 1, 'color', cb(1,:), 'alpha', 0.5,...
    'box_dodge', 1, 'box_dodge_amount', .35, 'dot_dodge_amount', .35, 'box_col_match', 0);
h3 = raincloud_plot(d{3}, 'box_on', 1, 'color', cb(11,:), 'alpha', 0.5,...
    'box_dodge', 1, 'box_dodge_amount', .55, 'dot_dodge_amount', .55, 'box_col_match', 0);
title('Pos trait endorsement')
box off

subplot(1, 2 ,2)
h1 = raincloud_plot(d{4}, 'box_on', 1, 'color', cb(4,:), 'alpha', 0.5,...
    'box_dodge', 1, 'box_dodge_amount', .15, 'dot_dodge_amount', .15,...
    'box_col_match', 0);
h2 = raincloud_plot(d{5}, 'box_on', 1, 'color', cb(1,:), 'alpha', 0.5,...
    'box_dodge', 1, 'box_dodge_amount', .35, 'dot_dodge_amount', .35, 'box_col_match', 0);
h2 = raincloud_plot(d{6}, 'box_on', 1, 'color', cb(11,:), 'alpha', 0.5,...
    'box_dodge', 1, 'box_dodge_amount', .55, 'dot_dodge_amount', .55, 'box_col_match', 0);
legend([h1{1} h2{1} h3{1}], {'Cluster 1 SAD', 'Cluster 2 SAD', 'Controls'})
title('Neg trait endorsement')

box off


