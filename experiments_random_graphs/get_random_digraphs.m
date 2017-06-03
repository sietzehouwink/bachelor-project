function [digraphs_2D] = get_random_digraphs(samples_nr_nodes, samples_nr_edges)
    digraphs_2D = cell(length(samples_nr_nodes), length(samples_nr_edges));
    for index_samples_nr_nodes = 1:length(samples_nr_nodes)
        sample_nr_nodes = samples_nr_nodes(index_samples_nr_nodes);
        for index_samples_nr_edges = 1:length(samples_nr_edges)
            sample_nr_edges = samples_nr_edges(index_samples_nr_edges);
            if sample_nr_edges > sample_nr_nodes * (sample_nr_nodes-1)
                continue;
            end
            digraphs_2D{index_samples_nr_nodes, index_samples_nr_edges} = get_random_digraph(sample_nr_nodes, sample_nr_edges);
        end
    end
end

