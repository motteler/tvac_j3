%
% NAME
%   cmp_tran - compare observed and calculated transmittances
%
% SYNOPSIS
%   function [drms, dmsc] = cmp_tran(band, wlaser, igm, opt);
%
% INPUTS
%   band      - 'LW', 'MW', or 'SW'
%   wlaser    - metrology laser half-wavelength
%   igm       - ET1, ET2, FT1, FT2 interferograms
%   opt       - all the remaining run parameters
%
% IGM FIELDS
%   ET1       - IGM for cell empty, BB at T1
%   ET2       - IGM for cell empty, BB at T2
%   FT1       - IGM for cell full, BB at T1
%   FT2       - IGM for cell full, BB at T2
%
% OPT FIELDS
%   sfile     - SRF matrices for the current wlaser range
%   afile     - tabulated absorptions, at 0.0025 cm-1 grid
%   abswt     - scale factor for tabulated absorptions
%   qv1, qv2  - fitting interval
%
% OUTPUTS
%   drms      - rms(obs-calc) for each FOV
%   dmsc      - selected internal variables
%
% DISCUSSION
%   drms is actually rms(a*obs+b - calc), where a and b are found
%   by regression independently for each FOV, and are returned in 
%   the dmsc struct
%
%   cmp_tran is a total rewrite of the old FM2008/cmp_tran6, and is
%   mainly derived from the demo script spec_test2.  There is no params
%   file or defaults--all params are passed in or set by inst_params.
% 
% LIBS
%   ccast/source
%   ccast/motmsc/utils
%   airs_decon/test
%
% AUTHOR
%   HM, 20 Jan 2014
%

function [drms, dmsc] = cmp_tran(band, wlaser, igm, opt);

% get instrument params
[inst, user] = inst_params(band, wlaser, opt);

% get the SA inverse matrix
Sinv = getSAinv(inst, opt);

% get the count spectra
count_ET1 = igm2spec(igm.ET1, inst);
count_ET2 = igm2spec(igm.ET2, inst);
count_FT1 = igm2spec(igm.FT1, inst);
count_FT2 = igm2spec(igm.FT2, inst);

% take means of the obs
mean_ET1 = mean(count_ET1, 3);
mean_ET2 = mean(count_ET2, 3);
mean_FT1 = mean(count_FT1, 3);
mean_FT2 = mean(count_FT2, 3);

% get transmittances
tobs = real((mean_FT2 - mean_FT1) ./ (mean_ET2 - mean_ET1));
% Fdt = mean_FT2 - mean_FT1;
% Edt = mean_ET2 - mean_ET1;

% apply SA-1
tobs = bandpass(inst.freq, tobs, user.v1, user.v2, user.vr);
% Fdt = bandpass(inst.freq, Fdt, user.v1, user.v2, user.vr);
% Edt = bandpass(inst.freq, Edt, user.v1, user.v2, user.vr);
for i = 1 : 9
  tobs(:, i) = Sinv(:,:,i) * tobs(:, i);
  % Fdt(:, i) = Sinv(:,:,i) * Fdt(:, i);
  % Edt(:, i) = Sinv(:,:,i) * Edt(:, i);
end
% tobs = real(Fdt ./ Edt);
tobs = bandpass(inst.freq, tobs, user.v1, user.v2, user.vr);

% get calc values
d1 = load(opt.afile);
[tcal, vcal] = kc2inst(inst, user, exp(-d1.absc * opt.abswt), d1.fr);

% get FOV 5 values
% d1 = load('fov5.mat');
% optx = struct;
% optx.tol = 1e-7;
% [tcal, vcal] = finterp(d1.tobs(:, 5), d1.vobs, inst.dv, optx);
% [ix, jx] = seq_match(vcal, inst.freq);
% ttmp = zeros(inst.npts, 1);
% vtmp = inst.freq;
% ttmp(jx) = tcal;  
% vtmp(jx) = vcal'; 
% tcal = ttmp;
% vcal = vtmp; 

% check frequency grids
% isclose(inst.freq, vcal)

% work at a finer frequency grid
[tobs2, freq2] = finterp2(tobs, inst.freq, 20);
[tcal2, freq2] = finterp2(tcal, inst.freq, 20);

% use fitting subset [qv1, qv2] for obs - calc
iq = find(opt.qv1 <= freq2 & freq2 <= opt.qv2);
freq3 = freq2(iq);
tobs3 = tobs2(iq, :);
tcal3 = tcal2(iq);

% initialize for regression fit and summary stats
[m,n] = size(tobs3);
tobs4 = zeros(m,n);
drms = zeros(9,1);
dmax = zeros(9,1);
wa = zeros(1,9);
wb = zeros(1,9);

% loop on FOVs, fit observed to calculated transmittance
for fi = 1 : 9

  % solve [tobs3(:,fi), ones(m,1)] * X2 = tcal3 for X2
  X2 = [tobs3(:,fi), ones(m,1)] \ tcal3;
  wa(fi) = X2(1); 
  wb(fi) = X2(2);

  % tobs4 is the fully corrected transmittances
  tobs4(:,fi) = wa(fi) * tobs3(:,fi) + wb(fi);

  drms(fi) = rms(tobs4(:,fi) - tcal3);
  dmax(fi) = max(abs(tobs4(:,fi) - tcal3));

end

% return selected variables in dmsc
dmsc.dmax = dmax;
dmsc.freq = inst.freq;
dmsc.tobs = tobs;
dmsc.tcal = tcal;
dmsc.wa = wa;
dmsc.wb = wb;

