function [f,VIDLE,start,finish] = sim_model(lst,T,I,Pos,t,H,sol_station,sol_repair,maxOV)
%check all of the final start and finish times.
global IDL OVER Last_Finish
for i=1:size(lst)
    lst(i,5)=t{lst(i,2)}(lst(i,3),1);
end

rep=1;
VIDLE=[];
f = zeros(rep,1);
%[P,~] = size(lst);
[O,~] = size(sol_station);
IDL=zeros(O,1); OVER=IDL; Last_Finish=IDL;
[S,~] = size(sol_station);
h = zeros(S,1);
fsol = sol_station;
scheduled = 0;
%%% station checked
for j=1:O
    while fsol{j}
        scheduled = scheduled + 1;
        Repairman  = lst(find(lst(:,1)==fsol{j}(1)),2);
        no = lst(find(lst(:,1)==fsol{j}(1)),3);
        number = fsol{j}(1);
        if (Pos{Repairman}(no,j)==0)
            f = [100000000000 100000000000];
            break
        end
        h(Repairman) = h(Repairman) +lst(number,5);
        fsol{j}(1) = [];
    end
end


% station limitation
staition_time = myconstraint(lst,sol_station);
%tar_con = sum(constraint1(lst,T,I,A,Pos,t,r,H,Hmax,sol_station,sol_repair));
if any(staition_time>(H+maxOV)*60)
    f = [100000000000 100000000000];
end

%checking each car time window and limitation(constraint2)
[start,finish]=time_window(lst,sol_station);
%%%%define basic Idle and Over time here.
cars=unique(lst(:,4));
i=1;
while i<=size(cars,1)
%for i=1:size(cars,1)
    set_of_repairs=(find(lst(:,4)==i));
    sor=set_of_repairs;
    for j=1:size(sor,1) 
        k=1;
            while k<=size(sor,1)
                if  start(sor(j))<=start(sor(k)) && j~=k && (start(sor(k))~=0||finish(sor(k))~=0)
                    if finish(sor(j))>start(sor(k))
                        [start,finish]=shift_operator(sor,start,finish,j,k,sol_station,H);
                        k=0;
                       i=0;
                        if any(finish>(H(1)+maxOV(1))*60)  %Room Time constraint
                            f = [10^9,10^9];
                            break
                        end
                    end
                end
                k=k+1;
            end
    end
%end
i=i+1;
end


%Time calculator
time=0;
penalty=0;
% you should consider only repaired car
[RC]=remained_car(lst,sol_repair);
for i=1:size(RC,2)
    if size(RC)~=0
        cars(cars==RC(i))=[];
    end
end
%%% penalty for remained cars
for i=1:size(RC,2)
    if size(RC)~=0
        set_of_unrepairs=(find(lst(:,4)==RC(i)));
        sour=lst(set_of_unrepairs,1);
        penalty=penalty+sum(lst(sour,5));
    end
end

if penalty>0
    f = [10^9,10^9];
end

if sum(f)==0
    for ii=1:rep
        %%%for time
        if isempty(size(cars,1))==0
            for i=1:size(cars,1)
                set_of_repairs=(find(lst(:,4)==cars(i)));
                sor=lst(set_of_repairs,1);
                st=min(start(sor));
                fn=max(finish(sor));
                time=time+(fn-st);
            end
        end
        
        
        %IDL&OVER Times
        for i=1:O
            OVER_IDL=(H(1)*60)-Last_Finish(i);
            if OVER_IDL>0
                IDL(i)=IDL(i)+OVER_IDL;
            else
                OVER(i)=abs(OVER_IDL);
            end
        end
        
        
        if  sum(f)>100000000000
            
            break
        else
            f(ii) = time+5000*penalty;
        end
    end
    if sum(f)<200000000000
        f = mean(f);
        IDL=IDL.*(I/60);
        OVER=OVER.*(T/60);
        Tidle=sum(IDL);
        Tover=sum(OVER);
        f = [f Tidle+Tover];
        VIDLE=[VIDLE Tidle];               %the vector of Idles
        %for remained car as a objective
        %   f = [f size(remained_car(lst,sol_repair),2)];
    end
else
    f=[10^6,10^6];
end
f = f';
end
