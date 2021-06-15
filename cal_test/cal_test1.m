%
% cal_test1 -- basic calibrated radiances, ccast eqn (1)
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

% select a test leg
tleg = upper(input('test leg (e.g., FT2) > ', 's'));
mfile = fullfile('./', tleg);
load(mfile);

% get wlaser from eng and neon
opt2 = struct;
opt2.neonWL = 703.44765;  % Larrabee's value
[wlaser, wtime] = metlaser(d1.packet.NeonCal, opt2);

% get instrument params
band = 'SW';
opt1 = struct; 
opt1.user_res = 'hires';
opt1.inst_res = 'hires4';
[inst, user] = inst_params(band, wlaser, opt1);

% choose a sweep direction
sdir = 0;

fprintf(1, 'eng neon=%.5f assigned neon=%.5f, wlaser=%.5f\n', ... 
  d1.packet.NeonCal.NeonGasWavelength, opt2.neonWL, wlaser);

% read the interferograms
[igm_es, time_es, igm_sp, time_sp, igm_it, time_it] = ...
   read_igm(band, mfile, sdir);

% translate to count spectra
spec_es = igm2spec(igm_es, inst);
spec_sp = igm2spec(igm_sp, inst);
spec_it = igm2spec(igm_it, inst);

% take ES subsets.  NOTE: limits here are from spec_test 1
switch tleg
  case 'ET2', ix = 20:345;
  case 'ET1', ix = 554:871;
  case 'FT2', ix = 20:255;
  case 'FT1', ix = 20:345;
end

spec_es = spec_es(:, :, ix);
time_es = time_es(:, ix);

% get obs times in matlab format
dnum_es = iet2dnum(time_es(5,:));
dtime_es = datetime(dnum_es, 'ConvertFrom', 'datenum');

dnum_sp = iet2dnum(time_sp(5,:));
dtime_sp = datetime(dnum_sp, 'ConvertFrom', 'datenum');

dnum_it = iet2dnum(time_it(5,:));
dtime_it = datetime(dnum_it, 'ConvertFrom', 'datenum');

% take the ES, IT, and SP means
mean_es = mean(spec_es, 3);
mean_sp = mean(spec_sp, 3);
mean_it = mean(spec_it, 3);

% take the basic calibration ratio
robs = (mean_es - mean_sp) ./ (mean_it - mean_sp);
robs = bandpass(inst.freq, robs, user.v1, user.v2, user.vr);

% get the SA inverse matrix
  sfile = '../inst_data/SAinv_j3_eng_SW';
% sfile = '../inst_data/SAinv_default_HR4_SW';
opt1.SW_sfile = sfile;
Sinv = getSAinv(inst, opt1);

% apply the SA invers matrix
for i = 1 : 9
  robs(:, i) = Sinv(:,:,i) * robs(:, i);
end
robs = bandpass(inst.freq, robs, user.v1, user.v2, user.vr);

% get expected ICT radiance
nsci = ztail(d1.data.sci.Temp.time);
ict_temps = ICT_countsToK(d1.data.sci.Temp, d1.packet.TempCoeffs, nsci);
tICT = mean([ict_temps.T_PRT1,ict_temps.T_PRT2]);
rICT = bt2rad(inst.freq, tICT);

% multiply by expected radiance
for i = 1 : 9
  robs(:, i) = rICT .* robs(:, i);
end

bobs = rad2bt(inst.freq, real(robs));

figure(1)
set(gcf, 'DefaultAxesColorOrder', fovcolors);
plot(inst.freq, real(bobs(:,:)),'linewidth',2)
title(sprintf('test leg %s, calibrated radiances as BT', tleg))
legend(fovnames,  'location', 'best')
xlabel('wavenumber')
ylabel('BT')
grid on; zoom on
saveas(gcf, sprintf('%s_cal_rad_all_FOVs', tleg), 'fig')

% save(sprintf('cal_%s', tleg), 'robs', 'inst', 'tleg')

% return

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
saveas(gcf, sprintf('%s_ES_all_FOVs', tleg), 'fig')
saveas(gcf, sprintf('%s_ES_all_FOVs', tleg), 'png')

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
saveas(gcf, sprintf('%s_SP_all_FOVs', tleg), 'fig')
saveas(gcf, sprintf('%s_SP_all_FOVs', tleg), 'png')
            
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
saveas(gcf, sprintf('%s_IT_all_FOVs', tleg), 'fig')
saveas(gcf, sprintf('%s_IT_all_FOVs', tleg), 'png')
