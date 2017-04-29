function [cycles, timed_out] = find_cycles(graph, timeout)

    function f = circuit(v)
        
        function unblock(u)
            blocked(u) = false;
            for w = B{u}
                if blocked(w)
                    unblock(w)
                end
            end
            B{u} = [];
        end
        
        f = false;
        stack(end+1,1) = v;
        blocked(v) = true;
        for w = successors(A_k, v)'
            if w == s
                cycles{end+1,1} = stack;
                if toc(timer) > timeout
                    timed_out = true;
                    return;
                end
                f = true;
            elseif ~blocked(w)
                if circuit(w)
                    f = true;
                end
            end
        end
        
        if f
            unblock(v)
        else
            for w = successors(A_k, v)'
                if ~any(v == B{w})
                    B{w} = [B{w} v];
                end
            end
        end
        
        stack = stack(1:end-1,1);
    end

    timer = tic;
    timed_out = false;
        
    n = numnodes(graph);

    B = cell(n,1);

    blocked = false(1,n);

    s = 1;
    cycles = {};
    stack=[];

    A_k = graph;

    bins = conncomp(A_k)';

    while s < n

        enabled_vertices_bitset = logical(bins == bins(s));
        enabled_vertices_bitset(1:s-1,1) = false;
        matrix = adjacency(graph);
        matrix(~enabled_vertices_bitset,:) = 0;
        matrix(:,~enabled_vertices_bitset) = 0;
        A_k = digraph(matrix);
        
        blocked(enabled_vertices_bitset) = false;
        B(enabled_vertices_bitset) = {[]};

        circuit(s);
        if timed_out
            return;
        end
        s = s + 1;

    end 

end