function [sol_o,sol_s] = trans_math2sim(lst,NPs,sr,ss)
P = sum(NPs);
S = numel(NPs);
sr = round(sr);
ss = round(ss);
O = numel(sr)/((P+1)^2-P);
sol_s = cell(S,1);
sol_o = cell(O,1);

pre = 0;
pre_pats = 0;
for s=1:S
    if NPs(s)>0
        if sum(ss((pre+1):(pre+(NPs(s)+1)^2-NPs(s))))>1
            sol_surgeon = [];
            p_ind = find(ss((pre+1):(pre+NPs(s))));
            while p_ind<=NPs(s)
                sol_surgeon = [sol_surgeon p_ind];
                p_ind_new = find(ss((pre+p_ind*NPs(s)+2):(pre+(p_ind+1)*NPs(s)+1)));
                if p_ind_new<p_ind
                    p_ind = p_ind_new;
                else
                    p_ind = p_ind_new + 1;
                end
            end
            sol_surgeon = pre_pats + sol_surgeon;
            sol_surgeon = lst(sol_surgeon);
            sol_s{s} = sol_surgeon;
        end
    end
    pre = pre + (NPs(s)+1)^2-NPs(s);
    pre_pats = pre_pats + NPs(s);
end

pre = 0;
for o=1:O
    if sum(sr((pre+1):(pre+(P+1)^2-P)))>1
        sol_OR = [];
        p_ind = find(sr((pre+1):(pre+P)));
        while p_ind<=P
            sol_OR = [sol_OR lst(p_ind,1)];
            p_ind_new = find(sr((pre+p_ind*P+2):(pre+(p_ind+1)*P+1)));
            if p_ind_new<p_ind
                p_ind = p_ind_new;
            else
                p_ind = p_ind_new + 1;
            end
        end
        sol_o{o} = sol_OR;
    end
    pre = pre + (P+1)^2-P;
end