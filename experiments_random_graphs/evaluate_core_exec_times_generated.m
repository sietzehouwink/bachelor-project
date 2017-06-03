function [timed_outs, mean_core_exec_times, std_core_exec_times] = evaluate_core_exec_times_generated(samples_nr_nodes, samples_nr_edges, nr_measurements, solver)
    timed_outs = false(length(samples_nr_nodes), length(samples_nr_edges));
    measurements_core_exec_times = zeros(length(samples_nr_nodes), length(samples_nr_edges), nr_measurements);
    waitbar_ = waitbar(0, 'measure core exec times');
    
    for index_measurement = 1:nr_measurements
        [~, timed_outs, core_exec_times] = evaluate_generated(samples_nr_nodes, samples_nr_edges, solver);
        timed_outs = timed_outs | timed_outs;
        measurements_core_exec_times(:,:,index_measurement) = core_exec_times;
        waitbar(index_measurement / nr_measurements, waitbar_);
    end
    mean_core_exec_times = mean(measurements_core_exec_times,3);
    std_core_exec_times = std(measurements_core_exec_times,0,3);
    
    delete(waitbar_)
end

