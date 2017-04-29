function [activated_graph, exchange_value, timed_out] = cycle_formulation_column_generation_solver(graph, timeout)
    timer = tic;
    
    [cycles, timed_out] = find_cycles(graph, timeout);
    if timed_out
        activated_graph = digraph();
        exchange_value = 0;
        return;
    end
    
    f = length(cycles{1});
    A = zeros(numnodes(graph),1);
    A(cycles{1},1) = 1;
    b = ones(numnodes(graph),1);
    added_cycles{length(f)} = cycles{1};
    while true
        activated_bitmap = linprog(b, -A', -f, [], [], zeros(length(b),1), Inf * ones(length(b),1));
        for cycle_index = 1:length(cycles)
            cycle = cycles{cycle_index};
            price = length(cycle) - sum(activated_bitmap(cycle));
            if price > 0
                break;
            end
        end
        if price <= 0
            break;
        end
        f(end+1,1) = length(cycle);
        A(cycle, end+1) = 1;
        added_cycles{end+1,1} = cycle;
    end

    options = optimoptions('intlinprog', 'Display', 'off');
    [activated_bitmap, minimum, exitflag, ~] = intlinprog(-f, ones(length(f),1), A, b, [], [], zeros(length(f),1), ones(length(f),1), options);
    activated_cycles = added_cycles(logical(activated_bitmap));
    exchange_value = -minimum;
    
    activated_graph = cycles_to_graph(numnodes(graph), activated_cycles);

end

