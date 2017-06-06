clear global;
clear variables;

timeout = 5;
plot_y_core_exec_time = false;
plot_y_exchange_value = true;

% UNRESTRICTED EDGE BIPARTITE
optimoptions_ = optimoptions('intlinprog');
solver = @(digraph_) unrestricted_edge_bipartite_solver(digraph_, timeout, optimoptions_);

min_nr_nodes = 50;
max_nr_nodes = 400;
nr_samples_nr_nodes = 5;
samples_nr_nodes = round(logspace(log10(min_nr_nodes), log10(max_nr_nodes), nr_samples_nr_nodes));

min_density = 0;
max_density = 1;
nr_samples_density = 10;
samples_density = linspace(min_density, max_density, nr_samples_density);

nr_measurements = 10;

% FULL RANGE UNRESTRICTED EDGE DIGRAPH
% optimoptions_ = optimoptions('intlinprog');
% solver = @(digraph_) unrestricted_edge_digraph_solver(digraph_, timeout, optimoptions_);
% 
% min_nr_nodes = 50;
% max_nr_nodes = 400;
% nr_samples_nr_nodes = 5;
% samples_nr_nodes = round(logspace(log10(min_nr_nodes), log10(max_nr_nodes), nr_samples_nr_nodes));
% 
% min_density = 0;
% max_density = 1;
% nr_samples_density = 10;
% samples_density = linspace(min_density, max_density, nr_samples_density);
% 
% nr_measurements = 10;

% FULL RANGE UNRESTRICTED CYCLE CHAIN
% optimoptions_ = optimoptions('intlinprog');
% solver = @(digraph_) unrestricted_cycle_chain_solver(digraph_, timeout, timeout, optimoptions_);
% 
% min_nr_nodes = 4;
% max_nr_nodes = 8;
% nr_samples_nr_nodes = 5;
% samples_nr_nodes = round(linspace(min_nr_nodes, max_nr_nodes, nr_samples_nr_nodes));
% 
% min_density = 0;
% max_density = 1;
% nr_samples_density = 10;
% samples_density = linspace(min_density, max_density, nr_samples_density);
% 
% nr_measurements = 10;

for nr_nodes = samples_nr_nodes
    rep_nr_nodes = repmat(nr_nodes, 1, nr_samples_density);
    samples_nr_edges = round(samples_density * nr_nodes*(nr_nodes-1));
    
    [mean_exchange_values, std_exchange_values, timed_outs, mean_core_exec_times, std_core_exec_times] = evaluate_core_exec_times_generated(rep_nr_nodes, samples_nr_edges, nr_measurements, solver);
    
    title_ = [num2str(nr_nodes) ' Nodes'];
    xlabel_ = 'Density';
    if plot_y_core_exec_time
        plot_results(title_, xlabel_, samples_density, 'Core execution time (s)', mean_core_exec_times, std_core_exec_times, timed_outs);
    end 
    if plot_y_exchange_value
        plot_results(title_, xlabel_, samples_density, 'Exchange value', mean_exchange_values, std_exchange_values, timed_outs);
    end
end
