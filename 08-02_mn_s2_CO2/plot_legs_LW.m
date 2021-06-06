%
% plot LW test legs, uses data from read_ccs
%
% T1 > T2
%

addpath ../source
d02 = load('ccs_data_08_02');
d03 = load('ccs_data_08_03');
dbase2 = datenum('2 Aug 2020');
dbase3 = datenum('3 Aug 2020');

% ET1, 350K, cell empty
t1 = hhmmss_to_hour('21:57:30');
t2 = hhmmss_to_hour('22:08:49');
plot_leg(d02, dbase2, t1, t2, 'LW ET1', 1);
subplot(3,1,1); ylim([349.0, 350.4])
saveas(gcf, '08-02_LW_ET1', 'png')

% ET2 320K, cell empty
t1 = hhmmss_to_hour('00:15:53');
t2 = hhmmss_to_hour('00:27:12');
plot_leg(d03, dbase3, t1, t2, 'LW ET2', 2);
subplot(3,1,1);  ylim([319.0, 320.2])
saveas(gcf, '08-03_LW_ET2', 'png')

% FT2, 320K, 34.0 Torr, 15.94 C
t1 = hhmmss_to_hour('01:30:21');
t2 = hhmmss_to_hour('01:41:41');
plot_leg(d03, dbase3, t1, t2, 'LW FT2', 3);
subplot(3,1,1);  ylim([319.0, 320.2])
saveas(gcf, '08-03_LW_FT2', 'png')

% FT1 350K, 50.2 Torr 16.05 C
t1 = hhmmss_to_hour('04:18:18');
t2 = hhmmss_to_hour('04:29:37');
plot_leg(d03, dbase3, t1, t2, 'LW FT1', 4);
subplot(3,1,1); ylim([349.0, 350.4])
saveas(gcf, '08-03_LW_FT1', 'png')

