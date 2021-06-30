%
% check_trans - compare calc with obs from calibrated radiances
%
% main test parameters
%   band     - 'LW', 'MW', or 'SW'
%   wlaser   - metrology laser half-wavelength
%   sfile    - SRF matrix for the current wlaser range
%   afile    - tabulated absorptions, at 0.0025 cm-1 grid
%   abswt    - scale factor for tabulated absorptions
%   sdir     - sweep direction, 0 or 1
%
% edit as needed
%

% paths and libs
addpath /asl/packages/ccast/source
addpath /asl/packages/ccast/motmsc/utils
addpath /asl/packages/airs_decon/test
addpath ../source
addpath ../gas_calcs

% put all the options in one basket
opts = struct;

% location for test data
test_dir = '.';

% get wlaser from eng and neon
opts.neonWL = 703.44765;   % Larrabee's value
load(fullfile(test_dir, 'FT2'));
[wlaser, wtime] = metlaser(d1.packet.NeonCal, opts);

fprintf(1, 'eng neon=%.5f assigned neon=%.5f, wlaser=%.5f\n', ... 
  d1.packet.NeonCal.NeonGasWavelength, opts.neonWL, wlaser);

% get instrument params
band = 'SW';
opts.user_res = 'hires';
opts.inst_res = 'hires4';
[inst, user] = inst_params(band, wlaser, opts);

% specify the ES subsets
% values are for the 06-01_pfh_s1_CO test
igm  = struct;
igm.et1_ix = 25:345;
igm.et2_ix = 754:1069;
igm.ft1_ix = 25:345;
igm.ft2_ix = 25:340;

% load the test legs
load('ET1'); igm.et1 = d1;
load('ET2'); igm.et2 = d1;
load('FT1'); igm.ft1 = d1;
load('FT2'); igm.ft2 = d1;
clear d1;

% get the transmittance
opts.sdir = 0;
opts.sfile = '../inst_data/SAinv_j3_eng_SW';
[tobs, vobs] = cal_tran(band, wlaser, igm, opts);

% get calc values
abswt = 12.69;
d1 = load('lblr_CO_49p58_Torr_17p15_C');
[tcal, vcal] = kc2inst(inst, user, exp(-d1.absc * abswt), d1.fr);

% check frequency grids
% isclose(inst.freq, vcal)

% stick with the user grid
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
saveas(gcf, 'check_trans_all', 'fig')

figure(2); clf
plot(freq2, tobs2, freq2, tcal2, 'k-.');
xlim([2160,2200])
title('observed and calculated transmittance detail')
legend(fovnames, 'location', 'southeast')
grid; zoom on
xlabel('wavenumber')
ylabel('transmittance')
grid on; zoom on
% saveas(gcf, 'check_trans_zoom', 'fig')

