function [mean_exchange_values, std_exchange_values, timed_outs_any, mean_core_exec_times, std_core_exec_times] = evaluate_core_exec_times_generated(samples_nr_nodes, samples_nr_edges, nr_measurements, solver)
    measurements_exchange_values = zeros(length(samples_nr_nodes), nr_measurements);
    timed_outs_any = false(length(samples_nr_nodes), 1);
    measurements_core_exec_times = zeros(length(samples_nr_nodes), nr_measurements);
    waitbar_ = waitbar(0, 'measure core exec times');
    
    for index_measurement = 1:nr_measurements
        [exchange_value, timed_outs, core_exec_times] = evaluate_generated(samples_nr_nodes(~timed_outs_any), samples_nr_edges(~timed_outs_any), solver);
        measurements_exchange_values(~timed_outs_any, index_measurement) = exchange_value;
        measurements_core_exec_times(~timed_outs_any, index_measurement) = core_exec_times;
        timed_outs_any(~timed_outs_any) = timed_outs_any(~timed_outs_any) | timed_outs;
        waitbar(index_measurement / nr_measurements, waitbar_);
    end
    mean_exchange_values = mean(measurements_exchange_values,2);
    std_exchange_values = std(measurements_exchange_values,0,2);
    mean_core_exec_times = mean(measurements_core_exec_times,2);
    std_core_exec_times = std(measurements_core_exec_times,0,2);
    
    delete(waitbar_)
end

