function [selected,b]=dataselect(output)
[s1,b]=unique(output(1,:)); % s1 value of unique cost, b indez
s2=output(2,b);             % s2 value of unique # of patients
selected(1,:)=s1;
selected(2,:)=s2;
% b is important for futur uniques

end