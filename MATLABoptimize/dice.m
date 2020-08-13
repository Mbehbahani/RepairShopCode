function [pairs_q,pair6,sum7,meansum] = dice(n)
pairs = zeros(6,1);
sum7 = 0;
meansum = 0;
for i=1:n
    x = ceil(rand(1,2)*6);
    if x(1)==x(2)
        pairs(x(1)) = pairs(x(1)) + 1;
    end
    s = x(1) + x(2);
    if s==7
        sum7 = sum7 + 1;
    end
    meansum = meansum + s/n;
end
pairs_q = sum(pairs);
pair6 = pairs(6);
pairs_notpair = [pairs; n-pairs_q];
pie(pairs_notpair,{'pair 1','pair 2','pair 3','pair 4','pair 5','pair 6','not pair'});