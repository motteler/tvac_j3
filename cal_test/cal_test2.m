%
% cal_test2 -- transmittance from calibrated radiances
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

fprintf(1, 'eng neon=%.5f assigned neon=%.5f, wlaser=%.5f\n', ... 
  d1.packet.NeonCal.NeonGasWavelength, opt2.neonWL, wlaser);

% get instrument params
band = 'SW';
opt1 = struct; 
opt1.user_res = 'hires';
opt1.inst_res = 'hires4';
[inst, user] = inst_params(band, wlaser, opt1);

% load calibrated radiances
d1 = load('cal_ET2'); rET2 = d1.robs;
d2 = load('cal_ET1'); rET1 = d2.robs;
d3 = load('cal_FT2'); rFT2 = d3.robs;
d4 = load('cal_FT1'); rFT1 = d4.robs;

% get the transmittance
tobs = real((rFT2 - rFT1) ./ (rET2 - rET1));

% plot(inst.freq, tobs(:,5))
% ylim([0,1.2])

% get calc values
abswt = 12.69;
d1 = load('lblr_CO_49p58_Torr_17p15_C');
[tcal, vcal] = kc2inst(inst, user, exp(-d1.absc * abswt), d1.fr);

% check frequency grids
% isclose(inst.freq, vcal)

jx = user.v1 <= inst.freq & inst.freq <= user.v2;

% plot the results
[tobs2, freq2] = finterp2(tobs(jx,:), inst.freq(jx,:), 20);
[tcal2, freq2] = finterp2(tcal(jx,:), inst.freq(jx,:), 20);

figure(1); clf
plot(freq2, tobs2, freq2, tcal2, 'k-.');
xlim([2100, 2600])
title('observed and calculated transmittance')
legend(fovnames, 'location', 'south')
grid; zoom on
xlabel('wavenumber')
ylabel('transmittance')
grid on; zoom on
% saveas(gcf, 'cal_test2_all', 'fig')

figure(2); clf
plot(freq2, tobs2, freq2, tcal2, 'k-.');
xlim([2160,2200])
title('observed and calculated transmittance detail')
legend(fovnames, 'location', 'southeast')
grid; zoom on
xlabel('wavenumber')
ylabel('transmittance')
grid on; zoom on
% saveas(gcf, 'cal_test2_zoom', 'fig')

