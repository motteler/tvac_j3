
% dbase = date num base, t1 plot start, t2 plot end

function plot_leg(d1, dbase, t1, t2, tstr, fnum)

% view as hours from start of the day
htbb_temp_a_hour = (d1.htbb_temp_a_time - dbase) * 24;
htbb_temp_b_hour = (d1.htbb_temp_b_time - dbase) * 24;
inficon_press_hour = (d1.inficon_press_time - dbase) * 24;
gas_cell_temp_hour = (d1.gas_cell_temp_time - dbase) * 24; 

figure(fnum); clf
subplot(3,1,1)
plot(htbb_temp_a_hour, d1.htbb_temp_a_val, ...
     htbb_temp_b_hour, d1.htbb_temp_b_val, 'linewidth', 2)
xlim([t1,t2])
title([tstr, ' HTBB Temperatures'])
legend('A', 'B', 'location', 'east')
ylabel('degrees (K)')
grid on; zoom on

subplot(3,1,2)
plot(inficon_press_hour, d1.inficon_press_val, 'linewidth', 2)
xlim([t1,t2])
title('gas cell pressure')
ylabel('Torr')
grid on; zoom on

subplot(3,1,3)
plot(gas_cell_temp_hour, d1.gas_cell_temp_val)
xlim([t1,t2])
title('gas cell temperature')
ylabel('degrees (C)')
xlabel('hour')
grid on; zoom on

