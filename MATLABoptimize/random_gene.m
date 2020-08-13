function gene = random_gene(lst,Pos)
[lst_size,~] = size(lst);
[~,O] = size(Pos{1});
possible_lst = cell(O,1);
gene = cell(O,1);
for i=1:lst_size   
        possible_ORs = find(Pos{lst(i,2)}(lst(i,3),:));
        while isempty(possible_ORs)==0
            possible_lst{possible_ORs(1)} = [possible_lst{possible_ORs(1)} lst(i,1)];
            possible_ORs(1) = [];
        end  
end

OR_permu = randperm(O);
for j=1:O
    [~,max_pat] = size(possible_lst{OR_permu(j)});
    pat_permu = randperm(max_pat);
    %q_pat = ceil(max_pat*rand);
    q_pat = min(max_pat,randi(20));
    gene{OR_permu(j)} = possible_lst{OR_permu(j)}(pat_permu(1:q_pat));
    for k=(j+1):O
        for l=1:q_pat
            removing = find(gene{OR_permu(j)}(l)==possible_lst{OR_permu(k)});
            if isempty(removing)==0
                possible_lst{OR_permu(k)}(removing) = [];
            end
        end
    end
end
                