function y=Mutate(x)
[O,~] = size(x);
y = x;
sze=0;
while sze<2
i = ceil(O*rand);
sze=length(x{i});
end
% change the position of two chromosome in a station By M.Behbahani
% just select 2 of them

a=zeros(1,2);

j=1;
while j<=2
    s=randi(sze);
    if ismember(s,a)==0
        a(1,j)=s;
        j=j+1;
    end    
end
sorted=sort(a);

y{i}(sorted) = x{i}([sorted(2),sorted(1)]);
end