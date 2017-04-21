function [graph] = generate_graph(nr_vertices, distribution_offered_vector, distribution_wanted_vector)
    
    offered_vector = distribution_to_vector(nr_vertices, distribution_offered_vector);
    wanted_vector = distribution_to_vector(nr_vertices, distribution_wanted_vector);
    
    adj_list = cell(nr_vertices,1);
    nr_edges = 0;
    for vertex_index = 1:nr_vertices
        my_offer = offered_vector(vertex_index,1);
        vertices_wanting_my_offer = find(my_offer == wanted_vector);
        vertices_wanting_my_offer = vertices_wanting_my_offer(vertices_wanting_my_offer ~= vertex_index); % prevention for self loops.
        adj_list{vertex_index,1} = vertices_wanting_my_offer;
        nr_edges = nr_edges + size(vertices_wanting_my_offer,1);
    end
    
    graph = struct('nr_vertices', {nr_vertices}, 'nr_edges', {nr_edges}, 'adj_list', {adj_list});
    
end

function [vector] = distribution_to_vector(nr_vertices, distribution_vector)
    last_index_per_category_vector = round(cumsum(distribution_vector) .* nr_vertices);
    elements_per_category_vector = last_index_per_category_vector - [0; last_index_per_category_vector(1:end-1)];
    nr_categories = size(distribution_vector,1);
    sorted_elements = repelem((1:nr_categories)', elements_per_category_vector);
    vector = randomize_vector(sorted_elements);
end

function [randomized_vector] = randomize_vector(vector)
    length_vector = size(vector,1);
    randomized_vector = vector(randperm(length_vector, length_vector)');
end