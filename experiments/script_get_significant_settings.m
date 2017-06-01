clear global;
clear variables;
load('test_case_database.mat', 'digraphs')

nr_digraphs = 30;
timeout = 1;
max_edges_cycle = 2;
max_edges_chain = 0;

test_digraphs = digraphs(randperm(length(digraphs), nr_digraphs));

solver = @(digraph, optimoptions_) restricted_cycles_chains_solver(digraph, max_edges_cycle, max_edges_chain, timeout, timeout, optimoptions_);
get_significant_settings(test_digraphs, solver)