%
% spec_test1 -- quick look at gas cell count spectra
%
% main test parameters
%   band    - 'LW', 'MW', or 'SW'
%   wlaser  - metrology laser half-wavelength
%   mfile   - mat file, output from the MIT reader
%   sdir    - sweep direction, 0 or 1
%   ifov    - choose a FOV for figure 1
%   ifrq    - frequency index for figure 2
%
% HM, 15 Jan 2014
%
% updated to get met laser from neon
%

% paths and libs
addpath /asl/packages/ccast/source
addpath /asl/packages/ccast/motmsc/utils
addpath /asl/packages/ccast/motmsc/time
addpath ../source

% select a test leg
tleg = upper(input('test leg (e.g., FT2) > ', 's'));
mfile = fullfile('./', tleg);
load(mfile);

% get wlaser from eng and neon
opt2 = struct;
opt2.neonWL = 703.44765;  % Larrabee's value
[wlaser, wtime] = metlaser(d1.packet.NeonCal, opt2);

fprintf(1, 'eng neon=%.5f assigned neon=%.5f, wlaser=%.5f\n', ... 
  d1.packet.NeonCal.NeonGasWavelength, opt2.neonWL, wlaser);

% get instrument params
band = 'LW';
opt1 = struct; 
opt1.user_res = 'hires';
opt1.inst_res = 'hires4';
[inst, user] = inst_params(band, wlaser, opt1);

% choose a sweep direction
sdir = 0;

% read the interferograms
[igm, igm_time] = read_igm(band, mfile, sdir);

% convert igm_time to a fractional hour axis
dnum_axis = iet2dnum(igm_time(5,:));
dvec_tmp = datevec(dnum_axis(1));
dnum_base = datenum(dvec_tmp(1:3));
hour_axis = (dnum_axis - dnum_base) * 24;

% default is full test time span
t1 = hour_axis(1); 
t2 = hour_axis(end);

% specify time spans by test leg
[~, tleg, ~] = fileparts(mfile);
switch tleg
  case 'ET1', t1 = 22.353;  t2 = 22.389;
  case 'ET2', t1 =  0.495;  t2 =  0.531;
  case 'FT1', t1 =  3.555;  t2 =  3.592;
  case 'FT2', t1 =  1.091;  t2 =  1.124;
end

% take time subsets
n1 = length(hour_axis);
jx = interp1(hour_axis, 1:n1, [t1,t2], 'nearest');
ix = jx(1) : jx(2);
igm = igm(:, :, ix); 
hour_axis = hour_axis(ix);
fprintf(1, '%s subset %d:%d\n', tleg, jx(1), jx(2));

% translate to count spectra
spec = igm2spec(igm, inst);
spec = abs(spec);

% show all obs for one FOV
figure(1);
ifov = 5;
plot(inst.freq, squeeze(spec(:, ifov, :)), 'b');
title(sprintf('test %s FOV %d all obs', tleg, ifov))
xlabel('wavenumber')
ylabel('count')
grid on; zoom on

% show all FOVs at one frequency
figure(2);
set(gcf, 'DefaultAxesColorOrder', fovcolors);
ifrq = floor(inst.npts/2);
vseq = squeeze(spec(ifrq, :, :));
[m, nobs] = size(vseq);
plot(hour_axis, vseq, '.')
xlim([t1, t2])
title(sprintf('test %s, all FOVs at %.2f cm-1', tleg, inst.freq(ifrq)))
legend(fovnames,  'location', 'south')
xlabel('hour')
ylabel('count')
grid on; zoom on

