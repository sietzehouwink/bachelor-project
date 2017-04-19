% Assumes connected components, starts from first vertex!!!!!!!
function [cycles] = get_cycles(graph)
    stack = [];
    stack = push(stack, 1);
    parents_of_edges = zeros(graph.nr_vertices,1);
    discovered = false(graph.nr_vertices,1);
    cycles = cell(0,0);
    while ~isempty(stack) 
        [stack, vertex] = pop(stack);
        if ~discovered(vertex)
            discovered(vertex) = true;
            adjacent_vertices = graph.adj_list{vertex};
            nr_outgoing_edges = size(adjacent_vertices,1);
            for i = 1:nr_outgoing_edges
                if ~discovered(adjacent_vertices(i))
                    stack = push(stack, adjacent_vertices(i));
                    parents_of_edges(adjacent_vertices(i)) = vertex;
                else
                    cycles{end+1,1} = get_path(parents_of_edges, vertex, adjacent_vertices(i));
                end
            end
        end
    end
end

function [path] = get_path(parents, last, first)
    path = [];
    while last ~= first
        path = [last; path];
        last = parents(last);
    end
    path = [last; path];
end

function [stack] = push(stack, element)
    stack = [stack; element];
end
      
function [stack, value] = pop(stack)
    nr_elements = size(stack,1);
    value = stack(nr_elements);
    stack = stack(1:end-1);
end