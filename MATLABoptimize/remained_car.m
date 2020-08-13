function [remained,unrepaired_list]=remained_car(lst,sol)
d=[];
unrepaired=[];
unrepaired_list=[];
remained=[];
for i=1:size(sol,1)
    d=horzcat(d,sol(i));
end
repaired=cell2mat(d);

for i=1:size(lst)
    if ismember(i,repaired)==0
        unrepaired=[unrepaired,lst(i,4)]; % for car
        unrepaired_list=[unrepaired_list,lst(i,1)]; %for list
    end
end
if isempty(unrepaired)~=1
    remained=unique(unrepaired);
end
end