function p=remv(pop)
i=2;
qnty=size(pop,1);
while i<=qnty
    for j=1:i-1
        if isequal(pop(i).Position1,pop(j).Position1)
            pop(i)=[];
            i=i-1;
            break
        end
    end
    i=i+1;
    qnty=size(pop,1);
end

p=pop;
end
