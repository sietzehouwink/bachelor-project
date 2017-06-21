clear global;
clear variables;
rng('shuffle');

nr_measurements = 10;
nr_samples_match_probability = 10;

solver = @(digraph_) unrestricted_edge_bipartite_solver(digraph_, Inf, cplexoptimset);
% nr_nodes = 450;
% min_match_probability = 0.2138;
% max_match_probability = 1;
% nr_nodes = 615;
% min_match_probability = 0.1155;
% max_match_probability = 0.3448;
nr_nodes = 779;
min_match_probability = 0.05;
max_match_probability = 0.181;

%solver = @(digraph_) restricted_cycle_chain_solver(digraph_, 2, 0, Inf, Inf, cplexoptimset);
% nr_nodes = 370;
% min_match_probability = 0.3448;
% max_match_probability = 1;
% nr_nodes = 934;
% min_match_probability = 0.1155;
% max_match_probability = 0.3776;
% nr_nodes = 1497;
% min_match_probability = 0.05;
% max_match_probability = 0.2138;

samples_match_probability = linspace(min_match_probability, max_match_probability, nr_samples_match_probability);
median_core_exec_times = NaN(nr_samples_match_probability,1);
mad_core_exec_times = NaN(nr_samples_match_probability,1);
for index_match_probability = 1:nr_samples_match_probability
    core_exec_times = NaN(nr_measurements,1);
    for index_measurement = 1:nr_measurements
        digraph_ = digraph(rand(nr_nodes) <= samples_match_probability(index_match_probability), 'OmitSelfLoops');
        digraph_.Edges.Weight = repelem(1,numedges(digraph_),1);
        digraph_.Nodes.AgentType = repelem({'trader'},numnodes(digraph_),1);
        [~, ~, ~, core_exec_time] = solver(digraph_);
        core_exec_times(index_measurement) = core_exec_time;
    end
    median_core_exec_times(index_match_probability) = median(core_exec_times);
    mad_core_exec_times(index_match_probability) = mad(core_exec_times,1);
end

figure;
errorbar(samples_match_probability, median_core_exec_times, mad_core_exec_times);
