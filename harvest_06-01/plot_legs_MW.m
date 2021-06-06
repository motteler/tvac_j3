%
% plot MW test legs, uses data from read_ccs
%
% T1 > T2
%

addpath ../source
d02 = load('ccs_data_06_01');
d03 = load('ccs_data_06_02');
dbase2 = datenum('01 Jun 2021');
dbase3 = datenum('02 Jun 2021');

% ET2, nominal 320K, cell empty
t1 = hhmmss_to_hour('20:02:43');
t2 = hhmmss_to_hour('20:19:16');
plot_leg(d02, dbase2, t1, t2, 'MW ET2', 1);
subplot(3,1,1); ylim([319.2, 320.2])
saveas(gcf, '06-01_MW_ET2', 'fig')

% FT2 nominal 320K, 50 Torr, 16 C
t1 = hhmmss_to_hour('23:11:53');
t2 = hhmmss_to_hour('23:27:45');
plot_leg(d02, dbase2, t1, t2, 'MW FT2', 2);
subplot(3,1,1); ylim([319.2, 320.2])
saveas(gcf, '06-01_MW_FT2', 'fig')

% FT1, nominal 345K, 50 Torr, 16 C
t1 = hhmmss_to_hour('03:31:01');
t2 = hhmmss_to_hour('03:48:12');
plot_leg(d03, dbase3, t1, t2, 'MW FT1', 3);
subplot(3,1,1); ylim([349.2, 350.2])
saveas(gcf, '06-02_MW_FT1', 'fig')

% ET1 nominal 345K, cell empty
t1 = hhmmss_to_hour('06:22:50');
t2 = hhmmss_to_hour('06:39:12');
plot_leg(d03, dbase3, t1, t2, 'MW ET1', 4);
subplot(3,1,1); ylim([349.2, 350.2])
saveas(gcf, '06-02_MW_ET1', 'fig')

