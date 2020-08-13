function [Nstart,Nfinish]=shift_operator(sor,start,finish,j,k,sol_station,H)
global IDL Last_Finish 

a=abs(start(sor(j))-finish(sor(k)));
b=abs(start(sor(k))-finish(sor(j)));

if a<=b
    shift=a;
    for i=1:length(sol_station)
        if ismember(sor(j),sol_station{i})
            [~,item]=ismember(sor(j),sol_station{i});
            Target_station=i;
            break
        end
    end
else
    shift=b;
    for i=1:length(sol_station)
        if ismember(sor(k),sol_station{i})
            [~,item]=ismember(sor(k),sol_station{i});
            Target_station=i;
            break
        end
    end  
end
% from "sol_station" you can find the target repair position position
% Add Ide to the next start and finish of next repairs.

Nstart=start;
Nfinish=finish;
%Shifting
i=Target_station;
IDL(i)=IDL(i)+shift;
for j=item:size(sol_station{i},2)-1
    Nfinish(sol_station{i}(j))=finish(sol_station{i}(j))+shift;
    Nstart(sol_station{i}(j))=start(sol_station{i}(j))+shift;
end

% end of the finish %calculate overtime here
j=size(sol_station{i},2);
if j~=0
    Nfinish(sol_station{i}(j))=finish(sol_station{i}(j))+shift;
    Nstart(sol_station{i}(j))=start(sol_station{i}(j))+shift;
    Last_Finish(i)=Nfinish(sol_station{i}(j));
      %%%% please define Idle if it would be less than (H)
end




end