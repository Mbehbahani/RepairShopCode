function [start,finish]=time_window(lst,sol_station)
global Last_Finish
% determine the deterministic time for repair
%be careful you should determine appropriate time
[stations,~]=size(sol_station);

start=zeros(size(lst,1),1)';
finish=zeros(size(lst,1),1)';
for i=1:stations
    for j=1:size(sol_station{i},2)-1
      finish(sol_station{i}(j))=start(sol_station{i}(j))+lst(sol_station{i}(j),5);
      start(sol_station{i}(j+1))=finish(sol_station{i}(j));       
    end
end 
% end of the finish
for i=1:stations
      j=size(sol_station{i},2);
      if j~=0
      finish(sol_station{i}(j))=start(sol_station{i}(j))+lst(sol_station{i}(j),5);
      Last_Finish(i)=finish(sol_station{i}(j));
      end
end 
    
end
