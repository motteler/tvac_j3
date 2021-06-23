%
% NAME
%   igm_breakout - break out ES, SP, and IT looks from a test leg
%
% SYNOPSIS
%   [igm_es, time_es, igm_sp, time_sp, igm_it, time_it] = ...
%       igm_breakout(band, d1, sdir)
%
% INPUTS
%   band     - 'LW', 'MW', or 'SW'
%   tleg     - MIT reader struct, 1 test leg
%   sdir     - sweep direction (0 or 1)
%
% OUTPUTS
%   igm_es   - ES interferograms
%   time_es  - ES times, IET
%   igm_sp   - SP interferograms
%   time_sp  - SP times, IET
%   igm_it   - IT interferograms
%   time_it  - IT times, IET
%

function [igm_es, time_es, igm_sp, time_sp, igm_it, time_it] = ...
   igm_breakout(band, d1, sdir)

switch upper(band)
  case 'LW'
    time_es = d1.packet.LWES.time;
    igm_es = d1.idata.LWES + 1i * d1.qdata.LWES;
    ix_es = find(d1.sweep_dir.LWES(5, :) == sdir);

    time_sp = d1.packet.LWSP.time;
    igm_sp = d1.idata.LWSP + 1i * d1.qdata.LWSP;
    ix_sp = find(d1.sweep_dir.LWSP(5, :) == sdir);

    time_it = d1.packet.LWIT.time;
    igm_it = d1.idata.LWIT + 1i * d1.qdata.LWIT;
    ix_it = find(d1.sweep_dir.LWIT(5, :) == sdir);

  case 'MW'
    time_es = d1.packet.MWES.time;
    igm_es = d1.idata.MWES + 1i * d1.qdata.MWES;
    ix_es = find(d1.sweep_dir.MWES(5, :) == sdir);

    time_sp = d1.packet.MWSP.time;
    igm_sp = d1.idata.MWSP + 1i * d1.qdata.MWSP;
    ix_sp = find(d1.sweep_dir.MWSP(5, :) == sdir);

    time_it = d1.packet.MWIT.time;
    igm_it = d1.idata.MWIT + 1i * d1.qdata.MWIT;
    ix_it = find(d1.sweep_dir.MWIT(5, :) == sdir);

  case 'SW'
    time_es = d1.packet.SWES.time;
    igm_es = d1.idata.SWES + 1i * d1.qdata.SWES;
    ix_es = find(d1.sweep_dir.SWES(5, :) == sdir);

    time_sp = d1.packet.SWSP.time;
    igm_sp = d1.idata.SWSP + 1i * d1.qdata.SWSP;
    ix_sp = find(d1.sweep_dir.SWSP(5, :) == sdir);

    time_it = d1.packet.SWIT.time;
    igm_it = d1.idata.SWIT + 1i * d1.qdata.SWIT;
    ix_it = find(d1.sweep_dir.SWIT(5, :) == sdir);
  otherwise
    error(['bad band value ', band])
end

% sweep direction subset
igm_es = igm_es(:, :, ix_es);
time_es = time_es';
time_es = time_es(:, ix_es);

igm_sp = igm_sp(:, :, ix_sp);
time_sp = time_sp';
time_sp = time_sp(:, ix_sp);

igm_it = igm_it(:, :, ix_it);
time_it = time_it';
time_it = time_it(:, ix_it);

% milliseconds per day
msd = 8.64e7;   
time_es = time_es .* msd;
time_sp = time_sp .* msd;
time_it = time_it .* msd;

% checkRDR returns ccast UTC ms since 1958
time_es = tai2iet(utc2tai(time_es/1000));
time_sp = tai2iet(utc2tai(time_sp/1000));
time_it = tai2iet(utc2tai(time_it/1000));

% Geo = RDR - dtRDR
dtRDR = 183e3;

% subtract dtRDR 
time_es = time_es - dtRDR;
time_sp = time_sp - dtRDR;
time_it = time_it - dtRDR;

