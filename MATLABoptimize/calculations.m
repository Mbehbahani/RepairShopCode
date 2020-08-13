%%%%% % this function is written for calculating the final solution costs 
%which obtained from the simulation model.
% by M. Behbahani.
% please define every parameters precisely.
% to find out more about other input parameters please reffer to their functions
function [FMIP,rooms,VIDLE]=calculations(pop,lst,T,I,Pos,t,H,maxOV)
 
for i=1:length(lst)
    lst(i,5)=t{lst(i,2)}(lst(i,3),1);
end
  
rooms{1}=[];
count=0;
for i=1:length(pop)
    if pop(i).Rank==1  
      count=count+1;
    end
end
rnum=length(pop(1).Position1);
for i=1:count
    
    sol_o_MIP=pop(i).Position1;
    sol_s_MIP=pop(i).repair;
    % number of stations
    [f_MIP,IDLE] = sim_model(lst,T,I,Pos,t,H,sol_o_MIP,sol_s_MIP,maxOV);%rep
    FMIP(i,:)=f_MIP;
    VIDLE(i,:)=IDLE;
    rooms{i}=[sol_o_MIP];
    
%     FMIP(i,2)  %write correct car for station
    for j=1:rnum
     R(j)=sum(lst(pop(i).Position1{j},5))+...
        20*(length(pop(i).Position1{j})-1);
     rooms{i}{j}(end+1)=R(j);
    end
    rooms{i}{j+1}=FMIP(i,2);
end
%figure(2)
%FMI=FMIP';
%plot(FMI(1,:),FMI(2,:),'r*','MarkerSize',8);
% xlabel('1st Objective');
% ylabel('2nd Objective');
grid on;

end