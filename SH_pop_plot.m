%-----------------------------------------------+
% script to plot time series of number of sink- |
% holes mapped in GAH study area, and display   |
% the change in sinkhole population with time.  |
%                                               |
% Rob Watson; 31/7/18                           |
%-----------------------------------------------+

clear all;
close all;

% load in data and sort into sensible array
fileID = fopen('sinkholes_per_yr_090218.txt', 'r');
holesRAW0902 = textscan(fileID, '%f %s %f');
fclose(fileID);

SH_all = load('SH_total.txt');

% dead sea level data
DeadSea = load('Dead_Sea_Level_timeseries.txt');

cumholesall = cumsum(SH_all(:,2));
cumholesmap = cumsum(holesRAW0902{:,3});
total_mapped = max(cumholesmap);

% plot data

set(0, 'DefaultAxesFontName', 'Calibri');
set(0, 'DefaultAxesFontSize', 16);
set(0, 'DefaultAxesFontWeight', 'bold');

pop_plot = figure(1);

left_color = [0 0 0];
right_color = [0 0 0];
set(pop_plot,'defaultAxesColorOrder',[left_color; right_color]);

cum_color = [0,0.447,0.741];
sat_color = [0.85,0.325,0.098];
local_color = [0.929,0.694,0.125];
DS_color = [0.466,0.674,0.188];

bar(SH_all(:,1),cumholesall, 'FaceColor', cum_color);
hold on;
bar(SH_all(:,1),SH_all(:,2), 'FaceColor', sat_color);
bar(holesRAW0902{:,1}, holesRAW0902{:,3}, 'FaceColor', local_color);
axis([1984 2018 0 1200]);
xlabel('year');
ylabel('no. sinkholes');
text(SH_all(:,1)-.5, cumholesall+20, num2str(cumholesall),...
    'FontSize', 14, 'FontWeight', 'bold');
yyaxis right;
plot(DeadSea(:,1), DeadSea(:,2), 'LineWidth', 1.5, 'Color', DS_color);
xlim([1984 2018]);
ylim([-435 -395]);
yticks([-435 -425 -415 -405 -395]);
ylabel('Dead Sea Level (m)');
lgd = legend('cumulative - total', 'incremental - local information', ...
    'incremental - satellite mapping', 'Dead Sea level', 'Location', 'northwest');
lgd.FontSize = 16;