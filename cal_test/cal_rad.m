%
% NAME
%   cal_rad - calibrated radiances from TVAC packet stream
%
% SYNOPSIS
%   function [robs, vobs] = cal_rad(band, wlaser, tleg, eset, opts);
%
% INPUTS
%   band     - 'LW', 'MW', or 'SW'
%   wlaser   - metrology laser half-wavelength
%   tleg     - packet data, ET1, ET2, FT1, or FT2
%   eset     - desired subset of ES looks
%   opts     - any remaining run parameters
%

function [robs, vobs] = cal_rad(band, wlaser, tleg, eset, opts);

% default parameters
sdir = 0;       % sweep direction 0
verbose = 0;    % 0=quiet, 1=talky, 2=plots
sfile = '../inst_data/SAinv_j3_eng_SW';

% option to override defaults 
if nargin == 5
  if isfield(opts, 'verbose'), verbose = opts.verbose; end
  if isfield(opts, 'sdir'),    sdir    = opts.sdir; end
  if isfield(opts, 'sfile'),   sfile   = opts.sfile; end
end

% get instrument params
opt1 = struct; 
opt1.user_res = 'hires';
opt1.inst_res = 'hires4';
[inst, user] = inst_params(band, wlaser, opt1);

% sort out the igm data
[igm_es, time_es, igm_sp, time_sp, igm_it, time_it] = ...
   parse_igms(band, tleg, sdir);

% translate to count spectra
spec_es = igm2spec(igm_es, inst);
spec_sp = igm2spec(igm_sp, inst);
spec_it = igm2spec(igm_it, inst);

% take the ES subsets.
spec_es = spec_es(:, :, eset);
time_es = time_es(:, eset);

% take the ES, IT, and SP means
mean_es = mean(spec_es, 3);
mean_sp = mean(spec_sp, 3);
mean_it = mean(spec_it, 3);

% take the basic calibration ratio
robs = (mean_es - mean_sp) ./ (mean_it - mean_sp);
robs = bandpass(inst.freq, robs, user.v1, user.v2, user.vr);

% get the SA inverse matrix
opt1.SW_sfile = sfile;
Sinv = getSAinv(inst, opt1);

% apply the SA invers matrix
for i = 1 : 9
  robs(:, i) = Sinv(:,:,i) * robs(:, i);
end
robs = bandpass(inst.freq, robs, user.v1, user.v2, user.vr);

% get expected ICT radiance
nsci = ztail(tleg.data.sci.Temp.time);
ict_temps = ICT_countsToK(tleg.data.sci.Temp, tleg.packet.TempCoeffs, nsci);
tICT = mean([ict_temps.T_PRT1, ict_temps.T_PRT2]);
rICT = bt2rad(inst.freq, tICT);

% multiply by expected radiance
for i = 1 : 9
  robs(:, i) = rICT .* robs(:, i);
end

% get vobs from inst params
vobs = inst.freq;

