clear global;
clear variables;
rng('shuffle');

target_time = 1;
timeout_solver = 8;
timeout_other = 8;

nr_measurements = 4%16;

nr_samples_nr_nodes = 1%8;
min_nr_nodes = 0;
max_nr_nodes = 500;
samples_nr_nodes = round(linspace(min_nr_nodes, max_nr_nodes, nr_samples_nr_nodes));


% solver = @(digraph_) unrestricted_edge_bipartite_solver(digraph_, timeout_solver, cplexoptimset);
% match_probability = 0.135;

% solver = @(digraph_) unrestricted_edge_digraph_solver(digraph_, timeout_solver, cplexoptimset);
% match_probability = 0.058;

solver = @(digraph_) restricted_edge_paths_solver(digraph_, 2, timeout_other, timeout_solver, cplexoptimset);
match_probability = 0.045;
% solver = @(digraph_) restricted_edge_paths_solver(digraph_, 3, timeout_other, timeout_solver, cplexoptimset);
% nr_nodes = 15;

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

mean_core_exec_times = NaN(nr_samples_nr_nodes,1);
std_core_exec_times = NaN(nr_samples_nr_nodes,1);
for index_nr_nodes = 1:nr_samples_nr_nodes
    core_exec_times = NaN(nr_measurements,1);
    for index_measurement = 1:nr_measurements
        digraph_ = digraph(rand(samples_nr_nodes(index_nr_nodes)) <= match_probability, 'OmitSelfLoops');
        digraph_.Edges.Weight = repelem(1,numedges(digraph_),1);
        digraph_.Nodes.AgentType = repelem({'trader'},numnodes(digraph_),1);
        [~, exchange_value, timed_out, core_exec_time] = solver(digraph_);
        if timed_out
            break;
        end
        core_exec_times(index_measurement) = core_exec_time;
    end
    mean_core_exec_times(index_nr_nodes) = mean(core_exec_times);
    std_core_exec_times(index_nr_nodes) = std(core_exec_times);
end

errorbar(samples_nr_nodes, mean_core_exec_times, std_core_exec_times);
