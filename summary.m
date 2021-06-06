%
% met laser residual summary
% load fit_run from each test
%

d1 = load('05-19_pfl_s2_CO2/fit_run');
d2 = load('05-19_pfl_s2_CO2_d1/fit_run');
d3 = load('05-25_pfl_s1_CO2/fit_run');
d4 = load('05-25_pfl_s1_CO2_d1/fit_run');
d5 = load('05-26_pfl_s1_CH4/fit_run');
d6 = load('05-27_pfl_s1_CO/fit_run');

fprintf('5-19 s2 d0 CO2 wlaser=%.5f neon=%.5f\n', d1.wlaser, d1.asg_neon);
fprintf('5-25 s1 d0 CO2 wlaser=%.5f neon=%.5f\n', d3.wlaser, d3.asg_neon);
fprintf('5-26 s1 d0 CH4 wlaser=%.5f neon=%.5f\n', d5.wlaser, d5.asg_neon);
fprintf('5-27 s1 d0 CO  wlaser=%.5f neon=%.5f\n', d6.wlaser, d6.asg_neon);
fprintf('\n\n')

fprintf('                        ')
fprintf('metrology laser absolute residuals by FOV\n')
fprintf('   Test      ');
fprintf('%7.0f', 1:9); fprintf('\n');

fprintf('5-19 s2 d0 CO2 ');
fprintf('%7.2f', d1.wmin); fprintf('\n');

fprintf('5-19 s2 d1 CO2 ');
fprintf('%7.2f', d2.wmin); fprintf('\n');

fprintf('5-25 s1 d0 CO2 ');
fprintf('%7.2f', d3.wmin); fprintf('\n');

fprintf('5-25 s1 d1 CO2 ');
fprintf('%7.2f', d4.wmin); fprintf('\n');

fprintf('5-26 s1 d0 CH4 ');
fprintf('%7.2f', d5.wmin); fprintf('\n');

fprintf('5-27 s1 d0 CO  '); 
fprintf('%7.2f', d6.wmin); fprintf('\n');

fprintf('\n\n')
fprintf('                        ')
fprintf('metrology laser relative residuals by FOV\n')
fprintf('   Test      ');
fprintf('%7.0f', 1:9); fprintf('\n');

fprintf('5-19 s2 d0 CO2 ');
fprintf('%7.2f', d1.wmin-d1.wmin(5)); fprintf('\n');

fprintf('5-19 s2 d1 CO2 ');
fprintf('%7.2f', d2.wmin-d2.wmin(5)); fprintf('\n');

fprintf('5-25 s1 d0 CO2 ');
fprintf('%7.2f', d3.wmin-d3.wmin(5)); fprintf('\n');

fprintf('5-25 s1 d1 CO2 ');
fprintf('%7.2f', d4.wmin-d4.wmin(5)); fprintf('\n');

fprintf('5-26 s1 d0 CH4 ');
fprintf('%7.2f', d5.wmin-d5.wmin(5)); fprintf('\n');

fprintf('5-27 s1 d0 CO  '); 
fprintf('%7.2f', d6.wmin-d6.wmin(5)); fprintf('\n');

fprintf('\n\n')
d1.wmin - d2.wmin
d3.wmin - d4.wmin

