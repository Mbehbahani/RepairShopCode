function  Optimizer()
% Article's code:A Multi-Objective Mixed Integer Programming for Automobile Repair Shop Scheduling; A Real Case Study
% M. Behbahani et al., 2020

% This functions is based on evolutionary algorithm for finding the optimal
% solution for multiple objective i.e. pareto front for the objectives. 
% after which the algorithm will
% automatically stopped.
% Original algorithm NSGA-II was developed by researchers in Kanpur Genetic
% Algorithm Labarotary and kindly visit their website for more information
% http://www.iitk.ac.in/kangal/

%  Copyright (c) 2020, Mohammad Behbahani (behbahanimd@gmail.com)
%  All rights reserved.
%
%  Redistribution and use in source and binary forms, with or without 
%  modification, are permitted provided that the following conditions are 
%  met:
%
%     * Redistributions of source code must retain the above copyright 
%       notice, this list of conditions and the following disclaimer.
%     * Redistributions in binary form must reproduce the above copyright 
%       notice, this list of conditions and the following disclaimer in 
%       the documentation and/or other materials provided with the distribution
%      
%  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
%  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
%  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
%  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE 
%  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
%  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
%  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
%  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
%  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
%  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
%  POSSIBILITY OF SUCH DAMAGE.


%% Data Analysis

%the trade-off relationship between the total completion time and total Idle/ Overtime costs
%and the best compromise solution shown for a specific day that its
%waiting list consists of 28 cars and 49 repair procedures.(the first case study)

% max Ov is the maximum authorized Overtime
%Columns: 1=Number, 2=kind of station 3=repair's procedure 4=car number
waitinglist=[ 1     1     2     1 
             2     2     3     1
             3     3     4     2
             4     2     3     2
             5     4     1     2
             6     1     2     3
             7     2     1     3
             8     3     7     3
             9     4     3     4
            10     1     5     5
            11     3     2     5
            12     4     7     6
            13     2     7     6
            14     1     4     7
            15     2     2     7
            16     1     1     8
            17     3     4     9
            18     1     2    10
            19     3     2    10
            20     2     6    11
            21     4     5    12
            22     2     2    12
            23     3     2    12
            24     1     3    12
            25     3     2    13
            26     1     2    14
            27     2     3    14
            28     4     4    15
            29     2     1    15
            30     1     4    16
            31     2     3    16
            32     4     4    16
            33     1     7    17
            34     2     6    18
            35     1     4    19
            36     2     4    20
            37     4     4    21
            38     2     3    22
            39     1     2    22
            40     2     2    23
            41     3     4    23
            42     4     3    24
            43     2     7    24
            44     3     3    24
            45     1     3    25
            46     4     2    26
            47     1     5    27
            48     2     4    28
            49     4     4    28];
Overtime_cost=[18;18;18;18;18;18;18;18]; %overtime cost
Idletime_cost=[12;12;12;12;12;12;12;12]; %Idletime cost
H=[7;7;7;7;7;7;7;7];         %business houres
  possibilities{1,1}=   [1     1     0     0     0     0     0     0
                         1     1     0     0     0     0     0     0
                         1     1     0     0     0     0     0     0
                         1     1     0     0     0     0     0     0
                         1     1     0     0     0     0     0     0
                         1     1     0     0     0     0     0     0
                         1     1     0     0     0     0     0     0
                         1     1     0     0     0     0     0     0
                         1     1     0     0     0     0     0     0
                         1     1     0     0     0     0     0     0
                         1     1     0     0     0     0     0     0
                         1     1     0     0     0     0     0     0];

  possibilities{2,1}=  [ 0     0     1     1     0     0     0     0
                         0     0     1     1     0     0     0     0
                         0     0     1     1     0     0     0     0
                         0     0     1     1     0     0     0     0
                         0     0     1     1     0     0     0     0
                         0     0     1     1     0     0     0     0
                         0     0     1     1     0     0     0     0
                         0     0     1     1     0     0     0     0
                         0     0     1     1     0     0     0     0
                         0     0     1     1     0     0     0     0
                         0     0     1     1     0     0     0     0
                         0     0     1     1     0     0     0     0];

    possibilities{3,1}=[0     0     0     0     1     1     0     0
                         0     0     0     0     1     1     0     0
                         0     0     0     0     1     1     0     0
                         0     0     0     0     1     1     0     0
                         0     0     0     0     1     1     0     0
                         0     0     0     0     1     1     0     0
                         0     0     0     0     1     1     0     0
                         0     0     0     0     1     1     0     0
                         0     0     0     0     1     1     0     0
                         0     0     0     0     1     1     0     0
                         0     0     0     0     1     1     0     0
                         0     0     0     0     1     1     0     0];
    possibilities{4,1}=  [0     0     0     0     0     0     1     1
                         0     0     0     0     0     0     1     1
                         0     0     0     0     0     0     1     1
                         0     0     0     0     0     0     1     1
                         0     0     0     0     0     0     1     1
                         0     0     0     0     0     0     1     1
                         0     0     0     0     0     0     1     1
                         0     0     0     0     0     0     1     1
                         0     0     0     0     0     0     1     1
                         0     0     0     0     0     0     1     1
                         0     0     0     0     0     0     1     1
                         0     0     0     0     0     0     1     1];
t{1,1} =[15; 35; 55;  75; 95; 115; 135;155; 175;195];
t{2,1} =[10; 30;60; 90;130;150; 190; 240; 300; 360];
t{3,1} =[10;25;40;60;85;110;140;180;230;300];
t{4,1} =[15;30;60;90;130;150;190;240;300;360];
maxOV=100;
tic
[~,stations] = size(possibilities{1});
[Repairmen,~] = size(possibilities);
%% NSGA-II Parameters
close all;
for kkk=1:1
MaxIt=100;      % Maximum Number of Iterations

maxPop=100;
nPop=maxPop;        % Population Size

maxOffs=MaxIt;
nOffs=maxOffs;

pCrossover=0.7;                         % Crossover Percentage
nCrossover=2*round(pCrossover*nOffs/2);  % Number of Parnets (Offsprings)

pMutation=0.3;                          % Mutation Percentage 
nMutation=round(pMutation*nOffs);        % Number of Mutants 

%% Initialization

empty_individual.Position1=cell(stations,1);
empty_individual.repair=cell(Repairmen,1);
empty_individual.Cost=[];
empty_individual.Rank=[];
empty_individual.DominationSet=[];
empty_individual.DominatedCount=[];
empty_individual.CrowdingDistance=[];

pop=repmat(empty_individual,nPop,1);

i = 1;
eq_counter = 0;
while i<=nPop
    equality = 0;
    pop(i).Position1 = random_gene(waitinglist,possibilities);
    for j=1:(i-1)
        if eq_cell(pop(i).Position1,pop(j).Position1) && eq_counter<20
            equality = 1;
            eq_counter = eq_counter + 1;
            i = i-1;
            break
        end
    end
    if equality==0
        eq_counter = 0;
        pop(i).repair = trans1to2(waitinglist,Repairmen,pop(i).Position1,t);
        pop(i).Cost = sim_model(waitinglist,Overtime_cost,Idletime_cost,possibilities,t,H,pop(i).Position1,pop(i).repair,maxOV);
    end
    i = i+1;
end

% Non-Dominated Sorting
[pop,F]=NonDominatedSorting(pop);

% Calculate Crowding Distance
pop=CalcCrowdingDistance(pop,F);

% Sort Population
[pop,~]=SortPopulation(pop);

%% NSGA-II Main Loop
tic
for it=1:MaxIt
    
    %rep = ceil(it/10) + 5;
    poolsize = round(nPop/1.5);
    parent_chromosome = tournament_selection(pop,poolsize);
    % Crossover
    popc=repmat(empty_individual,nCrossover/2,2);
    for k=1:nCrossover/2
        %similarity check
        %         p1.Position1=1;p2.Position1=1;
        i1=randi([1 poolsize]);
        p1=parent_chromosome(i1);
        i2=randi([1 poolsize]);
        p2=parent_chromosome(i2);
        
        [popc(k,1).Position1,popc(k,2).Position1]=Crossover(p1.Position1,p2.Position1);
     
        popc(k,1).repair=trans1to2(waitinglist,Repairmen,popc(k,1).Position1,t);
        popc(k,2).repair=trans1to2(waitinglist,Repairmen,popc(k,2).Position1,t);
        
        popc(k,1).Cost=sim_model(waitinglist,Overtime_cost,Idletime_cost,possibilities,t,H,popc(k,1).Position1,popc(k,1).repair,maxOV);
        popc(k,2).Cost=sim_model(waitinglist,Overtime_cost,Idletime_cost,possibilities,t,H,popc(k,2).Position1,popc(k,2).repair,maxOV);
        
    end
    popc=popc(:);

    % Mutation
    popm2=repmat(empty_individual,nMutation,1);
    for k=1:nMutation
        
        i=randi([1 nPop]);
        p=pop(i);
        
        popm2(k).Position1=Mutate(p.Position1);
         %[popc(k,1).Position1,popc(k,2).Position1]=mutate3(p1.Position1,lst,Pos);
        
        popm2(k).repair=trans1to2(waitinglist,Repairmen,popm2(k).Position1,t);
        
        popm2(k).Cost=sim_model(waitinglist,Overtime_cost,Idletime_cost,possibilities,t,H,popm2(k).Position1,popm2(k).repair,maxOV);
        
    end
    
    % Merge
    pop=[pop
        popc
        popm2];
    
    % Delete repetative chromosome
    pop=remv(pop);
    
    % Non-Dominated Sorting
    [pop,F]=NonDominatedSorting(pop);
    
    % Calculate Crowding Distance
    pop=CalcCrowdingDistance(pop,F);
    
    % Sort Population
    [pop,~]=SortPopulation(pop);
    
    % Truncate
    if size(pop,1)>nPop
        pop=pop(1:nPop);
    end
    % Non-Dominated Sorting
    [pop,F]=NonDominatedSorting(pop);
    
    % Calculate Crowding Distance
    pop=CalcCrowdingDistance(pop,F);
    
    % Sort Population
    [pop,F]=SortPopulation(pop);
    
    % Store F1
    F1=pop(F{1});
    
    % Show Iteration Information
    disp(['Iteration ' num2str(it) ': Number of F1 Members = ' num2str(numel(F1))]);
    
    % Plot F1 Costs
figure(1);
 PlotCosts(F1);
   drawnow;
    
    nF1=numel(F1);

    nCrossover=2*round(pCrossover*nOffs/2);
   % nMutation1=round(pMutation1*nOffs);
    nMutation=round(pMutation*nOffs);
    
    % Truncate
    pop=pop(1:nPop);
    
    % Non-Dominated Sorting
    [pop,F]=NonDominatedSorting(pop);
    
    % Calculate Crowding Distance
    pop=CalcCrowdingDistance(pop,F);
    
    % Sort Population
    [pop,F]=SortPopulation(pop);
    
    % Store F1
    F1=pop(F{1});
    points=[F1.Cost];
    points1(it,1:size(points,2))=sort(points(1,:),'descend');
    points2(it,1:size(points,2))=sort(points(2,:));
    points=[];
    hold off
end
time=toc
f = 1;
%% Results
figure(kkk+1)
% define the mode(1 or 2)? % mode 2 means the same skills
[FMIP,rooms,IDLE]=calculations(pop,waitinglist,Overtime_cost,Idletime_cost,possibilities,t,H,maxOV);
% FMIP=FMIP;
FMIP(:,1)=round(FMIP(:,1)*2,-1)/2; 
unarrange=FMIP';
FMIP(:,1)=sort(FMIP(:,1),'descend');
FMIP(:,2)=sort(FMIP(:,2));
IDLE=sort(IDLE);
points1(end+1,1:size(FMIP,1))=sort(FMIP(:,1),'descend');
points2(end+1,1:size(FMIP,1))=sort(FMIP(:,2));
FMIP=FMIP'; % FMIP(1,:) is completion time
plot(FMIP(1,:),FMIP(2,:),'-','Marker','o','MarkerSize',8,'LineWidth',2);
h1=area(FMIP(1,:),FMIP(2,:),'LineStyle','-','LineWidth',1);
h1(1).FaceColor = [0.8 0.8 1];
hold on
hh=area(FMIP(1,:),IDLE','LineStyle','-','LineWidth',1);
hh(1).FaceColor = [1 0.8 0.8];

s1 = scatter(FMIP(1,:),FMIP(2,:),[],[0.3 0.3 1],'MarkerFaceColor','k');
s1.Marker = 'o';
s1.LineWidth=2;

s2 = scatter(FMIP(1,:),IDLE',[],[1 0.3 0.3],'MarkerFaceColor','k');
s2.Marker = 'o';
s2.LineWidth=2;
xlabel('Total Completion Time(min)');
ylabel('Total Idle/Over Time Costs($)');
%%%Best Compromise Solution
% plot
ta = annotation('textarrow',[0.7,0.6],[0.9,0.8]);
ta.String = 'Best Compromise Solution '; 
%calculations
best=bestcpoint(FMIP);
% select best compromise point
plot(best(1),best(2),'o','MarkerSize',10,'MarkerEdgeColor','red');

grid on;
end
end
