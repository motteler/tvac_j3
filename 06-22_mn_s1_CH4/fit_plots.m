%
% fit_plots -- more plots, use after fit_run
%

% ------------------------
% obs minus calc breakout
% ------------------------

fname = fovnames;
fcolor = fovcolors;
tdif = tobs5 - tcal4;

figure(4); clf
set(gcf, 'DefaultAxesColorOrder', fcolor);

subplot(2,1,1)
plot(vobs4, tdif)
axis([qv1, qv2, -.02, .02])
xlabel('wavenumber')
ylabel('transmittance difference')
title('obs minus calc all FOVs')
legend(fname, 'location', 'southeast')
grid on; zoom on

subplot(2,1,2)
ix = 5;
set(gcf, 'DefaultAxesColorOrder', fcolor(ix,:));
plot(vobs4, tdif(:, ix))
axis([qv1, qv2, -.02, .02])
xlabel('wavenumber')
ylabel('transmittance difference')
title('obs minus calc FOV 5')
legend(fname{ix}, 'location', 'southeast')
grid on; zoom on
saveas(gcf, 'CH4_breakout_1', 'fig')

figure(5); clf
set(gcf, 'DefaultAxesColorOrder', fcolor);

subplot(2,1,1)
ix = [2 4 6 8];
set(gcf, 'DefaultAxesColorOrder', fcolor(ix,:));
plot(vobs4, tdif(:, ix))
axis([qv1, qv2, -.02, .02])
xlabel('wavenumber')
ylabel('transmittance difference')
title('obs minus calc side FOVs')
legend(fname{ix}, 'location', 'southeast')
grid on; zoom on

subplot(2,1,2)
ix = [1 3 7 9];
set(gcf, 'DefaultAxesColorOrder', fcolor(ix,:));
plot(vobs4, tdif(:, ix))
axis([qv1, qv2, -.02, .02])
xlabel('wavenumber')
ylabel('transmittance difference')
title('obs minus calc corner FOVs')
legend(fname{ix}, 'location', 'southeast')
grid on; zoom on
saveas(gcf, 'CH4_breakout_2', 'fig')

return

% ------------------------
%  full band obs and calc
% ------------------------

% get user grid for band edges
[inst, user] = inst_params(band, wlaser, opt);

figure(6); clf
set(gcf, 'DefaultAxesColorOrder', fovcolors);

plot(vobs4, tobs5, vobs4, tcal4, 'k-.');
axis([user.v1, user.v2, 0.6, 1.1])
xlabel('wavenumber')
ylabel('transmittance')
title(sprintf('%s D%d, obs and calc full band', pname, sdir));
legend(fovnames, 'location', 'southeast')
grid on; zoom on

% -------------------------
% full band obs minus calc 
% -------------------------

figure(7); clf
set(gcf, 'DefaultAxesColorOrder', fovcolors);

plot(vobs4, tdif);
axis([user.v1, user.v2, -.02, .02])
xlabel('wavenumber')
ylabel('transmittance difference')
title('obs minus calc full band')
legend(fovnames, 'location', 'southeast')
grid on; zoom on

return

% ------------------------------
% summary stats in tabular form
% ------------------------------

% show residuals
fprintf(1, 'residuals, var dmin\n')
display(fliplr(reshape(dmin, 3, 3)));

[tmin, imin] = min(dr);
ftabtmp = wppm(imin);
ppmerr1 = fliplr(reshape(ftabtmp, 3, 3));
display(ppmerr1)

% ppmerr2 = ppmerr1 - ftabtmp(5);
% display(ppmerr2)

% show FOV indices
fprintf(1, 'FOV indices\n')
display(fliplr(reshape(1:9, 3, 3)));

% print out best regression fit weights
fprintf(1, '\nfit_tran: Regression Fitting Weights\n')
for fi = 1 : 9
  fprintf(1, ...
    'FOV %1d: a = %5.3f  b = %6.4f  drms = %6.4f  wlaser = %7.4f \n', ...
     fi, wa(fi), wb(fi), dmin(fi), wfov(fi));
end

