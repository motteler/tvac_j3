%
% plot LW test legs, uses data from read_ccs
%
% T1 > T2
%

addpath ../source
d02 = load('ccs_data_05_25');
d03 = load('ccs_data_05_26');
dbase2 = datenum('25 May 2021');
dbase3 = datenum('26 May 2021');

% ET1, nominal 345K, cell empty
t1 = hhmmss_to_hour('22:13:52');
t2 = hhmmss_to_hour('22:30:08');
plot_leg(d02, dbase2, t1, t2, 'LW ET1', 1);
subplot(3,1,1); ylim([344.2, 345.2])
saveas(gcf, '05-25_LW_ET1', 'fig')

% ET2 nominal 320K, cell empty
t1 = hhmmss_to_hour('00:21:49');
t2 = hhmmss_to_hour('00:37:59');
plot_leg(d03, dbase3, t1, t2, 'LW ET2', 2);
subplot(3,1,1); ylim([319.2, 320.2])
saveas(gcf, '05-26_LW_ET2', 'fig')

% FT2, nominal 320K, 50 Torr, 16 C
t1 = hhmmss_to_hour('00:56:11');
t2 = hhmmss_to_hour('01:13:33');
plot_leg(d03, dbase3, t1, t2, 'LW FT2', 3);
subplot(3,1,1); ylim([319.2, 320.2])
subplot(3,1,2); ylim([49.4, 49.5])
saveas(gcf, '05-26_LW_FT2', 'fig')

% FT1 nominal 345K, 50 Torr, 16 C
t1 = hhmmss_to_hour('03:24:50');
t2 = hhmmss_to_hour('03:46:47');
plot_leg(d03, dbase3, t1, t2, 'LW FT1', 4);
subplot(3,1,1); ylim([344.2, 345.2])
subplot(3,1,2); ylim([49.42, 49.44]) 
saveas(gcf, '05-26_LW_FT1', 'fig')

