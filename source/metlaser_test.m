%
% sanity check for met laser calcs
%

neon1 = 703.44765;   % Larrabee's value
neon2 = 705.17500;   % gave good MN side 2 fit

% get an eng packet from this test
load('FT2');  

% neon grid
ngrid = -2 : 0.0001 : 2;
naxis = neon2 + ngrid;

% wlaser grid
ng = length(ngrid);
waxis = zeros(1, ng);

% call metlaser for each grid point
for i = 1 : ng
  opt2 = struct;
  opt2.neonWL = naxis(i);
  waxis(i) = metlaser(d1.packet.NeonCal, opt2);
end

% see what we've got (looks pretty linear)
figure(1); clf
plot(naxis, waxis)
title('metrology laser as a function of neon')
xlabel('neon wavelength (nm)')
ylabel('met laser wavelength (nm)')
grid on; zoom on

