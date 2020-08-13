function r = search(f,n)
s1 = size(f);
r0 = find(f==n);
r2 = ceil(r0/s1(1));
s2 = size(r2);
r1 = zeros(s2(1),1);
if s2(1)>0
    for i=1:s2(1)
        if r2(i)==(r0(i)/s1(1))
            r1(i) = s1(1);
        else
            r1(i) = r0(i) - floor(r0(i)/s1(1))*s1(1);
        end
    end
end
r = [r1 r2];