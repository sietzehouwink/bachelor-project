clear global;
clear variables;

timeout = 5;

% UNRESTRICTED (EDGE BIPARTITE)
optimoptions_ = optimoptions('intlinprog');
solver = @(digraph_) unrestricted_edge_bipartite_solver(digraph_, timeout, optimoptions_);

min_nr_nodes = 50;
max_nr_nodes = 500;
nr_samples_nr_nodes = 5;
samples_nr_nodes = round(logspace(log10(min_nr_nodes), log10(max_nr_nodes), nr_samples_nr_nodes));

min_density = 0;
max_density = 0.08;
nr_samples_density = 30;
samples_density = linspace(min_density, max_density, nr_samples_density);

nr_measurements = 10;


for nr_nodes = samples_nr_nodes
    rep_nr_nodes = repmat(nr_nodes, 1, nr_samples_density);
    samples_nr_edges = round(samples_density * nr_nodes*(nr_nodes-1));
    
    [mean_exchange_values, std_exchange_values, timed_outs, ~, ~] = evaluate_core_exec_times_generated(rep_nr_nodes, samples_nr_edges, nr_measurements, solver);
    
    plot_results([num2str(nr_nodes) ' Nodes'], 'Density', samples_density, 'Fraction exchange value', mean_exchange_values / nr_nodes, std_exchange_values / nr_nodes, timed_outs);
end
