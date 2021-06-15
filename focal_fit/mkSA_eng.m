%
% get j3 SA matrices from eng
%

addpath /home/motteler/cris/ccast/source

% get reference focal plane for deltas
d2 = load('j3_eng_302');
fp2 = fp_from_eng(d2.eng);

% inst_params options
opts = struct;
opts.user_res = 'hires';
opts.inst_res = 'hires4';
opts.wrap = 'psinc n';

% nominal wlaser value
wlaser = 773.1307;

% build the SA inverse matrices
opts.frad = fp2(1).frad;
opts.foax = fp2(1).foax;
sfile = 'SAinv_j3_eng_LW.mat';
mkSAinv('LW', wlaser, sfile, opts);

opts.frad = fp2(2).frad;
opts.foax = fp2(2).foax;
sfile = 'SAinv_j3_eng_MW.mat';
mkSAinv('MW', wlaser, sfile, opts);

opts.frad = fp2(3).frad;
opts.foax = fp2(3).foax;
sfile = 'SAinv_j3_eng_SW.mat';
mkSAinv('SW', wlaser, sfile, opts);

