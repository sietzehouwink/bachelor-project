clear global;
clear variables;
rng('shuffle');
format long g

nr_measurements = 10;

% target_value = 0.95;
% solver = @(digraph_) unrestricted_edge_bipartite_solver(digraph_, Inf, cplexoptimset);
% min_nr_nodes = 1;
% max_nr_nodes = 90;
% nr_samples_nr_nodes = 30;
% target_value = 0.05;
% solver = @(digraph_) unrestricted_edge_bipartite_solver(digraph_, Inf, cplexoptimset);
% min_nr_nodes = 1;
% max_nr_nodes = 30;
% nr_samples_nr_nodes = 30;

% target_value = 0.95;
% solver = @(digraph_) restricted_cycle_chain_solver(digraph_, 2, 0, Inf, Inf, cplexoptimset);
% min_nr_nodes = 1;
% max_nr_nodes = 1500;
% nr_samples_nr_nodes = 30;


% target_value = 0.95;
% solver = @(digraph_) restricted_cycle_chain_solver(digraph_, 3, 0, Inf, Inf, cplexoptimset);
% min_nr_nodes = 1;
% max_nr_nodes = 250;
% nr_samples_nr_nodes = 30;

% target_value = 0.95;
% solver = @(digraph_) restricted_cycle_chain_solver(digraph_, 4, 0, Inf, Inf, cplexoptimset);
% min_nr_nodes = 1;
% max_nr_nodes = 140;
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
    
    exchange_values = NaN(nr_measurements,1);
    for index_measurement = 1:nr_measurements
        digraph_ = digraph(rand(nr_nodes) <= match_probability, 'OmitSelfLoops');
        digraph_.Edges.Weight = repelem(1,numedges(digraph_),1);
        digraph_.Nodes.AgentType = repelem({'trader'},numnodes(digraph_),1);
        
        [~, exchange_value, ~, ~] = solver(digraph_);
        
        exchange_values(index_measurement) = exchange_value;
    end
    median_exchange_value = median(exchange_values);
    
    visited_nr_nodes(end+1) = nr_nodes;
    visited_match_probability(end+1) = match_probability;
    
    if median_exchange_value / nr_nodes > target_value
        index_match_probability = index_match_probability + 1;
    else
        index_nr_nodes = index_nr_nodes + 1;
    end   
end

figure;
plot(visited_nr_nodes, visited_match_probability);
xlim([0 Inf]);
ylim([0 1]);
