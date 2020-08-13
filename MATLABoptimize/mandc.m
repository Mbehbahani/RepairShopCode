function s = mandc(mi,ca,bo)
frontier = [mi,ca,bo,zeros(1,11)];
explored = [];
while 1==1
    node = frontier(1,:);
    if node(1:3)==[0,0,0]
        s = node(4:13);
        break
    end
    frontier(1,:) = [];
    explored = [explored; node(1:3)];
    [m,n] = size (explored);
    i = (-1)^node(3);
    c1 = [node(1)+i*1,node(2),node(3)+i,node(4:14)];
    e = zeros(1,m);
    for j = 1:m
        if any(c1(1:3)~=explored(j,:))
            e(j) = 1;
        end
    end
    if all(e) && all(c1(1:2)<=3) && all(c1(1:2)>=0) && any(c1(1:2)~=[1,2]) && any(c1(1:3)~=[1,3,0]) && any(c1(1:3)~=[0,2,1]) && any(c1(1:3)~=[3,1,0]) && any(c1(1:2)~=[2,1]) && any(c1(1:3)~=[2,0,1])
        c1(14) = c1(14)+1;
        c1(3+c1(14)) = 1;
        frontier = [frontier; c1];
    end
    c2 = [node(1)+i*2,node(2),node(3)+i,node(4:14)];
    e = zeros(1,m);
    for j = 1:m
        if any(c2(1:3)~=explored(j,:))
            e(j) = 1;
        end
    end
    if all(e) && all(c2(1:2)<=3) && all(c2(1:2)>=0) && any(c2(1:2)~=[1,2]) && any(c2(1:3)~=[1,3,0]) && any(c2(1:3)~=[0,2,1]) && any(c2(1:3)~=[3,1,0]) && any(c2(1:2)~=[2,1]) && any(c2(1:3)~=[2,0,1])
        c2(14) = c2(14)+1;
        c2(3+c2(14)) = 2;
        frontier = [frontier; c2];
    end
    c3 = [node(1),node(2)+i*1,node(3)+i,node(4:14)];
    e = zeros(1,m);
    for j = 1:m
        if any(c3(1:3)~=explored(j,:))
            e(j) = 1;
        end
    end
    if all(e) && all(c3(1:2)<=3) && all(c3(1:2)>=0) && any(c3(1:2)~=[1,2]) && any(c3(1:3)~=[1,3,0]) && any(c3(1:3)~=[0,2,1]) && any(c3(1:3)~=[3,1,0]) && any(c3(1:2)~=[2,1]) && any(c3(1:3)~=[2,0,1])
        c3(14) = c3(14)+1;
        c3(3+c3(14)) = 3;
        frontier = [frontier; c3];
    end
    c4 = [node(1),node(2)+i*2,node(3)+i,node(4:14)];
    e = zeros(1,m);
    for j = 1:m
        if any(c4(1:3)~=explored(j,:))
            e(j) = 1;
        end
    end
    if all(e) && all(c4(1:2)<=3) && all(c4(1:2)>=0) && any(c4(1:2)~=[1,2]) && any(c4(1:3)~=[1,3,0]) && any(c4(1:3)~=[0,2,1]) && any(c4(1:3)~=[3,1,0]) && any(c4(1:2)~=[2,1]) && any(c4(1:3)~=[2,0,1])
        c4(14) = c4(14)+1;
        c4(3+c4(14)) = 4;
        frontier = [frontier; c4];
    end
    c5 = [node(1)+i*1,node(2)+i*1,node(3)+i,node(4:14)];
    e = zeros(1,m);
    for j = 1:m
        if any(c5(1:3)~=explored(j,:))
            e(j) = 1;
        end
    end
    if all(e) && all(c5(1:2)<=3) && all(c5(1:2)>=0) && any(c5(1:2)~=[1,2]) && any(c5(1:3)~=[1,3,0]) && any(c5(1:3)~=[0,2,1]) && any(c5(1:3)~=[3,1,0]) && any(c5(1:2)~=[2,1]) && any(c5(1:3)~=[2,0,1])
        c5(14) = c5(14)+1;
        c5(3+c5(14)) = 5;
        frontier = [frontier; c5];
    end
end