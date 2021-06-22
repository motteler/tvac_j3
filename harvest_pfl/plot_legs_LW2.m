%
% plot LW test legs, uses data from read_ccs
%
% T1 > T2
%

addpath ../source
d02 = load('ccs_data_05_19');
d03 = load('ccs_data_05_20');
dbase2 = datenum('19 May 2021');
dbase3 = datenum('20 May 2021');

% ET1, nominal 345K, cell empty
t1 = hhmmss_to_hour('23:04:09');
t2 = hhmmss_to_hour('23:36:04');
plot_leg(d02, dbase2, t1, t2, 'LW ET1', 1);
subplot(3,1,1);  ylim([344.2, 345.2])
saveas(gcf, '05-19_LW_ET1', 'fig')

% ET2 nominal 320K, cell empty
t1 = hhmmss_to_hour('02:16:59');
t2 = hhmmss_to_hour('02:33:38');
plot_leg(d03, dbase3, t1, t2, 'LW ET2', 2);
subplot(3,1,1);  ylim([319.2, 320.2])
saveas(gcf, '05-20_LW_ET2', 'fig')

% FT2, nominal 320K, 50 Torr, 16 C
t1 = hhmmss_to_hour('03:01:29');
t2 = hhmmss_to_hour('03:17:45');
plot_leg(d03, dbase3, t1, t2, 'LW FT2', 3);
subplot(3,1,1);  ylim([319.2, 320.2])
saveas(gcf, '05-20_LW_FT2', 'fig')

% FT1 nominal 345K, 50 Torr, 16 C
t1 = hhmmss_to_hour('05:45:43');
t2 = hhmmss_to_hour('06:03:35');
plot_leg(d03, dbase3, t1, t2, 'LW FT1', 4);
subplot(3,1,1);  ylim([344.2, 345.2])
subplot(3,1,2);  ylim([49.64, 49.67]) 
saveas(gcf, '05-20_LW_FT1', 'fig')

