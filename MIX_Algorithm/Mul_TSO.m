function [Best_score, Best_pos, X] = Mul_TSO(X, Max_iterations, lowerbound, upperbound, dimension, fitness, Global_Best_pos, Global_Best_score)
    % Assume X is already provided with size [SearchAgents, dimension]
    [SearchAgents, dim] = size(X);
    
    % If the dimension of X doesn't match the input dimension, raise an error
    if dim ~= dimension
        error('Dimension of input matrix X does not match the specified dimension.');
    end

    % Follow degree
    a = 0.7;
    % Probability of random resetting
    z = 0.05;

    X = lowerbound + rand(SearchAgents, dimension) .* (upperbound - lowerbound);
    % Initialize fitness values for the provided population
    fit = zeros(SearchAgents, 1);
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
        % Update follow degrees
        C = t / Max_iterations;
        a1 = a + (1 - a) * C;
        a2 = (1 - a) * (1 - C);
        
        % Update the population
        for i = 1:SearchAgents
            % Check and correct boundary violations
            Flag4ub = X(i, :) > upperbound; % Upper bound
            Flag4lb = X(i, :) < lowerbound; % Lower bound
            X(i, :) = (X(i, :) .* ~(Flag4ub + Flag4lb)) + upperbound .* Flag4ub + lowerbound .* Flag4lb;
            
            % Update fitness
            fit(i) = fitness(X(i, :));
            
            % Update the best position if needed
            if fit(i) < Best_score
                Best_score = fit(i);
                Best_pos = X(i, :);
            end
        end
        
        % Memory saving (if necessary)
        if t == 1
            fit_old = fit;
            X_old = X;
        else
            for i = 1:SearchAgents
                if fit_old(i) < fit(i)
                    fit(i) = fit_old(i);
                    X(i, :) = X_old(i, :);
                end
            end
            X_old = X;
            fit_old = fit;
        end
        
        % Update the population based on TSO logic
        t_factor = (1 - t / Max_iterations)^(t / Max_iterations);
        
        for i = 1:SearchAgents
            if rand < z
                X(i, :) = lowerbound + rand(1, dimension) .* (upperbound - lowerbound);
            else
                if rand > 0.5
                    r1 = rand;
                    Beta = exp(r1 * exp(3 * cos(pi * (Max_iterations - t + 1) / Max_iterations))) * cos(2 * pi * r1);
                    if C > rand
                        X(i, :) = a1 * (Best_pos + Beta * abs(Best_pos - X(i, :))) + a2 * X(i, :);
                    else
                        IndivRand = lowerbound + rand(1, dimension) .* (upperbound - lowerbound);
                        X(i, :) = a1 * (IndivRand + Beta * abs(IndivRand - X(i, :))) + a2 * X(i, :);
                    end
                else
                    TF = (rand > 0.5) * 2 - 1;
                    if rand < 0.5
                        X(i, :) = Best_pos + rand(1, dimension) .* (Best_pos - X(i, :)) + TF * t_factor^2 .* (Best_pos - X(i, :));
                    else
                        X(i, :) = TF * t_factor^2 .* X(i, :);
                    end
                end
            end
        end
    end
end
