clear global;
clear variables;

[test_graphs,names] = get_test_graphs;
nr_graphs = length(test_graphs);

execution_times_edge_formulation = zeros(nr_graphs,1);
execution_times_cycle_formulation = zeros(nr_graphs,1);

for graph_index = 1:length(test_graphs) 
    
    graph = test_graphs{graph_index};
    
    tic;
    [~,value] = edge_formulation_solver(graph);
    exec_time = toc;
    execution_times_edge_formulation(graph_index) = exec_time;
    fprintf('Edge formulation: value: %d, exec_time: %f\n', value, exec_time);
    
    tic; % Also takes cycle generation into account.
    [~,value] = cycle_formulation_solver(graph);
    exec_time = toc;
    execution_times_cycle_formulation(graph_index) = exec_time;
    fprintf('Cycle formulation: value: %d, exec_time: %f\n', value, exec_time);
    
end

figure('Name','Edge / cycle formulation performance.');
hold on;
set(gca,'yTick', 1:nr_graphs,'yticklabel',names);
barh([execution_times_edge_formulation execution_times_cycle_formulation]);
title('Edge / cycle formulation performance.');
xlabel('Execution time (s)');
ylabel('Graph type');
legend('Edge formulation', 'Cycle formulation');
hold off;
