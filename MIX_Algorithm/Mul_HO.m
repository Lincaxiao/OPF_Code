function [Best_score, Best_pos, X] = Mul_HO(X, Max_iterations, lowerbound, upperbound, dimension, fitness,...
                                            Global_Best_pos, Global_Best_score)
    % Assume X is already provided with size [SearchAgents, dimension]
    [SearchAgents, dim] = size(X);
    
    % If the dimension of X doesn't match the input dimension, raise an error
    if dim ~= dimension
        error('Dimension of input matrix X does not match the specified dimension.');
    end

    % Initialize lower and upper bounds as vectors
    lowerbound = ones(1, dimension) .* lowerbound;
    upperbound = ones(1, dimension) .* upperbound;
    

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

        %% First Phase: Hippos in rivers or ponds (exploration)
        for i = 1:SearchAgents/2
            Dominant_hippopotamus = Best_pos;
            I1 = randi([1, 2], 1, 1);
            I2 = randi([1, 2], 1, 1);
            Ip1 = randi([0, 1], 1, 2);
            RandGroupNumber = randperm(SearchAgents, 1);
            RandGroup = randperm(SearchAgents, RandGroupNumber);
            MeanGroup = mean(X(RandGroup, :)) .* (length(RandGroup) ~= 1) + X(RandGroup(1, 1), :) * (isscalar(RandGroup));
            
            Alfa{1, :} = (I2 * rand(1, dimension) + (~Ip1(1)));
            Alfa{2, :} = 2 * rand(1, dimension) - 1;
            Alfa{3, :} = rand(1, dimension);
            Alfa{4, :} = (I1 * rand(1, dimension) + (~Ip1(2)));
            Alfa{5, :} = rand;
            A = Alfa{randi([1, 5]), :};
            B = Alfa{randi([1, 5]), :};
            
            X_P1(i, :) = X(i, :) + rand(1, 1) .* (Dominant_hippopotamus - I1 .* X(i, :));
            T = exp(-t / Max_iterations);
            if T > 0.6
                X_P2(i, :) = X(i, :) + A .* (Dominant_hippopotamus - I2 .* MeanGroup);
            else
                if rand() > 0.5
                    X_P2(i, :) = X(i, :) + B .* (MeanGroup - Dominant_hippopotamus);
                else
                    X_P2(i, :) = ((upperbound - lowerbound) * rand + lowerbound);
                end
            end
            
            X_P2(i, :) = min(max(X_P2(i, :), lowerbound), upperbound);
            X_P1(i, :) = min(max(X_P1(i, :), lowerbound), upperbound);
            
            F_P1(i) = fitness(X_P1(i, :));
            if F_P1(i) < fit(i)
                X(i, :) = X_P1(i, :);
                fit(i) = F_P1(i);
            end
            
            F_P2(i) = fitness(X_P2(i, :));
            if F_P2(i) < fit(i)
                X(i, :) = X_P2(i, :);
                fit(i) = F_P2(i);
            end
        end

        %% Second Phase: Hippos defend from predators (exploration)
        for i = 1 + SearchAgents/2 : SearchAgents
            predator = lowerbound + rand(1, dimension) .* (upperbound - lowerbound);
            F_HL = fitness(predator);
            distance2Leader = abs(predator - X(i, :));
            b = unifrnd(2, 4, [1, 1]);
            c = unifrnd(1, 1.5, [1, 1]);
            d = unifrnd(2, 3, [1, 1]);
            l = unifrnd(-2 * pi, 2 * pi, [1, 1]);
            RL = 0.05 * levy(SearchAgents, dimension, 1.5);
            
            if fit(i) > F_HL
                X_P3(i, :) = RL(i, :) .* predator + (b ./ (c - d .* cos(l))) .* (1 ./ distance2Leader);
            else
                X_P3(i, :) = RL(i, :) .* predator + (b ./ (c - d .* cos(l))) .* (1 ./ (2 .* distance2Leader + rand(1, dimension)));
            end
            
            X_P3(i, :) = min(max(X_P3(i, :), lowerbound), upperbound);
            
            F_P3(i) = fitness(X_P3(i, :));
            if F_P3(i) < fit(i)
                X(i, :) = X_P3(i, :);
                fit(i) = F_P3(i);
            end
        end

        %% Third Phase: Hippos escape from predators (exploitation)
        for i = 1:SearchAgents
            LO_LOCAL = (lowerbound ./ t);
            HI_LOCAL = (upperbound ./ t);
            Alfa{1, :} = 2 * rand(1, dimension) - 1;
            Alfa{2, :} = rand(1, 1);
            Alfa{3, :} = randn;
            D = Alfa{randi([1, 3]), :};
            
            X_P4(i, :) = X(i, :) + (rand(1, 1)) .* (LO_LOCAL + D .* (HI_LOCAL - LO_LOCAL));
            X_P4(i, :) = min(max(X_P4(i, :), lowerbound), upperbound);
            
            F_P4(i) = fitness(X_P4(i, :));
            if F_P4(i) < fit(i)
                X(i, :) = X_P4(i, :);
                fit(i) = F_P4(i);
            end
        end
    end
end