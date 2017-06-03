clear global;
clear variables;

timeout = 10;

% FULL RANGE UNRESTRICTED EDGE BIPARTITE
% NO SIGNIFICANT SETTINGS FOUND
solver = @(digraph, optimoptions_) unrestricted_edge_bipartite_solver(digraph, timeout, optimoptions_);
min_nr_nodes = 300;
max_nr_nodes = 450;
nr_samples_nr_nodes = 3;
min_fraction_nr_edges = 0;
max_fraction_nr_edges = 1;
nr_samples_nr_edges = 3;

digraphs = {};
samples_nr_nodes = round(linspace(min_nr_nodes, max_nr_nodes, nr_samples_nr_nodes));
for nr_nodes = samples_nr_nodes
    min_nr_edges = min_fraction_nr_edges * nr_nodes*(nr_nodes-1);
    max_nr_edges = max_fraction_nr_edges * nr_nodes*(nr_nodes-1);
    samples_nr_edges = round(linspace(min_nr_edges, max_nr_edges, nr_samples_nr_edges));
    digraphs = [digraphs get_random_digraphs(nr_nodes, samples_nr_edges)];
end
digraphs = digraphs(~cellfun('isempty', digraphs));

display_significant_settings(digraphs, solver);