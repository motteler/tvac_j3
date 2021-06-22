%
% cal_rad_test
%
% main test parameters
%   band    - 'LW', 'MW', or 'SW'
%   wlaser  - metrology laser half-wavelength
%   mfile   - mat file, output from the MIT reader
%   sdir    - sweep direction, 0 or 1
%   ifov    - choose a FOV for figure 1
%   ifrq    - frequency index for figure 2
%

% paths and libs
addpath /asl/packages/ccast/source
addpath /asl/packages/ccast/motmsc/time
addpath /asl/packages/ccast/davet
addpath ../source

% select a band
band = upper(input('band (e.g., LW) > ', 's'));

% select a test leg
tleg = upper(input('test leg (e.g., FT2) > ', 's'));
mfile = fullfile('./', tleg);
load(mfile);

% take ES subsets.  NOTE: limits here are from spec_test 1
switch tleg
  case 'ET2', eset = 20:345;
  case 'ET1', eset = 554:871;
  case 'FT2', eset = 20:255;
  case 'FT1', eset = 20:345;
end

% choose a sweep direction
opt1 = struct;
opt1.sdir = 0;

% get wlaser from eng and neon
opt2 = struct;
opt2.neonWL = 703.44765;  % Larrabee's value
[wlaser, wtime] = metlaser(d1.packet.NeonCal, opt2);

fprintf(1, 'eng neon=%.5f assigned neon=%.5f, wlaser=%.5f\n', ... 
  d1.packet.NeonCal.NeonGasWavelength, opt2.neonWL, wlaser);

[robs, vobs] = cal_rad(band, wlaser, d1, eset, opt1);

bobs = rad2bt(vobs, real(robs));

return

figure(1)
set(gcf, 'DefaultAxesColorOrder', fovcolors);
plot(inst.freq, real(bobs(:,:)),'linewidth',2)
title(sprintf('test leg %s, calibrated radiances as BT', tleg))
legend(fovnames,  'location', 'best')
xlabel('wavenumber')
ylabel('BT')
grid on; zoom on
% saveas(gcf, sprintf('%s_cal_rad_all_FOVs', tleg), 'fig')

% save(sprintf('cal_%s', tleg), 'robs', 'inst', 'tleg')

return

% show all ES FOVs at one frequency
figure(2); clf
set(gcf, 'DefaultAxesColorOrder', fovcolors);
ifrq = floor(inst.npts/2);
vseq = squeeze(abs(spec_es(ifrq, :, :)));
[m, nobs] = size(vseq);
plot(dtime_es, vseq, '.')
% xlim([t1, t2])
title(sprintf('test leg %s, ES, all FOVs at %.2f cm-1', tleg, inst.freq(ifrq)))
legend(fovnames,  'location', 'best')
xlabel('hour')
ylabel('count')
grid on; zoom on
% saveas(gcf, sprintf('%s_ES_all_FOVs', tleg), 'fig')


% show all SP FOVs at one frequency
figure(3); clf
set(gcf, 'DefaultAxesColorOrder', fovcolors);
vseq = squeeze(abs(spec_sp(ifrq, :, :)));
[m, nobs] = size(vseq);
plot(dtime_sp, vseq, '.')
% xlim([t1, t2])
title(sprintf('test leg %s, SP, all FOVs at %.2f cm-1', tleg, inst.freq(ifrq)))
legend(fovnames,  'location', 'south')
xlabel('hour')
ylabel('count')
grid on; zoom on
% saveas(gcf, sprintf('%s_SP_all_FOVs', tleg), 'fig')
            
% show all IT FOVs at one frequency
figure(4); clf
set(gcf, 'DefaultAxesColorOrder', fovcolors);
vseq = squeeze(abs(spec_it(ifrq, :, :)));
[m, nobs] = size(vseq);
plot(dtime_it, vseq, '.')
% xlim([t1, t2])
title(sprintf('test leg %s, IT, all FOVs at %.2f cm-1', tleg, inst.freq(ifrq)))
legend(fovnames,  'location', 'south')
xlabel('hour')
ylabel('count')
grid on; zoom on
% saveas(gcf, sprintf('%s_IT_all_FOVs', tleg), 'fig')

