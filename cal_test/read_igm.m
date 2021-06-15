
function [igm_es, time_es, igm_sp, time_sp, igm_it, time_it] = ...
   read_igm(band, mfile, sdir)

load(mfile);

switch upper(band)
  case 'LW'

  case 'MW'

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

% time fix from checkRDR and nextRDR
% Dan's reader returns fractional days since 1958

% milliseconds per day
msd = 8.64e7;   
time_es = time_es .* msd;
time_sp = time_sp .* msd;
time_it = time_it .* msd;

% this assumes checkRDR returns the old ccast UTC ms since 1958
time_es = tai2iet(utc2tai(time_es/1000));
time_sp = tai2iet(utc2tai(time_sp/1000));
time_it = tai2iet(utc2tai(time_it/1000));

% Geo = RDR - dtRDR
dtRDR = 183e3;

% subtract dtRDR 
time_es = time_es - dtRDR;
time_sp = time_sp - dtRDR;
time_it = time_it - dtRDR;

