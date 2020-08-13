function staition_time = myconstraint(lst,sol_station)
[stations,~]=size(sol_station);
staition_time=zeros(stations,1);
for i=1:stations
    for j=1:size(sol_station{i},2)
        staition_time(i)=staition_time(i)+lst(sol_station{i}(j),5);      
    end
end

end
