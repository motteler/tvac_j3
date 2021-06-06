
load /home/sergio/MATLABCODE/CrIS_gascell_Jan2020/gascell_4_gid_5_params_cris_may28_2021_ip.mat

% Sergio's UMBC LBL
fr = outwave(:);
absc = out_array(:);
save umbc_CO_44p53_Torr_16p60_C.mat fr absc 

% LBLRTM
fr = xw(:);
absc = xdlblrtm(:);
save lblr_CO_44p53_Torr_16p60_C.mat fr absc 

% Sergio's LM V1-4
fr = lmdat5pt(1,:)';
absc = lmdat5pt(4,:)';
save lmv1_CO_44p53_Torr_16p60_C.mat fr absc 

