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

% take ES subsets.
% values are for the 06-01_pfh_s1_CO test
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

bobs = real(rad2bt(vobs, abs(robs)));

figure(1)
set(gcf, 'DefaultAxesColorOrder', fovcolors);
plot(vobs, bobs(:,:),'linewidth',2)
title(sprintf('test leg %s, calibrated radiances as BT', tleg))
switch tleg
  case 'ET1', ylim([325, 329]),
  case 'ET2', ylim([312, 318])
end
legend(fovnames,  'location', 'south')
xlabel('wavenumber')
ylabel('BT')
grid on; zoom on
% saveas(gcf, sprintf('%s_cal_rad_all_FOVs', tleg), 'fig')


