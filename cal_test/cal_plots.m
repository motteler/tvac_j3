%
% fit_plots -- more plots, use after fit_run
%

% ------------------------
% obs minus calc breakout
% ------------------------

fname = fovnames;
fcolor = fovcolors;
tdif = tobs2 - tcal2;
qv1   = 2160;   % fitting interval start
qv2   = 2240;   % fitting interval end

figure(3); clf
plot(freq2, tdif);
xlim([2100, 2600])
title('observed minus calculated transmittance')
legend(fovnames, 'location', 'south')
grid; zoom on
xlabel('wavenumber')
ylabel('transmittance')
grid on; zoom on

figure(4); clf
set(gcf, 'DefaultAxesColorOrder', fcolor);

subplot(2,1,1)
plot(freq2, tdif)
axis([qv1, qv2, -.10, .10])
xlabel('wavenumber')
ylabel('transmittance difference')
title('obs minus calc all FOVs')
% legend(fname, 'location', 'southeast')
grid on; zoom on

subplot(2,1,2)
ix = 5;
set(gcf, 'DefaultAxesColorOrder', fcolor(ix,:));
plot(freq2, tdif(:, ix))
axis([qv1, qv2, -.10, .10])
xlabel('wavenumber')
ylabel('transmittance difference')
title('obs minus calc FOV 5')
legend(fname{ix}, 'location', 'southeast')
grid on; zoom on
saveas(gcf, 'CO_cal_breakout_1', 'fig')

figure(5); clf
set(gcf, 'DefaultAxesColorOrder', fcolor);

subplot(2,1,1)
ix = [2 4 6 8];
set(gcf, 'DefaultAxesColorOrder', fcolor(ix,:));
plot(freq2, tdif(:, ix))
axis([qv1, qv2, -.10, .10])
xlabel('wavenumber')
ylabel('transmittance difference')
title('obs minus calc side FOVs')
legend(fname{ix}, 'location', 'southeast')
grid on; zoom on

subplot(2,1,2)
ix = [1 3 7 9];
set(gcf, 'DefaultAxesColorOrder', fcolor(ix,:));
plot(freq2, tdif(:, ix))
axis([qv1, qv2, -.10, .10])
xlabel('wavenumber')
ylabel('transmittance difference')
title('obs minus calc corner FOVs')
legend(fname{ix}, 'location', 'southeast')
grid on; zoom on
saveas(gcf, 'CO_cal_breakout_2', 'fig')

