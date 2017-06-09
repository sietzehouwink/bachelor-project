function [cycles_chains, timed_out] = get_cycles_chains(digraph_, min_edges_cycle, max_edges_cycle, min_edges_chain, max_edges_chain, timeout)
    nodes_trader = find(strcmp(digraph_.Nodes.AgentType, 'trader'));
    
    timer = tic;
    [cycles, timed_out] = find_cycles(digraph_, nodes_trader, min_edges_cycle, max_edges_cycle, timeout);
    timeout = max(timeout-toc(timer), 0);
    
    if timed_out
        cycles_chains = {};
        return;
    end
    
    nodes_donor = find(strcmp(digraph_.Nodes.AgentType, 'donor'));
    
    [chains, timed_out] = find_paths(digraph_, nodes_donor, min_edges_chain, max_edges_chain, timeout);
    
    if timed_out
        cycles_chains = {};
        return;
    end
    
    cycles_chains = [cycles; chains];
    if isempty(cycles_chains)
        cycles_chains = {};
    end
end