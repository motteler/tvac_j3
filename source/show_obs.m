
f = input('obs file > ', 's');
load(f)

tES = d1.packet.LWES.time(:, 5); 
tIT = d1.packet.LWIT.time(:, 5); 
tSP = d1.packet.LWSP.time(:, 5); 

oES = ones(length(tES), 1);
oIT = ones(length(tIT), 1);
oSP = ones(length(tSP), 1);

plot(tES, oES, '+r', tSP, oSP, '+g', tIT, oIT, '+b')
legend('ES', 'SP', 'IT')

