clear global;
clear variables;
load('/Users/sietzehouwink/Documents/bachelor-project/experiments_random_graphs/random_matrix.mat')

nr_traders = 1000;
match_probability = 0.00125;
solver = @(digraph_) unrestricted_edge_bipartite_solver(digraph_, Inf, cplexoptimset);

min_nr_donors = 0;
max_nr_donors = 1500;
nr_samples_nr_donors = 10;
samples_nr_donors = round(linspace(min_nr_donors, max_nr_donors, nr_samples_nr_donors));

exchange_values = NaN(nr_samples_nr_donors,1);
for index_nr_donors = 1:nr_samples_nr_donors
    nr_donors = samples_nr_donors(index_nr_donors);
    
    adjacency_matrix = random_matrix(1:nr_traders+nr_donors,1:nr_traders+nr_donors) <= match_probability;
    adjacency_matrix(:,nr_traders+1:end) = 0;
    digraph_ = digraph(adjacency_matrix, 'OmitSelfLoops');
    digraph_.Edges.Weight = repelem(1,numedges(digraph_),1);
    digraph_.Nodes.AgentType = [repelem({'trader'},nr_traders,1); repelem({'donor'},nr_donors,1)];
    
    [~, exchange_value, ~, ~] = solver(digraph_);
    exchange_values(index_nr_donors) = exchange_value;
end

figure;
plot(samples_nr_donors, exchange_values);
