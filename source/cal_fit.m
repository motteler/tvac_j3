%
% NAME
%   cal_fit - find wlaser deltas to match obs and calc
%
% SYNOPSIS
%   function [dr, fmsc] = cal_fit(band, waxis, igm, opt);
%
% INPUTS
%   band      - 'LW', 'MW', or 'SW'
%   waxis     - metrology laser search grid, m x 1
%   igm       - interferogram struct (see below)
%   opt       - all the remaining run parameters
%
% igm fields
%   et1, et2, ft1, ft2: igm structs from Dan's reader
%   et1_ix, et2_ix, ft1_ix, ft2_ix: ES subset indices
%
% OUTPUTS
%   dr        - rms(obs-calc), m x 9
%   fmsc      - selected internal variables
%

function [dr, fmsc] = cal_fit(band, waxis, igm, opts)

% initialize arrays
k = length(waxis);
dr = zeros(k, 9);       % rms(obs-calc) by FOV and wlaser step
dmin = ones(1,9)*1e6;   % residual from best fit, for each FOV

% gas cell calcs
gc = opts.gc;
abswt = opts.abswt;

% save the best fit info by FOV
wfov = zeros(9,1);  % best fit wlaser 
wa = zeros(9,1);
wb = zeros(9,1);
freq3M = {}; 
tcal3M = {}; 
tobs4M = {}; 

% --------------------------------
% search loop on wlaser increments
% --------------------------------

for wi = 1 : length(waxis)

  % wtmp is a temporary search value for met laser.  obs and calc
  % in the loop, including inst params and the frequency grids, are
  % scaled to wtmp
  wtmp = waxis(wi);
  [inst, user] = inst_params(band, wtmp, opts);

  % calculate obs and calc at wlaser = wtmp
  [tobs, vobs] = cal_tran(band, wtmp, igm, opts);
  [tcal, vcal] = kc2inst(inst, user, exp(-gc.absc * abswt), gc.fr);

  if ~isclose(vobs, vcal, 4), error('frequency grid mismatch'), end

  % stick with the user grid
  jx = user.v1 <= inst.freq & inst.freq <= user.v2;

  % work at a finer frequency grid
  [tobs2, freq2] = finterp2(tobs(jx,:), inst.freq(jx,:), 20);
  [tcal2, freq2] = finterp2(tcal(jx,:), inst.freq(jx,:), 20);

  % use fitting subset [qv1, qv2] for obs - calc
  iq = find(opts.qv1 <= freq2 & freq2 <= opts.qv2);
  freq3 = freq2(iq);
  tobs3 = tobs2(iq, :);
  tcal3 = tcal2(iq);

  % initialize for regression fit and summary stats
  [m,n] = size(tobs3);
  tobs4 = zeros(m,n);
  drms = zeros(9,1);
  wa1 = zeros(1,9);
  wb1 = zeros(1,9);

  % loop on FOVs, fit observed to calculated transmittance
  for fi = 1 : 9

    % solve [tobs3(:,fi), ones(m,1)] * X2 = tcal3 for X2
    X2 = [tobs3(:,fi), ones(m,1)] \ tcal3;
    wa1(fi) = X2(1); 
    wb1(fi) = X2(2);

    % tobs4 is the corrected transmittances
    tobs4(:,fi) = wa1(fi) * tobs3(:,fi) + wb1(fi);

    % drms is corrected obs minus calc
    drms(fi) = rms(tobs4(:,fi) - tcal3);
  end

  % save rms(obs-calc) for all FOVs at this met laser step
  dr(wi,:) = drms;

  % loop on FOVs, update values associated with min residuals
  for fi = 1 : 9;

    % update dmin for this FOV, if dr(wi,fi) is smaller
    if dr(wi,fi) < dmin(fi)
      dmin(fi) = dr(wi,fi);

      % save fitted minima
      freq3M{fi} = freq3;
      tcal3M{fi} = tcal3;
      tobs4M{fi} = tobs4(:,fi);

      wfov(fi) = waxis(wi);
      wa(fi) = wa1(fi);
      wb(fi) = wb1(fi);
    end
  end
  fprintf(1, '.');
end
fprintf(1, '\n');

% return selected values
fmsc = struct;
fmsc.wa = wa;       % "a" weights, for each FOV
fmsc.wb = wb;       % "b" weights, for each FOV
fmsc.dmin = dmin;   % best fit residual
fmsc.wfov = wfov;   % best fit wlaser

fmsc.freq3M = freq3M;  % freq at minima
fmsc.tcal3M = tcal3M;  % calc at minima
fmsc.tobs4M = tobs4M;  % corrected obs at minima

