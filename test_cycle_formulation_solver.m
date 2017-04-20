load('graph_article', 'graph');

%profile on
[activated_graph, max_exchange_value] = cycle_formulation_solver(graph);
%profile viewer

disp('### Cleared market. ###');
fprintf('Maximum exchange value: %d\n', max_exchange_value);
fprintf('Activated edges: ');
for tail_vertex = 1:activated_graph.nr_vertices
    for head_vertex = activated_graph.adj_list{tail_vertex}'
        fprintf('[%d %d] ', tail_vertex, head_vertex);
    end
end
fprintf('\n');