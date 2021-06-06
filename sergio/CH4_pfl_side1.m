
load /home/sergio/MATLABCODE/CrIS_gascell_Jan2020/gascell_3_gid_6_params_cris_may28_2021_ip.mat

% Sergio's UMBC LBL
fr = outwave(:);
absc = out_array(:);
save umbc_CH4_50p00_Torr_16p90_C.mat fr absc 

% LBLRTM
fr = xw(:);
absc = xdlblrtm(:);
save lblr_CH4_50p00_Torr_16p90_C.mat fr absc

% Sergio's LM V1-4
fr = lmdat5pt(1,:)';
absc = lmdat5pt(4,:)';
save lmv1_CH4_50p00_Torr_16p90_C.mat fr absc

