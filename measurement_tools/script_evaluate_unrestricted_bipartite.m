clear global;
clear variables;
load('test_case_database.mat', 'digraphs')

timeout = 30;

optimoptions_ = optimoptions('LPPreprocess', 'none');
[~, ~, timed_outs_default, core_exec_times_default] = evaluate_solver_for_digraphs(digraphs, @(digraph) solver(digraph, optimoptions_)); 