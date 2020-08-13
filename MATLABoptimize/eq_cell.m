function r = eq_cell(x,y)
r = 1;
cell_s_x = size(x);
cell_s_y = size(y);
if all(cell_s_x==cell_s_y)
    for i=1:cell_s_x(1)
        for j=1:cell_s_x(2)
            matrix_s_x = size(x{i,j});
            matrix_s_y = size(y{i,j});
            if all(matrix_s_x==matrix_s_y)
                if x{i,j}~=y{i,j}
                    r = 0;
                end
            else
                r = 0;
                break
            end
        end
    end
else
    r = 0;
end