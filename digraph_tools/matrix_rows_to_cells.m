function [cells] = matrix_rows_to_cells(matrix)
    cells = cell(size(matrix,1), 1);
    for row = 1:size(matrix,1)
        cells{row} = matrix(row,:)';
    end
end
