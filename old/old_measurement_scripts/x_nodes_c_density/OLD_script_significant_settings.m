clear global;
clear variables;

timeout = 10;

% FULL RANGE UNRESTRICTED EDGE BIPARTITE
% 
solver = @(digraph, optimoptions_) unrestricted_edge_bipartite_solver(digraph, timeout, optimoptions_);
min_nr_edges = 11000;
max_nr_edges = 25000;
nr_samples_nr_edges = 3;
nr_samples_nr_nodes = 3;

digraphs = {};
samples_nr_edges = round(linspace(min_nr_edges, max_nr_edges, nr_samples_nr_edges));
for nr_edges = samples_nr_edges
    samples_nr_nodes = round(linspace(0, nr_edges, nr_samples_nr_nodes));
    digraphs = [digraphs; get_random_digraphs(samples_nr_nodes, nr_edges)];
end
digraphs = digraphs(~cellfun('isempty', digraphs));

display_significant_settings(digraphs, solver);