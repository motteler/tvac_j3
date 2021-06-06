%
% plot MW test legs, uses data from read_ccs
%
% T1 > T2
%

addpath ../source
d02 = load('ccs_data_05_26');
d03 = load('ccs_data_05_27');
dbase2 = datenum('26 May 2021');
dbase3 = datenum('27 May 2021');

% ET1, nominal 345K, cell empty
t1 = hhmmss_to_hour('09:47:43');
t2 = hhmmss_to_hour('10:01:57');
plot_leg(d02, dbase2, t1, t2, 'MW ET1', 1);
subplot(3,1,1); ylim([344.2, 345.2])
saveas(gcf, '05-26_MW_ET1', 'fig')

% FT1 nominal 345K, 50 Torr, 16 C
t1 = hhmmss_to_hour('11:15:46');
t2 = hhmmss_to_hour('11:29:57');
plot_leg(d02, dbase2, t1, t2, 'MW FT1', 2);
subplot(3,1,1); ylim([344.2, 345.2])
saveas(gcf, '05-26_MW_FT1', 'fig')

% FT2, nominal 320K, 50 Torr, 16 C
t1 = hhmmss_to_hour('13:19:41');
t2 = hhmmss_to_hour('13:33:22');
plot_leg(d02, dbase2, t1, t2, 'MW FT2', 3);
subplot(3,1,1); ylim([319.2, 320.2])
saveas(gcf, '05-26_MW_FT2', 'fig')

% ET2 nominal 320K, cell empty
t1 = hhmmss_to_hour('01:11:08');
t2 = hhmmss_to_hour('01:25:01');
plot_leg(d03, dbase3, t1, t2, 'MW ET2', 4);
subplot(3,1,1); ylim([319.2, 320.2])
saveas(gcf, '05-27_MW_ET2', 'fig')

