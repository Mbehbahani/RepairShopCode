function PlotCosts(pop)

    Costs=[pop.Cost];
    
    plot(Costs(1,:),Costs(2,:),'r*','MarkerSize',8);
   % plot(Costs(1,:),Costs(2,:),'-','Marker','o','MarkerSize',8,'LineWidth',3);
    xlabel('Completion Time');
    ylabel('Over/Idle Costs');
    grid on;

end