
% take hh:mm:ss string to fractional hours
%      12345678

function h = hhmmss_to_hour(hhmmss)

hh = str2num(hhmmss(1:2));
mm = str2num(hhmmss(4:5));
ss = str2num(hhmmss(7:8));

h = hh + mm/60 + ss/3600;

