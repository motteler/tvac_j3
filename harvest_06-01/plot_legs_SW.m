%
% plot SW test legs, uses data from read_ccs
%
% T1 > T2
%

addpath ../source
d02 = load('ccs_data_06_01');
dbase2 = datenum('01 Jun 2021');

% ET1, nominal 330K, cell empty
t1 = hhmmss_to_hour('09:51:58');
t2 = hhmmss_to_hour('10:07:39');
plot_leg(d02, dbase2, t1, t2, 'SW ET1', 1);
subplot(3,1,1); ylim([330.2, 331.2])
saveas(gcf, '06-01_SW_ET1', 'fig')

% FT1 nominal 330K, 50 Torr, 16 C
t1 = hhmmss_to_hour('11:48:23');
t2 = hhmmss_to_hour('12:02:49');
plot_leg(d02, dbase2, t1, t2, 'SW FT1', 2);
subplot(3,1,1); ylim([330.2, 331.2])
saveas(gcf, '06-01_SW_FT1', 'fig')

% FT2, nominal 320K, 50 Torr, 16 C
t1 = hhmmss_to_hour('13:57:58');
t2 = hhmmss_to_hour('14:14:57');
plot_leg(d02, dbase2, t1, t2, 'SW FT2', 3);
subplot(3,1,1); ylim([319.2, 320.2])
subplot(3,1,2); ylim([49.0, 49.05])
saveas(gcf, '06-01_SW_FT2', 'fig')

% ET2 nominal 320K, cell empty
t1 = hhmmss_to_hour('19:25:41');
t2 = hhmmss_to_hour('19:43:08');
plot_leg(d02, dbase2, t1, t2, 'SW ET2', 4);
subplot(3,1,1); ylim([319.2, 320.2])
saveas(gcf, '06-01_SW_ET2', 'fig')

