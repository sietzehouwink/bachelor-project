clear global;
clear variables;
rng('shuffle');

nr_measurements = 10;
nr_samples_nr_nodes = 10;

% solver = @(digraph_) unrestricted_edge_bipartite_solver(digraph_, Inf, cplexoptimset);
% match_probability = 0.05;
% min_nr_nodes = 779;
% max_nr_nodes = 1893;
% match_probability = 0.525;
% min_nr_nodes = 297;
% max_nr_nodes = 557;
% match_probability = 1;
% min_nr_nodes = 224;
% max_nr_nodes = 450;

% solver = @(digraph_) restricted_cycle_chain_solver(digraph_, 2, 0, Inf, Inf, cplexoptimset);
% match_probability = 0.05;
% min_nr_nodes = 1497;
% max_nr_nodes = 4448;
% match_probability = 0.525;
% min_nr_nodes = 255;
% max_nr_nodes = 672;
% match_probability = 1;
% min_nr_nodes = 152;
% max_nr_nodes = 370;


samples_nr_nodes = round(linspace(min_nr_nodes, max_nr_nodes, nr_samples_nr_nodes));
median_core_exec_times = NaN(nr_samples_nr_nodes,1);
mad_core_exec_times = NaN(nr_samples_nr_nodes,1);
for index_nr_nodes = 1:nr_samples_nr_nodes
    core_exec_times = NaN(nr_measurements,1);
    for index_measurement = 1:nr_measurements
        digraph_ = digraph(rand(samples_nr_nodes(index_nr_nodes)) <= match_probability, 'OmitSelfLoops');
        digraph_.Edges.Weight = repelem(1,numedges(digraph_),1);
        digraph_.Nodes.AgentType = repelem({'trader'},numnodes(digraph_),1);
        [~, ~, ~, core_exec_time] = solver(digraph_);
        core_exec_times(index_measurement) = core_exec_time;
    end
    median_core_exec_times(index_nr_nodes) = median(core_exec_times);
    mad_core_exec_times(index_nr_nodes) = mad(core_exec_times,1);
end

figure;
errorbar(samples_nr_nodes, median_core_exec_times, mad_core_exec_times);
