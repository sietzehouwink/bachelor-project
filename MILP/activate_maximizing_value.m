function [activated, maximum, timed_out] = activate_maximizing_value(weight_vector, inequality_matrix, inequality_vector, equality_matrix, equality_vector, timeout, optimoptions_)
    nr_variables = size(weight_vector, 1);
    
    if nr_variables == 0
        activated = [];
        maximum = 0;
        timed_out = false;
        return;
    end
    
    to_integer_restricted_bitmap = (1:nr_variables)';
    lowerbound_vector = zeros(nr_variables,1);
    upperbound_vector = ones(nr_variables,1);
    optimoptions_with_timeout = optimoptions(optimoptions_, 'Display', 'none', 'MaxTime', timeout);
    
    [activated_bitmap, minimum, exitflag, ~] = intlinprog(-weight_vector, to_integer_restricted_bitmap, inequality_matrix, inequality_vector, equality_matrix, equality_vector, lowerbound_vector, upperbound_vector, optimoptions_with_timeout);
    
    timed_out = exitflag ~= 1;
    if timed_out
        activated = [];
        maximum = 0;
        return;
    end
    
    activated = find(activated_bitmap);
    maximum = round(-minimum);
end