%
% NAME
%   cal_tran - transmittance from calibrated radiances
%
% SYNOPSIS
%   function [tobs, vobs] = cal_tran(band, wlaser, igm, opts)
%
% INPUTS
%   band     - 'LW', 'MW', or 'SW'
%   wlaser   - metrology laser half-wavelength
%   igm      - interferogram struct (see below)
%   opts     - options for cal_rad
%
% igm fields
%   et1, et2, ft1, ft2: igm structs from reader
%   et1_ix, et2_ix, ft1_ix, ft2_ix: ES indices
%

function [tobs, vobs] = cal_tran(band, wlaser, igm, opts)

[r_et1, vobs] = cal_rad(band, wlaser, igm.et1, igm.et1_ix, opts);
[r_et2, vobs] = cal_rad(band, wlaser, igm.et2, igm.et2_ix, opts);
[r_ft1, vobs] = cal_rad(band, wlaser, igm.ft1, igm.ft1_ix, opts);
[r_ft2, vobs] = cal_rad(band, wlaser, igm.ft2, igm.ft2_ix, opts);

tobs = real((r_ft1 - r_ft2) ./ (r_et1 - r_et2));

[inst, user] = inst_params(band, wlaser, opts);
tobs = bandpass(inst.freq, tobs, user.v1, user.v2, user.vr);

