function deter = stat2deter(stat)
[cell_size,~] = size(stat);
deter = cell(cell_size,1);
for i=1:cell_size
    [mat_size,~] = size(stat{i});
    deter{i} = zeros(mat_size,3);
    for j=1:mat_size
        deter{i}(j,:) = mean(stat{i}(j,:));
        deter{i}(j,3) = deter{i}(j,3)+0.0001;
    end
end