clear global;
clear variables;
load('test_case_database.mat', 'digraphs')

nr_digraphs = 30;
timeout = 1;

test_digraphs = digraphs(randperm(length(digraphs), nr_digraphs));
get_significant_settings(test_digraphs, @(digraph, optimoptions_) unrestricted_bipartite_solver(digraph, timeout, optimoptions_))