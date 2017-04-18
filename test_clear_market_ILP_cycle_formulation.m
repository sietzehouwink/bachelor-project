nr_vertices = 5;
edges = [1,2;
         2,1;
         2,3;
         3,2;
         3,4;
         4,3;
         4,5;
         5,1];
     
[optimal_edge_indices, max_exchange_weight] = clear_market_ILP_cycle_formulation(nr_vertices, edges);

disp('### Cleared market. ###');
fprintf('Maximum exchange weight: %d\n', max_exchange_weight);
fprintf('Activated cycles: ');
for edge_index = 1:size(optimal_edge_indices, 1)
    if (optimal_edge_indices(edge_index) == 1)
        fprintf('%d ', edge_index);
    end
end
fprintf('\n');