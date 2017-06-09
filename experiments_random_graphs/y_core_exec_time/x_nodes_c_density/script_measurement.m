clear global;
clear variables;

mean_target_time = 1;
std_target_time = 0.02;
timeout = 1.5;

% UNRESTRICTED EDGE BIPARTITE
% solver = @(digraph_) unrestricted_edge_bipartite_solver(digraph_, timeout, cplexoptimset);

% UNRESTRICTED EDGE DIGRAPH
% solver = @(digraph_) unrestricted_edge_digraph_solver(digraph_, timeout, cplexoptimset);

% UNRESTRICTED CYCLE CHAIN DIGRAPH
% solver = @(digraph_) unrestricted_cycle_chain_solver(digraph_, timeout, timeout, cplexoptimset);

% RESTRICTED CYCLE CHAIN DIGRAPH - CYCLE 2
% solver = @(digraph_) restricted_cycle_chain_solver(digraph_, 2, Inf, timeout, timeout, cplexoptimset);

% RESTRICTED CYCLE CHAIN DIGRAPH - CYCLE 3
solver = @(digraph_) restricted_cycle_chain_solver(digraph_, 3, Inf, timeout, timeout, cplexoptimset);

min_density = 0.01;
max_density = 1;
nr_samples_density = 4;
samples_density = round(logspace(log10(min_density), log10(max_density), nr_samples_density), 3);
nr_samples_nr_nodes = 10;
nr_measurements = 10;


figure;
hold on;
xlabel('Number of nodes');
ylabel('Core execution time (s)');
for density = samples_density  
    evaluator = @(samples_nr_nodes, samples_nr_edges) evaluate_core_exec_times_generated(samples_nr_nodes, samples_nr_edges, nr_measurements, solver);
    max_nr_nodes = get_match_target_time(density, evaluator, mean_target_time, std_target_time);
    
    samples_nr_nodes = round(linspace(0, max_nr_nodes, nr_samples_nr_nodes));
    samples_nr_edges = round(density * samples_nr_nodes.*(samples_nr_nodes-1));   
    [~, ~, timed_outs, mean_core_exec_times, std_core_exec_times] = evaluator(samples_nr_nodes, samples_nr_edges);
    
    plot_results(['Density ' num2str(density)], samples_nr_nodes, mean_core_exec_times, std_core_exec_times, timed_outs); 
end
legend('show', 'Location', 'best');
ylim([0 inf]);

function [nr_nodes] = get_match_target_time(density, evaluator, mean_target_time, std_target_time)
    max_nr_nodes = get_upper_bound(density, evaluator, mean_target_time);
    nr_nodes = binary_search(density, max_nr_nodes/2, max_nr_nodes, evaluator, mean_target_time, std_target_time);
end

function [max_nr_nodes] = get_upper_bound(density, evaluator, mean_target_time)
    max_nr_nodes = 1;
    while true
        nr_edges = round(density * max_nr_nodes*(max_nr_nodes-1));
        [~, ~, timed_out, mean_core_exec_time, ~] = evaluator(max_nr_nodes, nr_edges);
        if timed_out || mean_core_exec_time > mean_target_time
            break;
        end
        max_nr_nodes = max_nr_nodes * 2;
    end 
end

function [mid_nr_nodes] = binary_search(density, min_nr_nodes, max_nr_nodes, evaluator, mean_target_time, std_target_time)
    while min_nr_nodes <= max_nr_nodes
        mid_nr_nodes = floor((min_nr_nodes+max_nr_nodes)/2);
        
        nr_edges = round(density * mid_nr_nodes*(mid_nr_nodes-1));
        [~, ~, timed_out, mean_core_exec_time, ~] = evaluator(mid_nr_nodes, nr_edges);
        
        if timed_out || mean_core_exec_time > mean_target_time + std_target_time
            max_nr_nodes = mid_nr_nodes-1;
        elseif mean_core_exec_time < mean_target_time - std_target_time
            min_nr_nodes = mid_nr_nodes+1;
        else
            break
        end
    end
end