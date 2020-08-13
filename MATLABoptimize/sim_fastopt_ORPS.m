function [f,F1] = sim_fastopt_ORPS(lst,T,I,A,Pos,t,r,H,Hmax)

%% Data Analysis
tic
[~,O] = size(Pos{1});
[S,~] = size(Pos);

%% NSGA-II Parameters

MaxIt=50;      % Maximum Number of Iterations

maxPop=50;
nPop=maxPop;        % Population Size

maxOffs=50;
nOffs=maxOffs;

pCrossover=0.6;                         % Crossover Percentage
nCrossover=2*round(pCrossover*nOffs/2);  % Number of Parnets (Offsprings)

pMutation1=0.1;                          % Mutation Percentage 1(remove or add a pat)
nMutation1=round(pMutation1*nOffs);        % Number of Mutants 1

pMutation2=0.3;                          % Mutation Percentage 2 (change permutation of an OR)
nMutation2=round(pMutation2*nOffs);        % Number of Mutants 2

%% Initialization

empty_individual.Position1=cell(O,1);
empty_individual.Position2=cell(S,1);
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
    pop(i).Position1 = random_gene(lst,A,Pos);
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
        pop(i).Position2 = trans1to2(lst,S,pop(i).Position1,t,r);
        pop(i).Cost = sim_ORPS(lst,T,I,A,Pos,t,r,H,Hmax,pop(i).Position1,pop(i).Position2,10);
    end
    i = i+1;
end

% Non-Dominated Sorting
[pop F]=NonDominatedSorting(pop);

% Calculate Crowding Distance
pop=CalcCrowdingDistance(pop,F);

% Sort Population
[pop F]=SortPopulation(pop);

%% NSGA-II Main Loop

for it=1:MaxIt
    
    rep = ceil(it/10) + 5;
    
    % Crossover
    popc=repmat(empty_individual,nCrossover/2,2);
    for k=1:nCrossover/2
        
        i1=randi([1 nPop]);
        p1=pop(i1);
        
        i2=randi([1 nPop]);
        p2=pop(i2);
        
        [popc(k,1).Position1 popc(k,2).Position1]=Crossover(p1.Position1,p2.Position1);
        
        popc(k,1).Position2=trans1to2(lst,S,popc(k,1).Position1,t,r);
        popc(k,2).Position2=trans1to2(lst,S,popc(k,2).Position1,t,r);
        
        popc(k,1).Cost=sim_ORPS(lst,T,I,A,Pos,t,r,H,Hmax,popc(k,1).Position1,popc(k,1).Position2,rep);
        popc(k,2).Cost=sim_ORPS(lst,T,I,A,Pos,t,r,H,Hmax,popc(k,2).Position1,popc(k,2).Position2,rep);
        
    end
    popc=popc(:);
    
    % Mutation 1
    popm1=repmat(empty_individual,nMutation1,1);
    for k=1:nMutation1
        
        i=randi([1 nPop]);
        p=pop(i);
        
        popm1(k).Position1=Mutate1(p.Position1,lst,A,Pos);
        
        popm1(k).Position2=trans1to2(lst,S,popm1(k).Position1,t,r);
        
        popm1(k).Cost=sim_ORPS(lst,T,I,A,Pos,t,r,H,Hmax,popm1(k).Position1,popm1(k).Position2,rep);
        
    end
    
    % Mutation 2
    popm2=repmat(empty_individual,nMutation2,1);
    for k=1:nMutation2
        
        i=randi([1 nPop]);
        p=pop(i);
        
        popm2(k).Position1=Mutate2(p.Position1);
        
        popm2(k).Position2=trans1to2(lst,S,popm2(k).Position1,t,r);
        
        popm2(k).Cost=sim_ORPS(lst,T,I,A,Pos,t,r,H,Hmax,popm2(k).Position1,popm2(k).Position2,rep);
        
    end
    
    % Merge
    pop=[pop
         popc
         popm1
         popm2];
     
    % Non-Dominated Sorting
    [pop F]=NonDominatedSorting(pop);
    
    % Calculate Crowding Distance
    pop=CalcCrowdingDistance(pop,F);

    % Sort Population
    [pop F]=SortPopulation(pop);
    
    % Truncate
    pop=pop(1:nPop);
    
    % Non-Dominated Sorting
    [pop F]=NonDominatedSorting(pop);

    % Calculate Crowding Distance
    pop=CalcCrowdingDistance(pop,F);

    % Sort Population
    [pop F]=SortPopulation(pop);
    
    % Store F1
    F1=pop(F{1});
    
    % Show Iteration Information
    disp(['Iteration ' num2str(it) ': Number of F1 Members = ' num2str(numel(F1))]);
    
    % Plot F1 Costs
    figure(1);
    PlotCosts(F1);
        drawnow;
    nF1=numel(F1);
    newnPop=min((2*nF1+20),maxPop);
    nPop=min(nPop,newnPop);
    nOffs=20;
    nCrossover=2*round(pCrossover*nOffs/2);
    nMutation1=round(pMutation1*nOffs);
    nMutation2=round(pMutation2*nOffs);
    
    % Truncate
    pop=pop(1:nPop);
    
    % Non-Dominated Sorting
    [pop F]=NonDominatedSorting(pop);

    % Calculate Crowding Distance
    pop=CalcCrowdingDistance(pop,F);

    % Sort Population
    [pop F]=SortPopulation(pop);
    
    % Store F1
    F1=pop(F{1});
    
end

f = 1;
toc
%% Results
