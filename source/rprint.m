%
% pretty print met laser residuals
%

function rprint(r)

fprintf('  %8.2f %8.2f %8.2f         7   4   1\n', r([7,4,1]))
fprintf('  %8.2f %8.2f %8.2f         8   5   2\n', r([8,5,2]))
fprintf('  %8.2f %8.2f %8.2f         9   6   3\n', r([9,6,3]))

