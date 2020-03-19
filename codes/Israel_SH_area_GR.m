%-------------------------------------------------------+
% Script to plot area covered by sinkholes at six sites |
% in Israel and compare trends in growth rate between   |
% the sites, then comparing to GAH.                     |
%                                                       |
% Rob Watson; 25/4/18                                   |
%-------------------------------------------------------+

%% read in data from text files

% sampling rate varies between sites
% first column is year; 2nd column is date (YYYY/MM/DD)
% area (column 3) covered is in m^2 and is cumulative 

% shalem (mineral beach, column 3) and mazor (column 4) 
fileID = fopen('SH_area_shalem_mazor.txt', 'r');
shalem_mazor = textscan(fileID, '%f %s %f %f');
fclose(fileID);

fileID = fopen('SH_area_lintch.txt', 'r');
lintch = textscan(fileID, '%f %s %f');
fclose(fileID);

fileID = fopen('SH_area_asael.txt', 'r');
asael = textscan(fileID, '%f %s %f');
fclose(fileID);

fileID = fopen('SH_area_qane.txt', 'r');
qane = textscan(fileID, '%f %s %f');
fclose(fileID);

fileID = fopen('SH_area_samar.txt', 'r');
samar = textscan(fileID, '%f %s %f');
fclose(fileID);

%% plot data by year

% all on one graph
figure(1);
plot(shalem_mazor{:,1}, shalem_mazor{:,3});
hold on;
plot(shalem_mazor{:,1}, shalem_mazor{:,4});
plot(qane{:,1}, qane{:,3});
plot(asael{:,1}, asael{:,3});
plot(samar{:,1}, samar{:,3});
xlabel('year');
ylabel('area of sinkhole coverage (m2)');
legend('shalem', 'mazor', 'qane', 'asael', 'samar', 'Location', 'NorthWest');

% as subplots

figure(2);
subplot(2,3,1);
plot(shalem_mazor{:,1}, shalem_mazor{:,3});
ylabel('area of sinkhole coverage (m2)');
title('Shalem');
xlim([1996 2015]); 
subplot(2,3,2);
plot(shalem_mazor{:,1}, shalem_mazor{:,4});
title('Mazor');
xlim([1996 2015]);
subplot(2,3,3);
plot(qane{:,1}, qane{:,3});
title('Qane');
xlim([1996 2015]);
subplot(2,3,4);
plot(asael{:,1}, asael{:,3});
ylabel('area of sinkhole coverage (m2)');
xlim([1996 2015]);
xlabel('year');
title('Asael');
subplot(2,3,5);
plot(samar{:,1}, samar{:,3});
xlabel('year');
xlim([1996 2015]);
title('Samar');
subplot(2,3,6);
plot(lintch{:,1}, lintch{:,3});
xlabel('year');
title('Lintch');
xlim([1996 2015]);

%% plot monthly sampled time series

% create monthly time ticks for plots

tSH_MZ = datetime(shalem_mazor{:,2}, 'InputFormat','yyyy/MM/dd');
datnumSH_MZ = datenum(tSH_MZ);
datnumSH_MZ = datnumSH_MZ';

tLTCH = datetime(lintch{:,2}, 'InputFormat','yyyy/MM/dd');
datnumLTCH = datenum(tLTCH);
datnumLTCH = datnumLTCH';

tAS = datetime(asael{:,2}, 'InputFormat','yyyy/MM/dd');
datnumAS = datenum(tAS);
datnumAS = datnumAS';

tQA = datetime(qane{:,2}, 'InputFormat','yyyy/MM/dd');
datnumQA = datenum(tQA);
datnumQA = datnumQA';

tSM = datetime(samar{:,2}, 'InputFormat','yyyy/MM/dd');
datnumSM = datenum(tSM);
datnumSM = datnumSM';

%% 
 