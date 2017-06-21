clear global;
clear variables;
rng('shuffle');

target_time = 1;
timeout_solver = 8;
timeout_other = 8;

nr_measurements = 16;

nr_samples_match_probability = 8;
min_match_probability = 0;
max_match_probability = 1;
samples_match_probability = linspace(min_match_probability, max_match_probability, nr_samples_match_probability);


% solver = @(digraph_) unrestricted_edge_bipartite_solver(digraph_, timeout_solver, cplexoptimset);
% nr_nodes = 448;

% solver = @(digraph_) unrestricted_edge_digraph_solver(digraph_, timeout_solver, cplexoptimset);
% nr_nodes = 213;

% solver = @(digraph_) restricted_edge_paths_solver(digraph_, 2, timeout_other, timeout_solver, cplexoptimset);
% nr_nodes = 42;
% solver = @(digraph_) restricted_edge_paths_solver(digraph_, 3, timeout_other, timeout_solver, cplexoptimset);
% nr_nodes = 15;
% solver = @(digraph_) restricted_edge_paths_solver(digraph_, 4, timeout_other, timeout_solver, cplexoptimset);
% nr_nodes = 11;
% solver = @(digraph_) restricted_edge_paths_solver(digraph_, 5, timeout_other, timeout_solver, cplexoptimset);
% nr_nodes = 9;
% solver = @(digraph_) restricted_edge_paths_solver(digraph_, 6, timeout_other, timeout_solver, cplexoptimset);
% nr_nodes = 8;
% solver = @(digraph_) restricted_edge_paths_solver(digraph_, 7, timeout_other, timeout_solver, cplexoptimset);
% nr_nodes = 8;

% solver = @(digraph_) restricted_edge_cycles_chains_solver(digraph_, 2, 0, timeout_other, timeout_solver, cplexoptimset);
% nr_nodes = 8;
% solver = @(digraph_) restricted_edge_cycles_chains_solver(digraph_, 3, 0, timeout_other, timeout_solver, cplexoptimset);
% nr_nodes = 8;
% solver = @(digraph_) restricted_edge_cycles_chains_solver(digraph_, 4, 0, timeout_other, timeout_solver, cplexoptimset);
% nr_nodes = 8;
% solver = @(digraph_) restricted_edge_cycles_chains_solver(digraph_, 5, 0, timeout_other, timeout_solver, cplexoptimset);
% nr_nodes = 8;
% solver = @(digraph_) restricted_edge_cycles_chains_solver(digraph_, 6, 0, timeout_other, timeout_solver, cplexoptimset);
% nr_nodes = 8;
% solver = @(digraph_) restricted_edge_cycles_chains_solver(digraph_, 7, 0, timeout_other, timeout_solver, cplexoptimset);
% nr_nodes = 8;
% solver = @(digraph_) restricted_edge_cycles_chains_solver(digraph_, 8, 0, timeout_other, timeout_solver, cplexoptimset);
% nr_nodes = 9;

% solver = @(digraph_) restricted_cycle_chain_solver(digraph_, 2, 0, timeout_other, timeout_solver, cplexoptimset);
% nr_nodes = 372;
% solver = @(digraph_) restricted_cycle_chain_solver(digraph_, 3, 0, timeout_other, timeout_solver, cplexoptimset);
% nr_nodes = 44;
% solver = @(digraph_) restricted_cycle_chain_solver(digraph_, 4, 0, timeout_other, timeout_solver, cplexoptimset);
% nr_nodes = 31;
% solver = @(digraph_) restricted_cycle_chain_solver(digraph_, 5, 0, timeout_other, timeout_solver, cplexoptimset);
% nr_nodes = 18;
% solver = @(digraph_) restricted_cycle_chain_solver(digraph_, 6, 0, timeout_other, timeout_solver, cplexoptimset);
% nr_nodes = 13;
% solver = @(digraph_) restricted_cycle_chain_solver(digraph_, 7, 0, timeout_other, timeout_solver, cplexoptimset);
% nr_nodes = 11;
% solver = @(digraph_) restricted_cycle_chain_solver(digraph_, 8, 0, timeout_other, timeout_solver, cplexoptimset);
% nr_nodes = 10;
% solver = @(digraph_) restricted_cycle_chain_solver(digraph_, 9, 0, timeout_other, timeout_solver, cplexoptimset);
% nr_nodes = 9;

mean_core_exec_times = NaN(nr_samples_match_probability,1);
std_core_exec_times = NaN(nr_samples_match_probability,1);
for index_match_probability = 1:nr_samples_match_probability
    core_exec_times = NaN(nr_measurements,1);
    for index_measurement = 1:nr_measurements
        digraph_ = digraph(rand(nr_nodes) <= samples_match_probability(index_match_probability), 'OmitSelfLoops');
        digraph_.Edges.Weight = repelem(1,numedges(digraph_),1);
        digraph_.Nodes.AgentType = repelem({'trader'},nr_nodes,1);
        [~, exchange_value, timed_out, core_exec_time] = solver(digraph_);
        if timed_out
            break;
        end
        core_exec_times(index_measurement) = core_exec_time;
    end
    mean_core_exec_times(index_match_probability) = mean(core_exec_times);
    std_core_exec_times(index_match_probability) = std(core_exec_times);
end

errorbar(samples_match_probability, mean_core_exec_times, std_core_exec_times);
