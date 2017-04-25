clear global;
clear variables;

%[test_graphs,names] = get_test_graphs;
load('graphs');
test_graphs = graphs;
nr_graphs = length(test_graphs);

execution_times_edge_formulation = zeros(nr_graphs,1);
execution_times_cycle_formulation = zeros(nr_graphs,1);

for graph_index = 1:50
    
    graph = test_graphs{graph_index};
    
    tic;
    [~,value] = edge_formulation_solver(graph,1);
    exec_time = toc;
    execution_times_edge_formulation(graph_index) = exec_time;
    fprintf('Edge formulation: value: %d, exec_time: %f\n', value, exec_time);
    
    tic; % Also takes cycle generation into account.
    [~,value] = cycle_formulation_solver(graph,1);
    exec_time = toc;
    execution_times_cycle_formulation(graph_index) = exec_time;
    fprintf('Cycle formulation: value: %d, exec_time: %f\n', value, exec_time);
    
end

figure('Name','Edge / cycle formulation performance.');
hold on;
set(gca,'yTick', 1:50,'yticklabel',names(1:50));
barh([execution_times_edge_formulation(1:50) execution_times_cycle_formulation(1:50)]);
title('Edge / cycle formulation performance.');
xlabel('Execution time (s)');
ylabel('Graph type');
legend('Edge formulation', 'Cycle formulation');
hold off;
