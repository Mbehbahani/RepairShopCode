function f = tournament_selection(pop,pool_size)
npop=length(pop);


for i = 1 : pool_size
    for j = 1 : 2
        candidate(j) = round(npop*rand(1));
        if candidate(j) == 0
            candidate(j) = 1;
        end
    end
    % Collect information about the selected candidates.
    for j = 1 : 2
        c_obj_rank(j) = pop(candidate(j)).Rank;
        c_obj_distance(j) = pop(candidate(j)).CrowdingDistance;
    end
    
    
    % Find the candidate with the least rank
    min_candidate = ...
        find(c_obj_rank == min(c_obj_rank));
    % If more than one candiate have the least rank then find the candidate
    % within that group having the maximum crowding distance.
    if length(min_candidate) > 1
        max_candidate = ...
            find(c_obj_distance(min_candidate) == max(c_obj_distance(min_candidate)));
        
        if isempty(max_candidate)
            max_candidate=1;
            
        elseif length(max_candidate) > 1
            max_candidate = max_candidate(1);
        end
        % Add the selected individual to the mating pool
        f(i,:) = pop(candidate(min_candidate(max_candidate)));
    else
        % Add the selected individual to the mating pool
        f(i,:) = pop(candidate(min_candidate(1)));
    end
    
end


end