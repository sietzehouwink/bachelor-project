clear global;
clear variables;

figure;
hold on;
xlabel('number of agents', 'FontSize', 14);
ylabel('match probability', 'FontSize', 14);

% title({'Unrestricted', 'Contour Fraction of Maximum Exchange Value = 0.95'}, 'FontSize', 14)
% load('/Users/sietzehouwink/Documents/bachelor-project/experiments_random_graphs/y_exchange_value/contour/measurements/unrestricted_0,95.mat')
% plot([0, visited_nr_nodes], [1,visited_match_probability], 'k');

% title({'Restricted', 'Contour Fraction of Maximum Exchange Value = 0.95', 'Max Cycle Length = 2'}, 'FontSize', 14)
% load('/Users/sietzehouwink/Documents/bachelor-project/experiments_random_graphs/y_exchange_value/contour/measurements/restricted_2_0,95.mat')
% plot([0, visited_nr_nodes], [1,visited_match_probability], 'k');

% title({'Restricted', 'Contour Fraction of Maximum Exchange Value = 0.95', 'Max Cycle Length = 3'}, 'FontSize', 14)
% load('/Users/sietzehouwink/Documents/bachelor-project/experiments_random_graphs/y_exchange_value/contour/measurements/restricted_3_0,95.mat')
% plot([0, visited_nr_nodes], [1,visited_match_probability], 'k');

% title({'Restricted', 'Contour Fraction of Maximum Exchange Value = 0.95', 'Max Cycle Length = 4'}, 'FontSize', 14)
% load('/Users/sietzehouwink/Documents/bachelor-project/experiments_random_graphs/y_exchange_value/contour/measurements/restricted_4_0,95.mat')
% plot([0, visited_nr_nodes], [1,visited_match_probability], 'k');

% title({'Unrestricted', 'Domains'}, 'FontSize', 14)
% load('/Users/sietzehouwink/Documents/bachelor-project/experiments_random_graphs/y_exchange_value/contour/measurements/unrestricted_0,05.mat')
% plot([0, visited_nr_nodes], [1,visited_match_probability], ':k');
% load('/Users/sietzehouwink/Documents/bachelor-project/experiments_random_graphs/y_exchange_value/contour/measurements/unrestricted_0,95.mat')
% plot([0, visited_nr_nodes], [1,visited_match_probability], ':k');
% plot([7 7], [0.1155 0.413],'-ok');
% plot([12 12], [0.08276 0.2138],'-ok');
% plot([17 17], [0.05 0.181],'-ok');
% plot([17 75], [0.05 0.05], '-xk');
% plot([7 19], [0.16465 0.16465], '-xk');
% plot([5 10], [0.2793 0.2793], '-xk');

set(gca, 'Color', 'None')
set(gcf, 'Position', [100, 100, 1024, 512])
ax = gca;
ax.LineWidth = 3;
ax.XColor = [28 173 228] / 255;
ax.YColor = [28 173 228] / 255;
ax.FontSize = 32;
% load('/Users/sietzehouwink/Documents/bachelor-project/experiments_random_graphs/y_exchange_value/contour/measurements/unrestricted_0,95.mat')
% plot([0, visited_nr_nodes], [1,visited_match_probability], 'k', 'Color', [28 173 228] / 255, 'LineWidth', 3);
load('/Users/sietzehouwink/Documents/bachelor-project/experiments_random_graphs/y_exchange_value/contour/measurements/restricted_2_0,95.mat')
plot([0, visited_nr_nodes], [1,visited_match_probability], 'k', 'Color', [28 173 228] / 255, 'LineWidth', 3);


xlim([0 Inf]);
ylim([0 1.1]);
