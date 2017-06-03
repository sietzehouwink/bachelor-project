function [activated_digraphs, exchange_values, timed_outs, core_exec_times] = evaluate(digraphs, solver)
    activated_digraphs = cell(length(digraphs),1);
    exchange_values = zeros(length(digraphs),1);
    timed_outs = false(length(digraphs),1);
    core_exec_times = zeros(length(digraphs),1);
    
    for digraph_index = 1:length(digraphs)
        digraph = digraphs{digraph_index};
        
        [activated_digraph, exchange_value, timed_out, core_exec_time] = solver(digraph);
        
        activated_digraphs{digraph_index} = activated_digraph;
        exchange_values(digraph_index) = exchange_value;
        timed_outs(digraph_index) = timed_out;
        core_exec_times(digraph_index) = core_exec_time;
    end
end
