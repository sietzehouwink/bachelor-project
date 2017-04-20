% to_simple_cycles(graph)
%
% Returns all unique simple cycles in the input graph.
%
% Uses DFS to explore the graph. When the algorithm encounters an already
% visited vertex, a cycle is detected. As for each vertex its parent is
% tracked, the cycle can be inferred.

function [cycles] = to_simple_cycles(graph)
    stack = (1:graph.nr_vertices)';
    parents = zeros(graph.nr_vertices,1);
    discovered = false(graph.nr_vertices,1);
    cycles = cell(0);
    while ~isempty(stack) 
        [stack, visiting_vertex] = pop(stack);
        if ~discovered(visiting_vertex,1)
            discovered(visiting_vertex,1) = true;
            for adjacent_vertex = graph.adj_list{visiting_vertex,1}'
                if discovered(adjacent_vertex)
                    cycles{end+1,1} = infer_cycle(parents, adjacent_vertex, visiting_vertex);
                else
                    stack = push(stack, adjacent_vertex);
                    parents(adjacent_vertex,1) = visiting_vertex;
                end
            end
        end
    end
end

function [cycle] = infer_cycle(parents, first_vertex, last_vertex)
    cycle = [];
    while last_vertex ~= first_vertex
        cycle = [last_vertex; cycle];
        last_vertex = parents(last_vertex);
    end
    cycle = [last_vertex; cycle];
end

function [stack] = push(stack, value)
    stack = [stack; value];
end
      
function [stack, value] = pop(stack)
    value = stack(end,1);
    stack = stack(1:end-1,1);
end