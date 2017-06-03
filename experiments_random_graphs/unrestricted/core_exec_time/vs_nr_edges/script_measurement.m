clear global;
clear variables;

timeout = 10;

% FULL RANGE UNRESTRICTED EDGE BIPARTITE
% optimoptions_ = optimoptions('intlinprog');
% solver = @(digraph_) unrestricted_edge_bipartite_solver(digraph_, timeout, optimoptions_);
% min_nr_nodes = 300;
% max_nr_nodes = 450;
% nr_samples_nr_nodes = 3;
% min_fraction_nr_edges = 0;
% max_fraction_nr_edges = 1;
% nr_samples_nr_edges = 10;
% nr_measurements = 5;

figure;
xlabel('Number of edges');
ylabel('Core execution time (s)');
hold on;

samples_nr_nodes = round(linspace(min_nr_nodes, max_nr_nodes, nr_samples_nr_nodes));
for nr_nodes = samples_nr_nodes
    min_nr_edges = min_fraction_nr_edges * nr_nodes*(nr_nodes-1);
    max_nr_edges = max_fraction_nr_edges * nr_nodes*(nr_nodes-1);
    samples_nr_edges = round(linspace(min_nr_edges, max_nr_edges, nr_samples_nr_edges));
    
    [timed_outs, mean_core_exec_times, std_core_exec_times] = evaluate_core_exec_times_generated(nr_nodes, samples_nr_edges, nr_measurements, solver);
    
    x = samples_nr_edges(~timed_outs);
    y = mean_core_exec_times(1,~timed_outs);
    err = std_core_exec_times(1,~timed_outs);
    errorbar(x, y, err, 'DisplayName', [num2str(nr_nodes) ' nodes']);  
end

legend('show');
ylim([0 inf]);
