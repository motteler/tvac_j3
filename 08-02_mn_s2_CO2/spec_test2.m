%
% spec_test2 -- quick look at gas cell transmittance
%
% main test parameters
%   band     - 'LW', 'MW', or 'SW'
%   wlaser   - metrology laser half-wavelength
%   sfile    - SRF matrix for the current wlaser range
%   afile    - tabulated absorptions, at 0.0025 cm-1 grid
%   abswt    - scale factor for tabulated absorptions
%   mat_et2  - mat file for cell empty, BB t2
%   mat_et1  - mat file for cell empty, BB t1
%   mat_ft2  - mat file for cell full, BB t2
%   mat_ft1  - mat file for cell full, BB t1
%   sdir     - sweep direction, 0 or 1
%
% HM, 15 Jan 2014
%
% updated to get met laser from neon
% set test dir, band, optional subsetting and gas below
%

% paths and libs
addpath /asl/packages/ccast/source
addpath /asl/packages/ccast/motmsc/utils
addpath /asl/packages/airs_decon/test
addpath ../source
addpath ../gas_calcs

% location for test data
test_dir = '.';

% get wlaser from eng and neon
opt2 = struct;
opt2.neonWL = 703.44765;   % Larrabee's value
load(fullfile(test_dir, 'FT2'));
[wlaser, wtime] = metlaser(d1.packet.NeonCal, opt2);

% set wlaser directly.  increasing wlaser move obs peak down
% significantly, calc peak up slightly
% wlaser = 776.25;   % good fit around 720 cm-1, bad around 668 
% fprintf(1, 'warning: overriding calculated wlaser\n')

fprintf(1, 'eng neon=%.5f assigned neon=%.5f, wlaser=%.5f\n', ... 
  d1.packet.NeonCal.NeonGasWavelength, opt2.neonWL, wlaser);

% get instrument params
band = 'LW';
opt1 = struct; 
opt1.user_res = 'hires';
opt1.inst_res = 'hires4';
[inst, user] = inst_params(band, wlaser, opt1);

% get the SA inverse matrix
sfile = '../inst_data/SAinv_default_HR4_LW.mat';
opt1.LW_sfile = sfile;
Sinv = getSAinv(inst, opt1);

% test data files
mat_et2 = fullfile(test_dir, 'ET2');
mat_et1 = fullfile(test_dir, 'ET1');
mat_ft2 = fullfile(test_dir, 'FT2');
mat_ft1 = fullfile(test_dir, 'FT1');

% choose a sweep direction
sdir = 0;

% get the count spectra
count_ET2 = igm2spec(read_igm(band, mat_et2, sdir), inst);
count_ET1 = igm2spec(read_igm(band, mat_et1, sdir), inst);
count_FT2 = igm2spec(read_igm(band, mat_ft2, sdir), inst);
count_FT1 = igm2spec(read_igm(band, mat_ft1, sdir), inst);

% option to take subsets
count_ET2 = count_ET2(:, :, 20:344);
count_ET1 = count_ET1(:, :, 115:430);
count_FT2 = count_FT2(:, :, 18:342);
count_FT1 = count_FT1(:, :, 24:348);

% take means of the obs
mean_ET2 = mean(count_ET2, 3);
mean_ET1 = mean(count_ET1, 3);
mean_FT2 = mean(count_FT2, 3);
mean_FT1 = mean(count_FT1, 3);

% get the transmittance
tobs = real((mean_FT2 - mean_FT1) ./ (mean_ET2 - mean_ET1));

% apply SA-1
tobs = bandpass(inst.freq, tobs, user.v1, user.v2, user.vr);
for i = 1 : 9
  tobs(:, i) = Sinv(:,:,i) * tobs(:, i);
end
tobs = bandpass(inst.freq, tobs, user.v1, user.v2, user.vr);

% get calc values
abswt = 12.69;
d1 = load('umbc_CO2_49p43_Torr_15p60_C');
[tcal, vcal] = kc2inst(inst, user, exp(-d1.absc * abswt), d1.fr);

% check frequency grids
% isclose(inst.freq, vcal)

% plot the results
[tobs2, freq2] = finterp2(tobs, inst.freq, 20);
[tcal2, freq2] = finterp2(tcal, inst.freq, 20);

figure(1); clf
plot(freq2, tobs2, freq2, tcal2, 'k-.');
xlim([600, 1150])
title('observed and calculated transmittance')
legend(fovnames, 'location', 'south')
grid; zoom on
xlabel('wavenumber')
ylabel('transmittance')
grid on; zoom on

% saveas(gcf, 'spec_test2_all', 'fig')
% saveas(gcf, 'spec_test2_all', 'png')

figure(2); clf
plot(freq2, tobs2, freq2, tcal2, 'k-.');
% xlim([715, 725])
  xlim([717, 725])
title('observed and calculated transmittance detail')
legend(fovnames, 'location', 'southwest')
grid; zoom on
xlabel('wavenumber')
ylabel('transmittance')
grid on; zoom on

% saveas(gcf, 'spec_test2_zoom', 'fig')
% saveas(gcf, 'spec_test2_zoom', 'png')

