%-------------------------------------------------+
% script to plot statistics of sinkholes recorded |
% in GAH by different surveys.                    |
%                                                 |
% Rob Watson; 09/02/18                            |
%-------------------------------------------------+
clear all;
close all;

set(0, 'DefaultAxesFontName', 'Calibri');
set(0, 'DefaultAxesFontSize', 14);
set(0, 'DefaultAxesFontWeight', 'bold');

fig1 = 0;
fig2 = 0;
fig3 = 0;
fig4 = 1;

%% load data

% my sinkhole plot data: col1 = year, col2 = date last image used in 
% mapping for that year was obtained, col3 = no. sinkholes
fileID = fopen('sinkholes_per_yr_090218.txt', 'r');
holesRAW0902 = textscan(fileID, '%f %s %f');
fclose(fileID);

cumholesRAW = cumsum(holesRAW0902{:,3});

% data mapped without using orthophotos
fileID = fopen('sinkholes_per_yr_no_OF.txt', 'r');
holesnoOF = textscan(fileID, '%f %s %f');
fclose(fileID);

cumholesnoOF = cumsum(holesnoOF{:,3});


% leila's sinkhole data
fileID = fopen('sinkholes_per_yr_leila.txt', 'r');
holesleila = textscan(fileID, '%f %s %f');
fclose(fileID);

cumholesleila = cumsum(holesleila{:,3});

%% plot number of sinkholes per year
if fig1 == 1
figure(1);
subplot(2,3,1);
bar(holesRAW0902{:,1}, holesRAW0902{:,3});
hold on;
text(holesRAW0902{:,1}-.8, holesRAW0902{:,3}+2,...
    num2str(holesRAW0902{:,3}),'FontSize', 14);
xlabel('year');
ylabel('no. sinkholes');
title('number of holes mapped each year');
subplot(2,3,2);
bar(holesRAW0902{:,1},cumholesRAW);
hold on;
text(holesRAW0902{:,1}-.8, cumholesRAW+20, num2str(cumholesRAW),...
    'FontSize', 14);
xlabel('year');
ylabel('no. sinkholes');
title('cumulative number of holes mapped each year');

subplot(2,3,3);
bar(holesleila{:,1}, holesleila{:,3});
hold on;
text(holesleila{:,1}-.8, holesleila{:,3}+2,...
    num2str(holesleila{:,3}),'FontSize', 14);
xlabel('year');
ylabel('no. sinkholes');
title('number of holes mapped each year');
subplot(2,3,4);
bar(holesleila{:,1},cumholesleila);
hold on;
text(holesleila{:,1}-.8, cumholesleila+20, num2str(cumholesleila),...
    'FontSize', 14);
xlabel('year');
ylabel('no. sinkholes');
title('cumulative number of holes mapped each year');

subplot(2,3,5);
bar(holesnoOF{:,1}, holesnoOF{:,3});
hold on;
text(holesnoOF{:,1}-.8, holesnoOF{:,3}+2,...
    num2str(holesnoOF{:,3}),'FontSize', 14);
xlabel('year');
ylabel('no. sinkholes');
title('number of holes mapped each year');
subplot(2,3,6);
bar(holesnoOF{:,1},cumholesnoOF);
hold on;
text(holesnoOF{:,1}-.8, cumholesnoOF+20, num2str(cumholesnoOF),...
    'FontSize', 14);
xlabel('year');
ylabel('no. sinkholes');
title('cumulative number of holes mapped each year');
end

%% plot time series of sinkholes mapped with monthly time ticks
tR = datetime(holesRAW0902{:,2}, 'InputFormat','yyyy/MM/dd');
datnumR = datenum(tR);
datnumR = datnumR';

tOF = datetime(holesnoOF{:,2}, 'InputFormat','yyyy/MM/dd');
datnumOF = datenum(tOF);
datnumOF = datnumOF';

tL = datetime(holesleila{:,2}, 'InputFormat','yyyy/MM/dd');
datnumL = datenum(tL);
datnumL = datnumL';

% interpolate sinkhole time series using pchip function
xq1 = datnumR(1):30:datnumR(17);
sink_pchip = pchip(datnumR,  holesRAW0902{:,3}, xq1);

if fig2 == 1
figure(2);
bar(datnumR, cumholesRAW);
hold on;
plot(xq1, sink_pchip, 'LineWidth', 1.2);
dateFormat = 'yyyy';
datetick('x', dateFormat);
xlabel('year');
ylabel('no. sinkholes');
end

% compare mine and leila's data

if fig3 == 1
figure(3);
subplot(2,2,1);
bar(datnumR, cumholesRAW);
hold on;
bar(datnumR, holesRAW0902{:,3});
dateFormat = 'yyyy';
datetick('x', dateFormat);
xlabel('year');
ylabel('no. sinkholes');
subplot(2,2,2);
bar(datnumL, cumholesleila);
hold on;
bar(datnumL, holesleila{:,3});
dateFormat = 'yyyy';
datetick('x', dateFormat);
xlabel('year');
ylabel('no. sinkholes');
subplot(2,2,3);
bar(datnumOF, cumholesnoOF);
hold on;
bar(datnumOF, holesnoOF{:,3});
dateFormat = 'yyyy';
datetick('x', dateFormat);
xlabel('year');
ylabel('no. sinkholes');
end

%% incorperate buried/refilled sinkholes reported elsewhere

% load in data and sort into sensible array
SH_unmapped = load('SH_add_refill_bur.txt');
SH_all = load('SH_total.txt');

cumholesall = cumsum(SH_all(:,2));
mean_formation_sat = mean(SH_all(12:25,2));
mean_formation_all = mean(SH_all(:,2));

if fig4 ==1
figure(4);
bar(SH_all(:,1),cumholesall);
hold on;
bar(SH_all(:,1),SH_all(:,2));
bar(holesRAW0902{:,1}, holesRAW0902{:,3});
axis([1984 2018 0 1100]);
end


% try to fit exponential and linear trends to sinkhole development

y1 = linspace(2009, 2018, 10);
p1 = polyfit(SH_all(17:25,1), cumholesall(17:25), 1);
SH_lin = polyval(p1, y1);

y2 = linspace(1985, 2010, 18)';
[SH_exp, ~] = fit(SH_all(1:17,1), cumholesall(1:17), 'exp1');

if fig4 == 1
figure(4);
exp_tr_SH = plot(SH_exp);
exp_tr_SH.LineWidth = 1.2;
exp_tr_SH.Color = 'red';
plot(y1, SH_lin, 'r--', 'LineWidth', 1.5);
xlabel('year');
ylabel('no. sinkholes');
text(SH_all(:,1)-.5, cumholesall+20, num2str(cumholesall),...
    'FontSize', 14, 'FontWeight', 'bold');
lgd = legend('cumulative - total', 'incremental - local information', 'incremental - satellite mapping', 'exponential trend: 1985 - 2009', 'linear trend: 2010 - present', 'Location', 'northwest');
lgd.FontSize = 14;
end