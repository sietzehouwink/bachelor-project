clear global;
clear variables;

%[test_graphs,names] = get_test_graphs;
load('graphs');
test_graphs = graphs;
nr_graphs = length(test_graphs);

execution_times_edge_formulation = zeros(nr_graphs,1);
execution_times_cycle_formulation = zeros(nr_graphs,1);

max_graph = 50;

for graph_index = 1:max_graph
    
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
set(gca,'yTick', 1:max_graph,'yticklabel',names(1:max_graph));
barh([execution_times_edge_formulation(1:max_graph) execution_times_cycle_formulation(1:max_graph)]);
title('Edge / cycle formulation performance.');
xlabel('Execution time (s)');
ylabel('Graph type');
legend('Edge formulation', 'Cycle formulation');
hold off;
