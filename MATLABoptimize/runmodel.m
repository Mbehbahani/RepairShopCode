function [data]=runmodel(lst,T,I,Pos,t,H,tm)
format compact

for i=1:tm
    %[~,~,~,FMIP,rooms,time,unarrange] = sim_fastopt_ORPS_new2(lst,T,I,A,Pos,t,r,H,Hmax,intable);
    [~,~,~,FMIP,rooms,time,unarrange] = Optimizer(lst,T,I,Pos,t,H,100);
    
    data(i).a=[rooms,unarrange,FMIP,time];
    figure(2)
    Markers = {'+','o','*','x','v','d','^','s','>','<'};
    
    hold on

    plot(FMIP(1,:),FMIP(2,:),'-','Marker',Markers{i},'MarkerSize',8,'LineWidth',3);
    
    
    drawnow;
    xlabel('1st Objective');
    ylabel('2nd Objective');
    grid on;
    i
    dataselect(FMIP)
    [data(i).sel,index]=dataselect(FMIP); % for unique costs and # of patients
   
    sols=data(i).a;
    data(i).solution=sols(index);
    
end
legend('1','2','3','4','5','6','7','8','9','10')

% data(1).MaxIt=50;
% data(1).maxPop=50;
end