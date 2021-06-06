
clear all

addpath /asl/packages/ccast/source

% set opts.neonWL to override value from eng

opts = struct;
opts.neonWL = 703.44765;

% path to reader data
tdir = '.';

flist = dir(fullfile(tdir, '*T*.mat'));

for i = 1 : length(flist)

  fprintf(1, 'reading %s\n', flist(i).name);

  pfile = fullfile(tdir, flist(i).name);
  load(pfile);

  if d1.packet.read_four_min_packet
    [wlaser, wtime] = metlaser(d1.packet.NeonCal, opts);
  end

  fprintf(1, 'wlaser %f, %s\n', wlaser, datestr(wtime))
end

