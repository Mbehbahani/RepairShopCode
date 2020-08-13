function lst = remove_pats(lst,sol_o)
for o=1:numel(sol_o)
    for p=1:numel(sol_o{o})
        ind = find(lst(:,1)==sol_o{o}(p));
        lst(ind,:) = [];
    end
end