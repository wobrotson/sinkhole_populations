%-----------------------------------------------+
% script to plot time series of number of sink- |
% holes mapped in the Dead Sea as a whole and in|
% selected local areas, and display the changes |
% in sinkhole population with time.             |
%                                               |
% Rob Watson; 1/2/20                            |
%-----------------------------------------------+

clear all;
close all;

%% load and sort data

% GAH, annual record of no. holes 
GAH = load('SH_total.txt');
GAH_cu = cumsum(GAH(:,2)); % cumulative no holes

% ze'elim
zeelim = readmatrix('DeadSeaWestHolesZeelim.csv');
zeelim = round(zeelim); % round to nearest integer
zeelim_cu = zeelim(:,2); % cumulative no holes

% get no. holes for each timestamp at zeelim
zeelim_ann = zeros(length(zeelim),1);
for a = 1:1:(length(zeelim)-1)
    zeelim_ann(a+1) = zeelim(a+1,2)-zeelim(a,2);
end

% Dead Sea west, total
DSWest = readmatrix('DeadSeaWestHolesTotal.csv');
DSWest = round(DSWest); % round to nearest integer

% get no. holes for each timestamp on west
DSWest_ann = zeros(length(DSWest),1);
for a = 1:1:(length(DSWest)-1)
    DSWest_ann(a+1) = DSWest(a+1,2)-DSWest(a,2);
end

% dead sea level data
DeadSea = load('Dead_Sea_Level_timeseries.txt');

%% create total Dead Sea sinkhole population time series
years = DSWest(1,1):1:GAH(end,1);

% create 3D matrix storing no. holes in all areas
leng = [length(GAH),length(zeelim),length(DSWest)];
DSHoles = NaN(max(leng), 2, 3);
DSHoles(1:leng(1),:,1) = GAH; % GAH annual holes, 1st frame
DSHoles(1:leng(2),1,2) = zeelim(:,1); % zeelim years
DSHoles(1:leng(2),2,2) = zeelim_ann; % zeelim annual holes
DSHoles(1:leng(3),1,3) = DSWest(:,1); % Western total years
DSHoles(1:leng(3),2,3) = DSWest_ann; % Western annual total holes

% cumulatively add no. sinkholes from all areas at annual rate
DSTotal = zeros(length(years), 2);
DSTotal(:,1) = years; % matrix where total no. holes will be stored

for x = years(1):years(end)
    for y = years(1):years(end)
        if DSHoles(1,:,:) == x
           DSTotal(y,2) = sum(DSHoles(y,2,:));
        end
    end
end
  %  DSTotal(:,2) = sum
%% plot data
plter = 0;

set(0, 'DefaultAxesFontName', 'Calibri');
set(0, 'DefaultAxesFontSize', 16);
set(0, 'DefaultAxesFontWeight', 'bold');

if plter == 1
pop_plot = figure(1);

left_color = [0 0 0];
right_color = [0 0 0];
set(pop_plot,'defaultAxesColorOrder',[left_color; right_color]);

GAH_color = [0,0.447,0.741];
zeelim_color = [0.85,0.325,0.098];
west_color = [0.929,0.694,0.125];
DS_color = [0.466,0.674,0.188];

yyaxis right;
bar(GAH(:,1),GAH_cu, 'FaceColor', GAH_color);
hold on;
bar(zeelim(:,1),zeelim(:,2), 'FaceColor', zeelim_color);
plot(DSWest(:,1), DSWest(:,2),'LineWidth', 2, 'Color', west_color);
axis([1980 2018 0 6000]);
xlabel('year');
ylabel('no. sinkholes');

yyaxis left;    
plot(DeadSea(:,1), DeadSea(:,2), 'LineWidth', 1.5, 'Color', DS_color);
xlim([1980 2018]);
ylim([-435 -395]);
yticks([-435 -425 -415 -405 -395]);
ylabel('Dead Sea Level (m)');

lgd = legend('Dead Sea level','Ghor Al-Haditha', 'Zeelim', ...
     'West, Total', 'Location', 'northeast');
lgd.FontSize = 12;
end