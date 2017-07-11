function [new_paths] = add_edge_to_paths(paths, adjacency_matrix)
    new_paths = cell(size(paths,1), 1);
    for idx = 1:size(paths,1)
        path = paths(idx, :);
        successors = find(adjacency_matrix(path(end),:));
        successors_not_in_path = successors(~ismember_sorted(successors, sort(path)));
        if isempty(successors_not_in_path)
            continue;
        end
        % Each row represents the path + a successor.
        new_paths{idx} = [repmat(path,length(successors_not_in_path),1) successors_not_in_path'];
    end
    new_paths = vertcat(new_paths{:});
end