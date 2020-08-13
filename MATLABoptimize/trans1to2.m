function P2 = trans1to2(waiting,S,position,time)
[O,~] = size(position);
P2 = cell(S,1);
to = zeros(O,1);
ts = zeros(S,1);
fake_P1 = position;
empties = 0;
while empties<O
    empties = 0;
    station = [];
    can = 10000;
    for o=1:O
        if fake_P1{o}
            if to(o)<can
                station = o;
                can = to(o);
            elseif to(o)==can
                repair = waiting(find(waiting(:,1)==fake_P1{o}(1)),2);
                repair_candid = waiting(find(waiting(:,1)==fake_P1{station}(1)),2);
                no = waiting(find(waiting(:,1)==fake_P1{o}(1)),3);
                no_candid = waiting(find(waiting(:,1)==fake_P1{station}(1)),3);
                if repair==repair_candid
                    station = o;
                    can = to(o);
                end
            end
        else
            empties = empties + 1;
        end
    end
    if station
        repair = waiting(find(waiting(:,1)==fake_P1{station}(1)),2);
        no = waiting(find(waiting(:,1)==fake_P1{station}(1)),3);
        to(station) = max(to(station),ts(repair)) + mean(time{repair}(no,:));
        ts(repair) = to(station) ;
        P2{repair} = [P2{repair} fake_P1{station}(1)];
        fake_P1{station}(1) = [];
    end
end