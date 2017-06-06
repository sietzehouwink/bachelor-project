clear global;
clear variables;

timeout = 5;
plot_y_core_exec_time = false;
plot_y_exchange_value = true;

% FULL RANGE UNRESTRICTED EDGE BIPARTITE
% optimoptions_ = optimoptions('intlinprog');
% solver = @(digraph_) unrestricted_edge_bipartite_solver(digraph_, timeout, optimoptions_);
% 
% min_density = 0.1;
% max_density = 1;
% nr_samples_density = 5;
% samples_density = logspace(log10(min_density), log10(max_density), nr_samples_density);
% 
% min_nr_nodes = 0;
% max_nr_nodes = 400;
% nr_samples_nr_nodes = 10;
% samples_nr_nodes = round(linspace(min_nr_nodes, max_nr_nodes, nr_samples_nr_nodes));
% 
% nr_measurements = 10;

% FULL RANGE UNRESTRICTED EDGE DIGRAPH
% optimoptions_ = optimoptions('intlinprog');
% solver = @(digraph_) unrestricted_edge_digraph_solver(digraph_, timeout, optimoptions_);
% 
% min_density = 0.1;
% max_density = 1;
% nr_samples_density = 5;
% samples_density = logspace(log10(min_density), log10(max_density), nr_samples_density);
% 
% min_nr_nodes = 0;
% max_nr_nodes = 400;
% nr_samples_nr_nodes = 10;
% samples_nr_nodes = round(linspace(min_nr_nodes, max_nr_nodes, nr_samples_nr_nodes));
% 
% nr_measurements = 10;

% FULL RANGE RESTRICTED CYCLE CHAIN
optimoptions_ = optimoptions('intlinprog');
max_edges_cycle = 2;
solver = @(digraph_) restricted_cycle_chain_solver(digraph_, max_edges_cycle, 0, 10, timeout, optimoptions_);

min_density = 0.1;
max_density = 1;
nr_samples_density = 1%5;
samples_density = logspace(log10(min_density), log10(max_density), nr_samples_density);

min_nr_nodes = 0;
max_nr_nodes = 200;
nr_samples_nr_nodes = 10;
samples_nr_nodes = round(linspace(min_nr_nodes, max_nr_nodes, nr_samples_nr_nodes));

nr_measurements = 1%10;

for density = samples_density    
    samples_nr_edges = round(density * samples_nr_nodes.*(samples_nr_nodes-1));
    
    [mean_exchange_values, std_exchange_values, timed_outs, mean_core_exec_times, std_core_exec_times] = evaluate_core_exec_times_generated(samples_nr_nodes, samples_nr_edges, nr_measurements, solver);
    
    if plot_y_core_exec_time
        x = samples_nr_nodes(~timed_outs);
        y = mean_core_exec_times(~timed_outs);
        err = std_core_exec_times(~timed_outs);

        figure;
        hold on;
        title(['Density ' num2str(density)]);
        xlabel('Number of nodes');
        ylabel('Core execution time (s)');    
        errorbar(x, y, err);  
        ylim([0 inf]);
    end
    
    if plot_y_exchange_value
        x = samples_nr_nodes(~timed_outs);
        y = mean_exchange_values(~timed_outs);
        err = std_exchage_values(~timed_outs);

        figure;
        hold on;
        title(['Density ' num2str(density)]);
        xlabel('Number of nodes');
        ylabel('Exchange value');    
        errorbar(x, y, err);  
        ylim([0 inf]);
    end
end
