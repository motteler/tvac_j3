%
% NAME
%   fit_tran - find wlaser deltas to match obs and calc
%
% SYNOPSIS
%   function [dr, fmsc] = fit_tran(band, waxis, igm, opt);
%
% INPUTS
%   band      - 'LW', 'MW', or 'SW'
%   waxis     - metrology laser search grid, m x 1
%   igm       - ET1, ET2, FT1, FT2 interferograms
%   opt       - all the remaining run parameters
%
% IGM FIELDS
%   ET1       - nchan x 9 x nobs IGM for cell empty, BB at T1
%   ET2       - nchan x 9 x nobs IGM for cell empty, BB at T2
%   FT1       - nchan x 9 x nobs IGM for cell full, BB at T1
%   FT2       - nchan x 9 x nobs IGM for cell full, BB at T2
%
% OPT FIELDS
%   resmode   - resolution mode, for inst_params
%   sfile     - SRF matrices for the current wlaser range
%   afile     - tabulated absorptions, at 0.0025 cm-1 grid
%   abswt     - scale factor for tabulated absorptions
%   qv1, qv2  - fitting interval
%
% OUTPUTS
%   dr        - rms(obs-calc), m x 9
%   fmsc      - selected internal variables
%
% FMSC FIELDS
%   wa     - "a" weights, 9 x 1
%   wb     - "b" weights, 9 x 1
%   dmin   - best wlaser fit residuals, 9 x 1
%   wfov   - best wlaser fit wlaser values, 9 x 1
%   vobs4  - interpolated frequency grid, k x 1
%   tcal4  - interpolated calc for best-fit wlaser, k x 9
%   tobs4  - interpolated obs for best-fit wlaser, k x 9
%   tobs5  - interpolated regression corrected obs, k x 9
%
% DISCUSSION
%   the structs igm and opt are passed on to cmp_tran
%
%   drms (from cmp_tran) is actually rms(a*obs+b - calc), where a
%   and b are found by regression independently for each FOV, and
%   are returned in the dmsc struct
%
%   fit_tran is derived from the old script version by that name.
%   The search was moved to this function and the rest to wrapper
%   scripts such as fit_run.
%
% LIBS
%   ccast/source
%   ccast/motmsc/utils
%   airs_decon/test
%
% AUTHOR
%   HM, 1 Mar 2014
%

function [dr, fmsc] = fit_tran(band, waxis, igm, opt)

% initialize arrays
k = length(waxis);
dr = zeros(k, 9);       % rms(obs-calc) for all wlaser and FOVs
dmin = ones(1,9)*1e6;   % incremental min for FOV selection 

% save the best fit for each FOV
vobs1 = {}; tobs1 = {}; tcal1 = {};
wfov = zeros(9,1);  % best fit wlaser 
wa = zeros(9,1);
wb = zeros(9,1);

% --------------------------------
% search loop on wlaser increments
% --------------------------------

for wi = 1 : length(waxis)

  wtmp = waxis(wi);
  [drms, dmsc] = cmp_tran(band, wtmp, igm, opt);

  % save rms(obs-calc) for all FOVS at this wlaser
  dr(wi,:) = drms;

  % loop on FOVs for this wavelength
  for fi = 1 : 9;

    % update dmin for this FOV, if dr(wi,fi) is smaller
    if dr(wi,fi) < dmin(fi)
      dmin(fi) = dr(wi,fi);

      vobs1{fi} = dmsc.freq;
      tobs1{fi} = dmsc.tobs(:,fi);
      tcal1{fi} = dmsc.tcal(:);

      wfov(fi) = waxis(wi);
      wa(fi) = dmsc.wa(fi);
      wb(fi) = dmsc.wb(fi);
    end
  end
  fprintf(1, '.');
end
fprintf(1, '\n');

% -------------------------------------------
% interpolate search results to a common grid
% -------------------------------------------

% specify dv for a common frequency grid for analysis and plots
dv2 = 0.02;  
vmin = 0;
vmax = 1e4;
tobs2 = {}; tcal2 = {}; vobs2 = {};
tobs3 = {}; tcal3 = {}; vobs3 = {};

% loop on FOVS interpolate data to a common dv
for fi = 1:9

   % interpolate obs and calc to a dv2 grid
   [r1, v1] = finterp(tobs1{fi}, vobs1{fi}, dv2);
   [r2, v2] = finterp(tcal1{fi}, vobs1{fi}, dv2);
   r1 = real(r1); r2 = real(r2);

   % save interpolated FOVs in a cell arrays
   tobs2{fi} = r1;
   tcal2{fi} = r2;
   vobs2{fi} = v2;

   % greatest lower freq bound among all FOVs
   if vmin < v2(1)
      vmin = v2(1);
   end

   % least upper freq bound among all FOVs
   j = length(v2);
   if v2(j) < vmax
      vmax = v2(j);
   end
end

% loop on FOVS, trim grids to a single common grid
for fi = 1:9

   % truncate to common frequency grid
   ix = find (vmin <= vobs2{fi} & vobs2{fi} <= vmax);
   tobs3{fi} = tobs2{fi}(ix);
   tcal3{fi} = tcal2{fi}(ix);
   vobs3{fi} = vobs2{fi}(ix);
end

% verify that all FOVS have the same frequency scale
for i = 1:9
  for j = i+1:9
    if ~isequal(vobs3{i}, vobs3{j})
       fprintf(1, 'ERROR: fov %d and %d frequency scales differ\n', i, j);
    end
  end
end

% stuff cell arrays back into arrays
vobs4 = vobs3{1}';
nn = length(vobs4);
tobs4 = zeros(nn, 9);
tcal4 = zeros(nn, 9);
for fi = 1:9
  tobs4(:, fi) = tobs3{fi};
  tcal4(:, fi) = tcal3{fi};
end

% corrected obs
tobs5 = tobs4 .* (ones(nn, 1) * wa') + ones(nn, 1) * wb';

% return selected values
fmsc = struct;
fmsc.wa = wa;          % "a" weights, for each FOV
fmsc.wb = wb;          % "b" weights, for each FOV
fmsc.dmin = dmin;      % best fit residual
fmsc.wfov = wfov;      % best fit wlaser
fmsc.vobs4 = vobs4;    % interpolated frequency grid
fmsc.tcal4 = tcal4;    % interpolated calc (for all FOVs)
fmsc.tobs4 = tobs4;    % interpolated obs for best-fit wlaser
fmsc.tobs5 = tobs5;    % interpolated regression corrected obs

