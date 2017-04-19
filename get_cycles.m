function [cycles] = get_cycles(nr_vertices, edges)
    vertex_cycles = get_cycles_from_vertex(nr_vertices, edges, 1);
    
    % Ugly way of transforming cycles given by vertices to cycles given by
    % edges.
    cycles = cell(0,0);
    for i = 1:size(vertex_cycles,1)
        cycle = vertex_cycles{i};
        edge_cycle = [];
        for j = 1:size(cycle,1)
            cur = cycle(j);
            if j == size(cycle,1)
                next = cycle(1);
            else
                next = cycle(j+1);
            end
            for k = 1:size(edges,1)
                if all(edges(k,:) == [cur next])
                    edge_cycle(end+1,1) = k;
                    break;
                end
            end
        end
        cycles{end+1,1} = edge_cycle;
    end
end

% Assumes connected components!!!!!!!
function [cycles] = get_cycles_from_vertex(nr_vertices, edges, vertex_nr)
    stack = [];
    stack = push(stack, vertex_nr);
    parents_of_edges = zeros(nr_vertices,1);
    discovered = false(nr_vertices,1);
    cycles = cell(0,0);
    while ~isempty(stack) 
        [stack, vertex] = pop(stack);
        if ~discovered(vertex)
            discovered(vertex) = true;
            adjacent_vertices = edges(edges(:,1) == vertex, 2);
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