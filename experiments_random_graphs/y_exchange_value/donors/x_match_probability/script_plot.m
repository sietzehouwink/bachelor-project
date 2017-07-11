clear global;
clear variables;

figure;
hold on;
xlabel('match probability', 'FontSize', 14);
ylabel('exchange value', 'FontSize', 14);


title({'Unrestricted', 'Number of Traders = 1000'}, 'FontSize', 14);
load('/Users/sietzehouwink/Documents/bachelor-project/experiments_random_graphs/y_exchange_value/donors/x_match_probability/measurements/d50.mat')


hold on;
plot(samples_match_probability, exchange_values(:,1), '--k');
plot(samples_match_probability, exchange_values(:,end), '-.k');
plot(samples_match_probability, exchange_values(:,end) - exchange_values(:,1), 'k');
plot([0 0.005], [50 50], ':k');
legend({' 0  additional donors', '50 additional donors', 'difference'}, 'FontSize', 14, 'Location', 'best')
hold off;
