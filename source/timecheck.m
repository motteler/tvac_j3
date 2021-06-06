
load 01-12_pfh_s1_CO2/FT1.mat

tminES = min(d1.packet.LWES.time(:,5));
tmaxES = max(d1.packet.LWES.time(:,5));
tminSP = min(d1.packet.LWSP.time(:,5));
tmaxSP = max(d1.packet.LWSP.time(:,5));
tminIT = min(d1.packet.LWIT.time(:,5));
tmaxIT = max(d1.packet.LWIT.time(:,5));

tmin = min([tminES, tminSP, tminIT]);
tmax = max([tmaxES, tmaxSP, tmaxIT]);

tES = (d1.packet.LWES.time(:,5) - tmin) * 1e3;
tIT = (d1.packet.LWIT.time(:,5) - tmin) * 1e3;
tSP = (d1.packet.LWSP.time(:,5) - tmin) * 1e3;

nES = length(tES);
nIT = length(tIT);
nSP = length(tSP);

plot(tES, 1:nES, tIT, 1:nIT, tSP, 1:nSP)

legend('ES', 'SP', 'IT')
