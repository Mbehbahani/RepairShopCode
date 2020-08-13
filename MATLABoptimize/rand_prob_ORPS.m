function lst = rand_prob_ORPS(entrance,A,t,r)
ent_d = 1;
lst = [];
ind = 1;
[S,~] = size(A);
for s=1:S
    [types,~] = size(t{s});
    for tp=1:types
        no_pat = random('poiss',(ent_d/20)*entrance{s}(tp));
        serg_dur = mean(t{s}(tp,:));
        reco_dur = mean(r{s}(tp,:));
        for pat=1:no_pat
            lst = [lst; ind s tp serg_dur reco_dur];
            ind = ind + 1;
        end
    end
end