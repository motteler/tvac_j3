%
% NAME
%   fit_info -- print fit_tran residuals and weights
%
% SYNOPSIS
%   function fit_info(band, wlaser, waxis, drms, fmsc);
%
% INPUTS
%   band   - 'LW', 'MW', or 'SW'
%   wlaser - met laser wavelength
%   waxis  - metrology laser search grid, m x 1
%   drms   - rms(obs-calc), m x 9
%   fmsc   - fit_tran internals
%

function fit_info(band, wlaser, waxis, drms, fmsc)

% unpack fmsc
wa = fmsc.wa;        % "a" weights, 9 x 1
wb = fmsc.wb;        % "b" weights, 9 x 1
dmin = fmsc.dmin;    % best wlaser fit residuals, 9 x 1
wfov = fmsc.wfov;    % best wlaser fit wlaser values, 9 x 1

% fitting residuals
fprintf(1, 'residuals x 1000\n')
wprint(dmin * 1000)

% wlaser residuals
[tmin, imin] = min(drms);
wppm = 1e6* (waxis - wlaser) ./ wlaser;
wmin = wppm(imin);
fprintf(1, 'met laser residuals, ppm\n')
wprint(wmin)

fprintf(1, 'met laser relative, ppm\n')
wprint(wmin - wmin(5))

% regression weights
fprintf(1, ' FOV   "a"       "b"     dmin     wmin      wfov\n')
for fi = 1 : 9
  fprintf(1, '%3d   %5.3f   %7.4f   %6.4f  %7.2f   %7.4f \n', ...
          fi, wa(fi), wb(fi), dmin(fi), wmin(fi), wfov(fi));
end

