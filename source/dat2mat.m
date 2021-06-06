
more off
clear all
addpath ../inst_data
addpath /home/motteler/cris/ccast/readers/MITreader380a

if exist('btrim_cache.mat') ~= 2, error('no btrim_cache file'), end

d1 = read_cris_ccsds('ET2.dat', 'btrim_cache.mat');
save ET2 d1 '-v7.3'
clear all

d1 = read_cris_ccsds('ET1.dat', 'btrim_cache.mat');
save ET1 d1 '-v7.3'
clear all

d1 = read_cris_ccsds('FT2.dat', 'btrim_cache.mat');
save FT2 d1 '-v7.3'
clear all

d1 = read_cris_ccsds('FT1.dat', 'btrim_cache.mat');
save FT1 d1 '-v7.3'
clear all

