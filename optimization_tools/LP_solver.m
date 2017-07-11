function [setting, maximum, timed_out, core_exec_time] = LP_solver(weight_vector, inequality_matrix, inequality_vector, equality_matrix, equality_vector, lower_bounds, upper_bounds, timeout, options)
    % Special case.
    if isempty(weight_vector)
        setting = []; maximum = 0; timed_out = false; core_exec_time = 0;
        return;
    end
    
    % Add default options.
    options = cplexoptimset(options, 'Display', 'off', 'MaxTime', timeout);
    
    % Solve and time.
    timer = tic;
    [setting, minimum, exitflag, ~] = cplexlp(-weight_vector, inequality_matrix, inequality_vector, equality_matrix, equality_vector, lower_bounds, upper_bounds, [], options);
    core_exec_time = toc(timer);

    % Test convergence to solution.
    timed_out = exitflag ~= 1;
    if timed_out
        setting = NaN; maximum = NaN; core_exec_time = NaN;
        return;
    end
    
    % Construct results.
    maximum = -minimum;
end
