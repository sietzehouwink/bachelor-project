clear;

nr_vertices_test_set = (100:100:500)';
execution_times_edge_formulation = zeros(size(nr_vertices_test_set));
execution_times_cycle_formulation = zeros(size(nr_vertices_test_set));

for index = 1:size(nr_vertices_test_set,1)
    nr_vertices = nr_vertices_test_set(index);
    graph = generate_graph(nr_vertices, nr_vertices / 10, 2);
    
    plot(graph);
    
    tic;
    [~,value] = edge_formulation_solver(graph);
    exec_time = toc;
    execution_times_edge_formulation(index) = exec_time;
    fprintf('Edge formulation: nr_vertices: %d, value: %d, fraction: %f, exec_time: %f\n', nr_vertices, value, value/nr_vertices, exec_time);
    
    tic;
    [~,value] = cycle_formulation_solver(graph);
    exec_time = toc;
    execution_times_cycle_formulation(index) = exec_time;
    fprintf('Cycle formulation: nr_vertices: %d, value: %d, fraction: %f, exec_time: %f\n', nr_vertices, value, value/nr_vertices, exec_time);
    
end

figure
hold on;
plot(nr_vertices_test_set, execution_times_edge_formulation);
plot(nr_vertices_test_set, execution_times_cycle_formulation);
title('Execution time vs. number of vertices.');
xlabel('Number of vertices');
legend('Edge formulation', 'Cycle formulation');
hold off;
ylabel('Execution time (s)');