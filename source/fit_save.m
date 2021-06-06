%
% fit save -- run after fit_run to save key run parameters
%

% Neon values
eng_neon = d1.packet.NeonCal.NeonGasWavelength;
asg_neon = opt2.neonWL;

% gas file and weight
abswt = opt.abswt;
afile = opt.afile;

% fitting parameters
qv1 = opt.qv1;
qv2 = opt.qv2;

% wlaser residuals
[tmin, imin] = min(drms);
wppm = 1e6* (waxis - wlaser) ./ wlaser;
wmin = wppm(imin);

save fit_run band wlaser waxis drms fmsc eng_neon asg_neon ...
  abswt afile qv1 qv2 wmin sdir

