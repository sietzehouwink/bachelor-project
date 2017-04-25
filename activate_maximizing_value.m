function [activated, maximum] = activate_maximizing_value(weight_vector, inequality_matrix, inequality_vector, equality_matrix, equality_vector, timeout)
    nr_variables = size(inequality_matrix, 2);
    
    to_integer_restricted_bitmap = ones(nr_variables,1);
    lowerbound_vector = zeros(nr_variables,1);
    upperbound_vector = ones(nr_variables,1);
    options = optimoptions('intlinprog', 'Display', 'none', 'MaxTime', timeout);
    
    [activated_bitmap, minimum, ~, ~] = intlinprog(-weight_vector, to_integer_restricted_bitmap, inequality_matrix, inequality_vector, equality_matrix, equality_vector, lowerbound_vector, upperbound_vector, options);
    activated = find(activated_bitmap);
    maximum = -minimum;
end
