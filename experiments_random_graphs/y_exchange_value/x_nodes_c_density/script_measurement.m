clear global;
clear variables;

timeout = 5;

% UNRESTRICTED (EDGE BIPARTITE)
optimoptions_ = optimoptions('intlinprog');
solver = @(digraph_) unrestricted_edge_bipartite_solver(digraph_, timeout, optimoptions_);

min_density = 0.01;
max_density = 0.05;
nr_samples_density = 5;
samples_density = logspace(log10(min_density), log10(max_density), nr_samples_density);

min_nr_nodes = 0;
max_nr_nodes = 500;
nr_samples_nr_nodes = 30;
samples_nr_nodes = round(linspace(min_nr_nodes, max_nr_nodes, nr_samples_nr_nodes));

nr_measurements = 10;


for density = samples_density    
    samples_nr_edges = round(density * samples_nr_nodes.*(samples_nr_nodes-1));
    
    [mean_exchange_values, std_exchange_values, timed_outs, ~, ~] = evaluate_core_exec_times_generated(samples_nr_nodes, samples_nr_edges, nr_measurements, solver);
    
    plot_results(['Density ' num2str(density)], 'Number of nodes', samples_nr_nodes, 'Fraction exchange value', mean_exchange_values ./ samples_nr_nodes', std_exchange_values ./ samples_nr_nodes', timed_outs);
end
