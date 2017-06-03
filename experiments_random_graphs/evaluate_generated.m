function [exchange_values, timed_outs, core_exec_times] = generate_evaluate(samples_nr_nodes, samples_nr_edges, solver)
    nr_samples_nr_nodes = length(samples_nr_nodes);
    nr_samples_nr_edges = length(samples_nr_edges);
    exchange_values = zeros(nr_samples_nr_nodes, nr_samples_nr_edges);
    timed_outs = false(nr_samples_nr_nodes, nr_samples_nr_edges);
    core_exec_times = zeros(nr_samples_nr_nodes, nr_samples_nr_edges);   
    waitbar_ = waitbar(0, 'generate evaluate');
    
    for index_sample_nr_nodes = 1:nr_samples_nr_nodes
        nr_nodes = samples_nr_nodes(index_sample_nr_nodes);       
        for index_sample_nr_edges = 1:nr_samples_nr_edges
            nr_edges = samples_nr_edges(index_sample_nr_edges);
    
            if nr_nodes * (nr_nodes-1) < nr_edges
                timed_outs(index_sample_nr_nodes, index_sample_nr_edges) = true;
                continue;
            end
            
            digraph_ = get_random_digraph(nr_nodes, nr_edges);
            [~, exchange_value, timed_out, core_exec_time] = solver(digraph_);
            
            waitbar(((index_sample_nr_nodes-1) * nr_samples_nr_edges + index_sample_nr_edges) / (nr_samples_nr_nodes * nr_samples_nr_edges), waitbar_);
            if timed_out
                timed_outs(index_sample_nr_nodes, index_sample_nr_edges) = true;
                continue
            end
            exchange_values(index_sample_nr_nodes, index_sample_nr_edges) = exchange_value;
            core_exec_times(index_sample_nr_nodes, index_sample_nr_edges) = core_exec_time;
        end
    end

    delete(waitbar_);
end
