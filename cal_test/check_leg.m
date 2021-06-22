%
% check_leg -- quick look at a test leg
%
% main test parameters
%   band    - 'LW', 'MW', or 'SW'
%   wlaser  - metrology laser half-wavelength
%   mfile   - mat file, output from the MIT reader
%   sdir    - sweep direction, 0 or 1
%   ifov    - choose a FOV for figure 1
%   ifrq    - frequency index for figure 2
%
% derived from spec_test1
%

% paths and libs
addpath /asl/packages/ccast/source
addpath /asl/packages/ccast/motmsc/time
addpath ../source

% select a band
band = upper(input('band (e.g., LW) > ', 's'));

% select a test leg
tleg = upper(input('test leg (e.g., FT2) > ', 's'));
mfile = fullfile('./', tleg);
load(mfile);

% harvest directory
% harvest = 'harvest_mn';
  harvest = 'harvest_pfh';

% get wlaser from eng and neon
opt2 = struct;
opt2.neonWL = 703.44765;  % Larrabee's value
[wlaser, wtime] = metlaser(d1.packet.NeonCal, opt2);

% get instrument params
opt1 = struct; 
opt1.user_res = 'hires';
opt1.inst_res = 'hires4';
[inst, user] = inst_params(band, wlaser, opt1);

% choose a sweep direction
sdir = 0;

fprintf(1, 'eng neon=%.5f assigned neon=%.5f, wlaser=%.5f\n', ... 
  d1.packet.NeonCal.NeonGasWavelength, opt2.neonWL, wlaser);

% break out the igm data
[igm_es, time_es, igm_sp, time_sp, igm_it, time_it] = ...
   igm_breakout(band, d1, sdir);

% translate to count spectra
spec_es = igm2spec(igm_es, inst);
spec_sp = igm2spec(igm_sp, inst);
spec_it = igm2spec(igm_it, inst);

% get obs times in matlab format
dnum_es = iet2dnum(time_es(5,:));
dtime_es = datetime(dnum_es, 'ConvertFrom', 'datenum');

dnum_sp = iet2dnum(time_sp(5,:));
dtime_sp = datetime(dnum_sp, 'ConvertFrom', 'datenum');

dnum_it = iet2dnum(time_it(5,:));
dtime_it = datetime(dnum_it, 'ConvertFrom', 'datenum');

% test start and end times
t1 = dtime_es(1);
t2 = dtime_es(end);

% get the associated ccs data
fmt = '../%s/ccs_data_%02d_%02d';
d2 = load(sprintf(fmt, harvest, t1.Month, t1.Day));

% show all FOVs at one frequency
figure(1); clf
set(gcf, 'DefaultAxesColorOrder', fovcolors);
ifrq = floor(inst.npts/2);
vseq = squeeze(spec_es(ifrq, :, :));
[m, nobs] = size(vseq);
plot(dtime_es, abs(vseq), '.')
xlim([t1, t2])
title(sprintf('test %s, all FOVs at %.2f cm-1', tleg, inst.freq(ifrq)))
legend(fovnames,  'location', 'best')
xlabel('time')
ylabel('count')
grid on; zoom on

% ES time span cache
ind_file = sprintf('%s_ind.mat', tleg);
if exist(ind_file) == 2 

  % use exsiting time spans
  d3 = load(ind_file);
  t1 = d3.t1;
  t2 = d3.t2;
  fprintf(1, 't1 = %s\n', t1)
  fprintf(1, 't2 = %s\n', t2)
  input('continue with cached times > ')
  xlim([t1, t2])

else
  % chose a test subset
  tx = input('t1 (hh:mm:ss) > ', 's');
  [~,~,~, t1.Hour, t1.Minute, t1.Second] = datevec(tx);
  xlim([t1, t2])

  tx = input('t2 (hh:mm:ss) > ', 's');
  [~,~,~, t2.Hour, t2.Minute, t2.Second] = datevec(tx);
  xlim([t1, t2])

  save(ind_file, 't1', 't2');
end

% show the subset intervals
j1 = find(dtime_es >= t1, 1);
j2 = find(dtime_es >= t2, 1);
if isempty(j2), j2 = nobs; end
fprintf('%s index = %d:%d\n', tleg, j1, j2)

% show ccs test parameters
figure(2); clf
subplot(3,1,1)
plot(d2.htbb_temp_a_date, d2.htbb_temp_a_val, ...
     d2.htbb_temp_b_date, d2.htbb_temp_b_val, 'linewidth', 2)
xlim([t1, t2])
% ylim([310, 350]);
title('HTBB Temperatures')
% legend('A', 'B', 'location', 'southwest')
  legend('A', 'B', 'location', 'northeast')
ylabel('degrees (K)')
grid on

subplot(3,1,2)
plot(d2.inficon_press_date, d2.inficon_press_val, 'linewidth', 2)
xlim([t1, t2])
% ylim([0, 110]);
title('gas cell pressure')
ylabel('Torr')
grid on

subplot(3,1,3)
plot(d2.gas_cell_temp_date, d2.gas_cell_temp_val)
xlim([t1, t2])
% ylim([14.6, 15.4]);
title('gas cell temperature')
ylabel('degrees (C)')
xlabel('time')
grid on

return

% show all obs for one FOV
figure(3);
ifov = 5;
plot(inst.freq, squeeze(abs(spec_es(:, ifov, :))), 'b');
title(sprintf('test %s FOV %d all obs', tleg, ifov))
xlabel('wavenumber')
ylabel('count')
grid on; zoom on

% truncate t1 and t2 to spanning minutes, for plots
% t1.Second = 0;
% if t2.Second ~= 0
%   t2.Second = 0;
%   t2.Minute = t2.Minute + 1;
% end

