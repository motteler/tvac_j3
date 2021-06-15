%
% met laser residual summary
% load fit_run from each test
%

d1 = load('06-01_pfh_s1_CO/fit_run');
d2 = load('06-01_pfh_s1_CH4/fit_run');
d3 = load('06-02_pfh_s1_CO2/fit_run');
d4 = load('06-06_pfh_s2_CO2/fit_run');

fprintf('6-1 s1 d0 CO  wlaser=%.5f neon=%.5f\n', d1.wlaser, d1.asg_neon);
fprintf('6-1 s1 d0 CH4 wlaser=%.5f neon=%.5f\n', d2.wlaser, d2.asg_neon);
fprintf('6-2 s1 d0 CO2 wlaser=%.5f neon=%.5f\n', d3.wlaser, d3.asg_neon);
fprintf('6-6 s2 d0 CO2 wlaser=%.5f neon=%.5f\n', d4.wlaser, d4.asg_neon);
fprintf('\n\n')

fprintf('                        ')
fprintf('metrology laser absolute residuals by FOV\n')
fprintf('   Test      ');
fprintf('%7.0f', 1:9); fprintf('\n');

fprintf('6-1 s1 d0 CO  '); 
fprintf('%7.2f', d1.wmin); fprintf('\n');

fprintf('6-1 s1 d0 CH4 ');
fprintf('%7.2f', d2.wmin); fprintf('\n');

fprintf('6-2 s1 d0 CO2 ');
fprintf('%7.2f', d3.wmin); fprintf('\n');

fprintf('6-6 s2 d0 CO2 ');
fprintf('%7.2f', d4.wmin); fprintf('\n');

fprintf('\n\n')
fprintf('                        ')
fprintf('metrology laser relative residuals by FOV\n')
fprintf('   Test      ');
fprintf('%7.0f', 1:9); fprintf('\n');

fprintf('6-1 s1 d0 CO  '); 
fprintf('%7.2f', d1.wmin-d1.wmin(5)); fprintf('\n');

fprintf('6-1 s1 d0 CH4 ');
fprintf('%7.2f', d2.wmin-d2.wmin(5)); fprintf('\n');

fprintf('6-2 s1 d0 CO2 ');
fprintf('%7.2f', d3.wmin-d3.wmin(5)); fprintf('\n');

fprintf('6-6 s2 d0 CO2 ');
fprintf('%7.2f', d4.wmin-d4.wmin(5)); fprintf('\n');

