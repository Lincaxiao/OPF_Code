function [Best_score, Best_pos, X] = Mul_TLBO(X, Max_iterations, lowerbound, upperbound, dimension, fitness, Global_Best_pos, Global_Best_score)
    % Assume X is already provided with size [SearchAgents, dimension]
    [SearchAgents, dim] = size(X);
    
    % If the dimension of X doesn't match the input dimension, raise an error
    if dim ~= dimension
        error('Dimension of input matrix X does not match the specified dimension.');
    end

    % Initialize lower and upper bounds as vectors
    lowerbound = ones(1, dimension) .* lowerbound;
    upperbound = ones(1, dimension) .* upperbound;
    
    X = lowerbound + rand(SearchAgents, dimension) .* (upperbound - lowerbound);
    % Initialize fitness values for the provided population
    for i = 1:SearchAgents
        fit(i) = fitness(X(i, :));
    end
    % 将适应度最高的个体替换为全局最优个体
    [temp, location] = max(fit);
    X(location, :) = Global_Best_pos;
    fit(location) = Global_Best_score;

    % Initialize best position and score
    [Best_score, best_idx] = min(fit);
    Best_pos = X(best_idx, :);
    
    % Main loop
    for t = 1:Max_iterations
        %% Update the best candidate solution
        [best, location] = min(fit);
        
        if best < Best_score
            Best_score = best;
            Best_pos = X(location, :);
        end

        %% Teaching phase
        % The teacher is the best individual in the population
        Teacher = Best_pos;
        % Class mean
        Mean_X = mean(X);
        
        % Students update their positions based on the teacher and class mean
        for i = 1:SearchAgents
            % Generate random number
            r = rand;
            % Teaching factor, randomly determined as 1 or 2
            TF = randi([1, 2]);
            % Update position
            X(i, :) = X(i, :) + r * (Teacher - TF * Mean_X);
            % Boundary handling
            X(i, :) = min(max(X(i, :), lowerbound), upperbound);
            % Update fitness value
            fit(i) = fitness(X(i, :));
            if fit(i) < Best_score
                Best_pos = X(i, :);
                Best_score = fit(i);
            end
        end

        %% Learning phase
        % Randomly select two individuals
        for i = 1:SearchAgents
            r1 = randi([1, SearchAgents]);
            r2 = randi([1, SearchAgents]);
            while r1 == r2
                r2 = randi([1, SearchAgents]);
            end
            
            if fit(r1) < fit(r2)
                % r2 learns from r1
                X(r2, :) = X(r2, :) + rand * (X(r1, :) - X(r2, :));
                X(r2, :) = min(max(X(r2, :), lowerbound), upperbound);
                fit(r2) = fitness(X(r2, :));
                if fit(r2) < Best_score
                    Best_pos = X(r2, :);
                    Best_score = fit(r2);
                end
            else
                % r1 learns from r2
                X(r1, :) = X(r1, :) + rand * (X(r2, :) - X(r1, :));
                X(r1, :) = min(max(X(r1, :), lowerbound), upperbound);
                fit(r1) = fitness(X(r1, :));
                if fit(r1) < Best_score
                    Best_pos = X(r1, :);
                    Best_score = fit(r1);
                end
            end
        end
    end
end
