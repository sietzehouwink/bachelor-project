clear global;
clear variables;
load('graph_article', 'graph');

%profile on
[activated_graph, max_exchange_value, ~] = cycle_formulation_column_generation_solver(graph, 1);
%profile viewer

disp('### Cleared market. ###');
fprintf('Maximum exchange value: %d\n', max_exchange_value);
fprintf('Activated edges: ');
for edge = table2array(activated_graph.Edges(:,1))'
   	fprintf('[%d %d] ', edge(1,1), edge(2,1));
end
fprintf('\n');