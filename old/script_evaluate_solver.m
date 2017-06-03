clear global;
clear variables;
load('test_case_database', 'digraphs')

load('/Users/sietzehouwink/Documents/bachelor-project/measurements/restricted_cycles_chains_3_0/timed_outs.mat')
included = ~timed_outs;

digraphs_included = digraphs(included);
timeout = 30;
rounds = 5;
max_edges_cycle = 4;
max_edges_chain = 0;

optimoptions_ = optimoptions('intlinprog', 'LPPreprocess', 'none');
solver = @(digraph) restricted_cycles_chains_solver(digraph, max_edges_cycle, max_edges_chain, timeout, timeout, optimoptions_);

for round = 1:rounds
    [~, exchange_values_included, timed_outs_included, core_exec_times_included] = evaluate_solver_for_digraphs(digraphs_included, solver); 
    timed_outs = ones(length(digraphs),1);
    timed_outs(included) = timed_outs_included;
    core_exec_times = zeros(length(digraphs),1);
    core_exec_times(included) = core_exec_times_included;
    exchange_values = zeros(length(digraphs),1);
    exchange_values(included) = exchange_values_included;
    save(num2str(round),'timed_outs','core_exec_times');
end