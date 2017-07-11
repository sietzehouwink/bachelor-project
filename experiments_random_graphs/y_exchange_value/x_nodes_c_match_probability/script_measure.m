clear global;
clear variables;
rng('shuffle');

nr_measurements = 10;
nr_samples_nr_nodes = 10;

solver = @(digraph_) unrestricted_edge_bipartite_solver(digraph_, Inf, cplexoptimset);
% match_probability = 0.05;
% min_nr_nodes = 17;
% max_nr_nodes = 75;
% match_probability = 0.16465;
% min_nr_nodes = 7;
% max_nr_nodes = 19;
% nr_samples_nr_nodes = 6;
% match_probability = 0.2793;
% min_nr_nodes = 5;
% max_nr_nodes = 10;


samples_nr_nodes = round(linspace(min_nr_nodes, max_nr_nodes, nr_samples_nr_nodes));
median_exchange_values = NaN(nr_samples_nr_nodes,1);
mad_exchange_values = NaN(nr_samples_nr_nodes,1);
for index_nr_nodes = 1:nr_samples_nr_nodes
    exchange_values = NaN(nr_measurements,1);
    for index_measurement = 1:nr_measurements
        digraph_ = digraph(rand(samples_nr_nodes(index_nr_nodes)) <= match_probability, 'OmitSelfLoops');
        digraph_.Edges.Weight = repelem(1,numedges(digraph_),1);
        digraph_.Nodes.AgentType = repelem({'trader'},numnodes(digraph_),1);
        [~, exchange_value, ~, ~] = solver(digraph_);
        exchange_values(index_measurement) = exchange_value;
    end
    median_exchange_values(index_nr_nodes) = median(exchange_values);
    mad_exchange_values(index_nr_nodes) = mad(exchange_values,1);
end

figure;
errorbar(samples_nr_nodes, median_exchange_values ./ samples_nr_nodes', mad_exchange_values ./ samples_nr_nodes');
