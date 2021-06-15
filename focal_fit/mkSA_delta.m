%
% get SA matrices for a focal plane with shifted off-axis angles
%

addpath /home/motteler/cris/ccast/source

% get reference focal plane for deltas
d2 = load('npp_eng_v39');
fp1 = fp_from_eng(d2.eng);

fp2 = fp1;
for b = 1 : 3
  fp2(b).foax = fp1(b).foax * 1.05;
end

% inst_params options
opts = struct;
opts.cvers = 'npp';
opts.user_res = 'hires';
opts.inst_res = 'hires3';
opts.wrap = 'psinc n';

% nominal wlaser value
wlaser = 773.1307;

% build the SA inverse matrices
opts.frad = fp2(1).frad;
opts.foax = fp2(1).foax;
sfile = 'SAinv_NPPda_LW.mat';
mkSAinv('LW', wlaser, sfile, opts);

opts.frad = fp2(2).frad;
opts.foax = fp2(2).foax;
sfile = 'SAinv_NPPda_MW.mat';
mkSAinv('MW', wlaser, sfile, opts);

opts.frad = fp2(3).frad;
opts.foax = fp2(3).foax;
sfile = 'SAinv_NPPda_SW.mat';
mkSAinv('SW', wlaser, sfile, opts);
