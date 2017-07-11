clear global;
clear variables;
load('/Users/sietzehouwink/Documents/bachelor-project/experiments_random_graphs/random_matrix.mat')

nr_samples_match_probability = 20;
solver = @(digraph_) unrestricted_edge_bipartite_solver(digraph_, Inf, cplexoptimset);

% nr_nodes = 7;
% min_match_probability = 0.1155;
% max_match_probability = 0.4103;
% nr_nodes = 12;
% min_match_probability = 0.08276;
% max_match_probability = 0.2138;
nr_nodes = 17;
min_match_probability = 0.05;
max_match_probability = 0.181;

% DONOR MEASUREMENTS
% nr_nodes = 100;
% min_match_probability = 0;
% max_match_probability = 0.05;

samples_match_probability = linspace(min_match_probability, max_match_probability, nr_samples_match_probability);
exchange_values = NaN(nr_samples_match_probability,1);
for index_match_probability = 1:nr_samples_match_probability
    match_probability = samples_match_probability(index_match_probability);
    adjacency_matrix = random_matrix(1:nr_nodes, 1:nr_nodes) <= match_probability;
    digraph_ = digraph(adjacency_matrix, 'OmitSelfLoops');
    digraph_.Edges.Weight = repelem(1, numedges(digraph_), 1);
    digraph_.Nodes.AgentType = repelem({'trader'}, numnodes(digraph_), 1);

    [~, exchange_value, ~, ~] = solver(digraph_);
    exchange_values(index_match_probability) = exchange_value;
end

figure;
plot(samples_match_probability, exchange_values / nr_nodes);
