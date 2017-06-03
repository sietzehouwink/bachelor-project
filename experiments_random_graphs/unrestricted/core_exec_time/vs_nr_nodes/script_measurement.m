clear global;
clear variables;

timeout = 10;

% FULL RANGE UNRESTRICTED EDGE BIPARTITE
optimoptions_ = optimoptions('intlinprog');
solver = @(digraph_) unrestricted_edge_bipartite_solver(digraph_, timeout, optimoptions_);
min_nr_edges = 11000;
max_nr_edges = 25000;
nr_samples_nr_edges = 3;
nr_samples_nr_nodes = 10;
nr_measurements = 5;

figure;
xlabel('Number of nodes');
ylabel('Core execution time (s)');
hold on;

samples_nr_edges = round(linspace(min_nr_edges, max_nr_edges, nr_samples_nr_edges));
for nr_edges = samples_nr_edges
    samples_nr_nodes = round(linspace(0, nr_edges, nr_samples_nr_nodes));
    
    [timed_outs, mean_core_exec_times, std_core_exec_times] = evaluate_core_exec_times_generated(samples_nr_nodes, nr_edges, nr_measurements, solver);
    
    x = samples_nr_nodes(~timed_outs);
    y = mean_core_exec_times(~timed_outs);
    err = std_core_exec_times(~timed_outs);
    errorbar(x, y, err, 'DisplayName', [num2str(nr_edges) ' edges']);  
end

legend('show');
ylim([0 inf]);
