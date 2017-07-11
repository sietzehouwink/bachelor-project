function [cycles_chains, timed_out] = get_cycles_chains(digraph_, min_edges_cycle, max_edges_cycle, min_edges_chain, max_edges_chain, timeout)
    timer = tic;
    nodes_trader = find(strcmp(digraph_.Nodes.AgentType, 'trader'));
    [cycles, timed_out] = get_cycles(digraph_, nodes_trader, min_edges_cycle, max_edges_cycle, timeout);
    if timed_out
        cycles_chains = NaN;
        return;
    end
    timeout = max(timeout - toc(timer), 0);
    
    nodes_donor = find(strcmp(digraph_.Nodes.AgentType, 'donor'));
    [chains, timed_out] = get_paths(digraph_, nodes_donor, min_edges_chain, max_edges_chain, timeout);
    if timed_out
        cycles_chains = NaN;
        return;
    end
    
    cycles_chains = [cycles; chains];
    if isempty(cycles_chains)
        cycles_chains = {};
    end
end