function [y1,y2]=Crossover(x1,x2)
[O,~] = size(x1);

% % % % c=[];
% % % % for i=1:4
% % % % c=[c,max(find(Pos{i}(1,:)==1))];
% % % % end
% % % % crash = randi(4);
% % % % crash=c(crash);

crash = ceil((O-1)*rand);
y1(1:crash) = x1(1:crash);
y1((crash+1):O) = x2((crash+1):O);
y2(1:crash) = x2(1:crash);
y2((crash+1):O) = x1((crash+1):O);
for i=1:crash
    nPat = numel(y1{i});
    for j=1:nPat
        for k=(crash+1):O
            repeated = find(y1{k}==y1{i}(j));
            if repeated
                r = rand;
                if r<0.5
                    y1{i}(j) = 0;
                else
                    y1{k}(repeated) = 0;
                end
            end
        end
    end
end
newy1 = cell(O,1);
for i=1:O
    nPat = numel(y1{i});
    for j=1:nPat
        if y1{i}(j)>0
            newy1{i} = [newy1{i} y1{i}(j)];
        end
    end
end
y1 = newy1;
for i=1:crash
    nPat = numel(y2{i});
    for j=1:nPat
        for k=(crash+1):O
            repeated = find(y2{k}==y2{i}(j));
            if repeated
                r = rand;
                if r<0.5
                    y2{i}(j) = 0;
                else
                    y2{k}(repeated) = 0;
                end
            end
        end
    end
end
newy2 = cell(O,1);
for i=1:O
    nPat = numel(y2{i});
    for j=1:nPat
        if y2{i}(j)>0
            newy2{i} = [newy2{i} y2{i}(j)];
        end
    end
end
y2 = newy2;
end