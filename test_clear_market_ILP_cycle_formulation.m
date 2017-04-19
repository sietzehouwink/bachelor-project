adj_list = {[2];[1;3];[2;4];[3;5];[1]};
graph = struct('nr_vertices', {5}, 'nr_edges', {8}, 'adj_list', {adj_list});
     
[activated_graph, max_exchange_value] = clear_market_ILP_cycle_formulation(graph);

disp('### Cleared market. ###');
fprintf('Maximum exchange value: %d\n', max_exchange_value);
fprintf('Activated edges: ');
for tail_vertex = 1:activated_graph.nr_vertices
    for head_vertex = activated_graph.adj_list{tail_vertex}'
        fprintf('[%d %d] ', tail_vertex, head_vertex);
    end
end
fprintf('\n');