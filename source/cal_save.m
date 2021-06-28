%
% cal save -- run after cal_run to save key run parameters
%

% wlaser residuals
[tmin, imin] = min(drms);
wppm = 1e6* (waxis - wlaser) ./ wlaser;
wmin = wppm(imin);

save cal_run band wlaser waxis eng_neon drms wmin fmsc opts

