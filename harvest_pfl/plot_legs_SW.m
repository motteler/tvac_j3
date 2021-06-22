%
% plot SW test legs, uses data from read_ccs
%
% T1 > T2
%

addpath ../source
d02 = load('ccs_data_05_27');
dbase2 = datenum('27 May 2021');

% ET2, nominal 320K, cell empty
t1 = hhmmss_to_hour('01:47:17');
t2 = hhmmss_to_hour('02:01:32');
plot_leg(d02, dbase2, t1, t2, 'SW ET2', 1);
subplot(3,1,1); ylim([319.2, 320.2])
saveas(gcf, '05-27_SW_ET2', 'fig')

% FT2 nominal 320K, 50 Torr, 16 C
t1 = hhmmss_to_hour('03:55:00');
t2 = hhmmss_to_hour('04:08:45');
plot_leg(d02, dbase2, t1, t2, 'SW FT2', 2);
subplot(3,1,1); ylim([319.2, 320.2])
saveas(gcf, '05-27_SW_FT2', 'fig')

% FT1, nominal 331K, 50 Torr, 16 C
t1 = hhmmss_to_hour('06:45:31');
t2 = hhmmss_to_hour('07:01:13');
plot_leg(d02, dbase2, t1, t2, 'SW FT1', 3);
subplot(3,1,1); ylim([330.2, 331.2])
saveas(gcf, '05-27_SW_FT1', 'fig')

% ET1 nominal 331K, cell empty
t1 = hhmmss_to_hour('08:44:44');
t2 = hhmmss_to_hour('09:01:43');
plot_leg(d02, dbase2, t1, t2, 'SW ET1', 4);
subplot(3,1,1); ylim([330.2, 331.2])
saveas(gcf, '05-27_SW_ET1', 'fig')

