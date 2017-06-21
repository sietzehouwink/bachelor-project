clear global;
clear variables;
rng('shuffle');
format long g

target_fraction = 0.95;

nr_measurements = 5;


% solver = @(digraph_) unrestricted_edge_bipartite_solver(digraph_, Inf, cplexoptimset);
% min_nr_nodes = 1;
% max_nr_nodes = 60;
% nr_samples_nr_nodes = 30;

% solver = @(digraph_) restricted_cycle_chain_solver(digraph_, 2, 0, Inf, Inf, cplexoptimset);
% min_nr_nodes = 1;
% max_nr_nodes = 600;
% nr_samples_nr_nodes = 30;

% solver = @(digraph_) restricted_cycle_chain_solver(digraph_, 3, 0, Inf, Inf, cplexoptimset);
% min_nr_nodes = 1;
% max_nr_nodes = 130;
% nr_samples_nr_nodes = 30;

samples_nr_nodes = round(linspace(min_nr_nodes, max_nr_nodes, nr_samples_nr_nodes));

min_match_probability = 0.05;
max_match_probability = 1;
nr_samples_match_probability = 30;
samples_match_probability = linspace(max_match_probability, min_match_probability, nr_samples_match_probability);

visited_nr_nodes = [];
visited_match_probability = [];

index_nr_nodes = 1;
index_match_probability = 1;
while index_nr_nodes <= nr_samples_nr_nodes && index_match_probability <= nr_samples_match_probability
    nr_nodes = samples_nr_nodes(index_nr_nodes);
    match_probability = samples_match_probability(index_match_probability);
    
    min_exchange_value = Inf;
    for index_measurement = 1:nr_measurements
        digraph_ = digraph(rand(nr_nodes) <= match_probability, 'OmitSelfLoops');
        digraph_.Edges.Weight = repelem(1,numedges(digraph_),1);
        digraph_.Nodes.AgentType = repelem({'trader'},numnodes(digraph_),1);
        
        [~, exchange_value, ~, ~] = solver(digraph_);
        
        if exchange_value < min_exchange_value
            min_exchange_value = exchange_value;
        end
    end
    
    visited_nr_nodes(end+1) = nr_nodes;
    visited_match_probability(end+1) = match_probability;
    
    fraction = min_exchange_value / nr_nodes;
    if fraction >= target_fraction
        index_match_probability = index_match_probability + 1;
    else
        index_nr_nodes = index_nr_nodes + 1;
    end   
end

figure;
hold on;
plot(visited_nr_nodes, visited_match_probability);
xlim([0 Inf]);
ylim([0 1]);
