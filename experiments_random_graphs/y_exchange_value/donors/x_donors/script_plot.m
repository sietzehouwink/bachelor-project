clear global;
clear variables;

figure;
hold on;
xlabel('additional number of donors', 'FontSize', 14);
ylabel('exchange value', 'FontSize', 14);


title({'Unrestricted', 'Number of Traders = 1000', 'Match Probability = 0.00125'}, 'FontSize', 14);
load('/Users/sietzehouwink/Documents/bachelor-project/experiments_random_graphs/y_exchange_value/donors/x_donors/measurements/m0,00125.mat')


plot(samples_nr_donors, exchange_values, 'k');
