%
%  read_ccs - read and tabulate selected CCS fields
%
% Loop on a day's worth of TVAC CCS files and tabulate HTBB temps,
% gas cell temp, and gas cell pressure.  Data for the day is saved
% in a file ccs_data_mm_dd.mat where mm is 2-digit month and dd is
% 2-digit day.  Month is set below in the test directory format, as
% both a number and name.  Does a summary plot after the tabulation.
% 

clear all

% get the date
% ms = '05_May';
  ms = '06_Jun';
ds = input('2 digit day-of-month > ', 's');

% local TVAC data home
% p1 = '/asl/isilon/cris/tvac_j3/extracted/hourly_archives/J3';
p1 = '/asl/xfs3/GRAVITE/j3cris/readonly/extracted/hourly_archives/J3';

% matlab globbing for test data
p2 = 'TEM_Collection/CCS/Collection/2021/%s/%s/*/*.ccs';
p2 = sprintf(p2, ms, ds);

% matlab style directory records
p3 = fullfile(p1, p2);
tdir = dir(p3);
nfile = length(tdir);

% initialize saved values
htbb_temp_a_val = [];
htbb_temp_b_val = [];
inficon_press_val = [];
gas_cell_temp_val = [];

htbb_temp_a_time = [];
htbb_temp_b_time = [];
inficon_press_time = [];
gas_cell_temp_time = [];

% loop on css files
for i = 1 : nfile

  d1 = importdata(fullfile(tdir(i).folder, tdir(i).name));
  [nrow, ~] = size(d1.data);
  for j = 1 : nrow

    % get tlm_id as a string
    tlm_id = d1.textdata(j+1,1);
    tlm_id = tlm_id{1};

    switch tlm_id
      case '200008'
        htbb_temp_a_val = [htbb_temp_a_val, d1.data(j,2)];
        htbb_temp_a_time = [htbb_temp_a_time, datenum(d1.textdata(j+1,2))];
      case '200009'
        htbb_temp_b_val = [htbb_temp_b_val, d1.data(j,2)];
        htbb_temp_b_time = [htbb_temp_b_time, datenum(d1.textdata(j+1,2))];
      case '200018'
        inficon_press_val = [inficon_press_val, d1.data(j,2)];
        inficon_press_time = [inficon_press_time, datenum(d1.textdata(j+1,2))];
      case '200022'
        gas_cell_temp_val = [gas_cell_temp_val, d1.data(j,2)];
        gas_cell_temp_time = [gas_cell_temp_time, datenum(d1.textdata(j+1,2))];
    end
  end
end

clear d1

% convert to datetime
htbb_temp_a_date = datetime(htbb_temp_a_time, 'ConvertFrom', 'datenum');
htbb_temp_b_date = datetime(htbb_temp_b_time, 'ConvertFrom', 'datenum');
inficon_press_date = datetime(inficon_press_time, 'ConvertFrom', 'datenum');
gas_cell_temp_date = datetime(gas_cell_temp_time, 'ConvertFrom', 'datenum');

mn = str2num(ms(1:2));   % integer month
dn = str2num(ds);        % integer day of month

figure(1); clf
subplot(3,1,1)
plot(htbb_temp_a_date, htbb_temp_a_val, ...
     htbb_temp_b_date, htbb_temp_b_val, 'linewidth', 2)
xlim([datetime(2021, mn, dn), datetime(2021, mn, dn+1)])
ylim([310, 370]);
title('HTBB Temperatures')
% legend('A', 'B', 'location', 'southwest')
  legend('A', 'B', 'location', 'northeast')
ylabel('degrees (K)')
grid on

subplot(3,1,2)
plot(inficon_press_date, inficon_press_val, 'linewidth', 2)
xlim([datetime(2021, mn, dn), datetime(2021, mn, dn+1)])
ylim([0, 110]);
title('gas cell pressure')
ylabel('Torr')
grid on

subplot(3,1,3)
plot(gas_cell_temp_date, gas_cell_temp_val)
xlim([datetime(2021, mn, dn), datetime(2021, mn, dn+1)])
% ylim([14.6, 15.4]);
title('gas cell temperature')
ylabel('degrees (C)')
xlabel('time')
grid on

dstr = [ms(1:2), '_', ds];
save(sprintf('ccs_data_%s', dstr));
saveas(gcf, sprintf('css_summary_%s', dstr), 'fig')

