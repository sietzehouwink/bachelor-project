adj_list = {[2];[1;3];[2;4];[3;5];[1]};
graph = struct('nr_vertices', {5}, 'nr_edges', {8}, 'adj_list', {adj_list});
     
[optimal_edge_indices, max_exchange_weight] = clear_market_ILP_edge_formulation(graph);

disp('### Cleared market. ###');
fprintf('Maximum exchange weight: %d\n', max_exchange_weight);
fprintf('Activated edges: ');
for edge_index = 1:size(optimal_edge_indices, 1)
    if (optimal_edge_indices(edge_index) == 1)
        fprintf('%d ', edge_index);
    end
end
fprintf('\n');