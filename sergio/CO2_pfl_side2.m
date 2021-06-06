
load /home/sergio/MATLABCODE/CrIS_gascell_Jan2020/gascell_1_gid_2_params_cris_may28_2021_iptest_LM.mat

% Sergio's UMBC LBL
fr = outwave(:);
absc = out_array(:);
save umbc_CO2_49p67_Torr_16p60_C.mat fr absc 

% LBLRTM
fr = xw(:);
absc = xdlblrtm(:);
save lblr_CO2_49p67_Torr_16p60_C.mat fr absc 

% Sergio's LM V1-4
fr = lmdat5pt(1,:)';
absc = lmdat5pt(4,:)';
save lmv1_CO2_49p67_Torr_16p60_C.mat fr absc 

