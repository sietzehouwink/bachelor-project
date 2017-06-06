function [exchange_values, timed_outs, core_exec_times] = evaluate_generated(samples_nr_nodes, samples_nr_edges, solver)
    exchange_values = zeros(length(samples_nr_nodes), 1);
    timed_outs = false(length(samples_nr_nodes), 1);
    core_exec_times = zeros(length(samples_nr_nodes), 1);   
    waitbar_ = waitbar(0, 'evaluate generated');
    
    for index_sample = 1:length(samples_nr_nodes)
        nr_nodes = samples_nr_nodes(index_sample);
        nr_edges = samples_nr_edges(index_sample);
        
        if nr_nodes * (nr_nodes-1) < nr_edges
            timed_outs(index_sample_nr_nodes, index_sample_nr_edges) = true;
            continue;
        end
        
        digraph_ = get_random_digraph(nr_nodes, nr_edges);
        [~, exchange_value, timed_out, core_exec_time] = solver(digraph_);
        
        waitbar(index_sample / length(samples_nr_nodes), waitbar_);
        if timed_out
            timed_outs(index_sample) = true;
        end
        exchange_values(index_sample) = exchange_value;
        core_exec_times(index_sample) = core_exec_time;
    end

    delete(waitbar_);
end
