
function [igm, igm_time] = read_igm(band, mfile, sdir)

load(mfile);

switch upper(band)
  case 'LW'
    igm_time = d1.packet.LWES.time;
    igm = d1.idata.LWES + 1i * d1.qdata.LWES;
    ix = find(d1.sweep_dir.LWES(5, :) == sdir);
  case 'MW'
    igm_time = d1.packet.MWES.time;
    igm = d1.idata.MWES + 1i * d1.qdata.MWES;
    ix = find(d1.sweep_dir.MWES(5, :) == sdir);
  case 'SW'
    igm_time = d1.packet.SWES.time;
    igm = d1.idata.SWES + 1i * d1.qdata.SWES;
    ix = find(d1.sweep_dir.SWES(5, :) == sdir);
  otherwise
    error(['bad band value ', band])
end

igm = igm(:, :, ix);
igm_time = igm_time';
igm_time = igm_time(:, ix);

% time fix from checkRDR and nextRDR
% Dan's reader returns fractional days since 1958

% milliseconds per day
msd = 8.64e7;   
igm_time = igm_time .* msd;

% this assumes checkRDR returns the old ccast UTC ms since 1958
igm_time = tai2iet(utc2tai(igm_time/1000));

% Geo = RDR - dtRDR
dtRDR = 183e3;

% subtract dtRDR 
igm_time = igm_time - dtRDR;

