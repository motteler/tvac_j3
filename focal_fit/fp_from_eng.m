%
% fp_from_eng - focal plane from the eng packet
%
% SYNOPSIS
%   fp = fp_from_eng(eng)
%
% INPUT
%   eng  - eng packet from the MIT reader
%
% OUTPUT
%   fp  - 1 x 3 struct array with fields
%     rad   - 9 x 1 FOV radii, urad
%     pos   - 9 x 2 FOV x-y position, urad
%     dxy   - 2 x 1 focal plane x-y shift, urad
%     foax  - 9 x 1 FOV off-axis angles, rad
%     frad  - 9 x 1 FOV radii, rad
%
% note: rad, pos, and dxy are in microradians, while foax and frad
% are in radians.
%

function fp = fp_from_eng(eng)

% vals from eng, in microradians
rad = NaN(9, 3);    % FOV radii
pos = NaN(9, 2, 3); % FOV x-y positions
dxy = NaN(2, 3);    % x-y common offset

% values for the ILS calc, in radians
frad = NaN(9, 3);   % FOV radii, radians
foax = NaN(9, 3);   % FOV off axis angles, radians

for b = 1 : 3
  for i = 1 : 9
    rad(i,b) = eng.ILS_Param.Band(b).FOV(i).FOV_Size / 2;
    pos(i,1,b) = eng.ILS_Param.Band(b).FOV(i).CrTrkOffset;
    pos(i,2,b) = eng.ILS_Param.Band(b).FOV(i).InTrkOffset;
  end
  dxy(1,b) = eng.ILS_Param.Band(b).FOV5_CrTrkMisalignment;
  dxy(2,b) = eng.ILS_Param.Band(b).FOV5_InTrkMisalignment;

  foax(:,b) = sqrt((pos(:,1,b) + dxy(1,b)).^2 + (pos(:,2,b) + dxy(2,b)).^2);
end

% copy values to fp
fp = struct([]);
for i = 1 : 3
  fp(i).rad = rad(:,i);
  fp(i).pos = pos(:,:,i);
  fp(i).dxy = dxy(:,i);
  fp(i).frad = rad(:,i) * 1e-6;
  fp(i).foax = foax(:,i) * 1e-6;
end

