function [graphs, names] = get_test_graphs()

    fileID = fopen('graphs.txt');

    excluded = {'Balaban10Cage', 'Balaban11Cage', 'BarnetteBosakLederbergGraph', 'BiggsSmithGraph', 'BipartiteKneser', 'BrinkmannGraph'};

    graphs = {};
    names = {};

    line = fgets(fileID);
    i = 1;
    while line ~= -1
        i
        i = i+1;
        
        indices = regexp(line,'"');
        name = line(indices(1)+1:indices(2)-1);
        names{end+1} = name;
%         if ~isempty(strmatch(name, excluded))
%             continue;
%         else
%             excluded{end+1} = name; % Exclude further of same type.
%             names{end+1} = name;
%         end
        indices = regexp(line,'{{\d');
        if ~isempty(indices)
            indices
            line = line(indices(end):end);
            line = strrep(line,'{','');
            line = strrep(line,'}','');
            line = strrep(line,',','');
            [A,n] = sscanf(line,'%d');
            A = reshape(A,2,n/2);
            graph = digraph(A(1,:), A(2,:));
            graphs{end+1} = graph;
        end
        line = fgets(fileID);
    end

end

