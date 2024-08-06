function [Best_score, Best_pos, MIX_curve] = MIX(SearchAgents, Max_iterations, lowerbound, upperbound, dimension, fitness)
    
    % 变量下界初始化
    lowerbound = ones(1, dimension) .* lowerbound;
    % 变量上界初始化
    upperbound = ones(1, dimension) .* upperbound;
    % 预分配MIX曲线
    MIX_curve = zeros(1, Max_iterations);
    % 预分配种群适应度数组
    fit = zeros(SearchAgents, 1);

    %% 初始化
    % Generate initial population
    %X = lowerbound + rand(SearchAgents, dimension) .* (upperbound - lowerbound);
    % 把粒子的初始化从随机分布改为高斯分布
    X = lowerbound + (upperbound - lowerbound) .* randn(SearchAgents, dimension);

    % Calculate initial fitness values
    for i = 1:SearchAgents
        fit(i) = fitness(X(i, :));
    end

    %% 主循环
    for t = 1:Max_iterations
        %% 更新最佳候选解
        [best, location] = min(fit);
        % 初始化最优位置和最优目标函数值
        if t == 1
            Xbest = X(location, :);  % 最优位置
            fbest = best;            % 优化目标函数值
        elseif best < fbest
            fbest = best;
            Xbest = X(location, :);
        end

        % Divide population and apply different algorithms
        [Best_score_HO, Best_pos_HO, X_HO] = Mul_HO(X(1:floor(SearchAgents / 3), :), 10, lowerbound, upperbound, dimension, fitness, Xbest, fbest);
        [Best_score_TLBO, Best_pos_TLBO, X_TLBO] = Mul_TLBO(X(floor(SearchAgents / 3) + 1:floor(2 * SearchAgents / 3), :), 10, lowerbound, upperbound, dimension, fitness, Xbest, fbest);
        [Best_score_TSO, Best_pos_TSO, X_TSO] = Mul_TSO(X(floor(2 * SearchAgents / 3) + 1:SearchAgents, :), 50, lowerbound, upperbound, dimension, fitness, Xbest, fbest);

        % Combine results from different algorithms
        X = [X_HO; X_TLBO; X_TSO];
        
        % Update best score and position
        Best_score = min([Best_score_HO, Best_score_TLBO, Best_score_TSO]);
        if Best_score < fbest
            fbest = Best_score;
            if Best_score == Best_score_HO
                Xbest = Best_pos_HO;
            elseif Best_score == Best_score_TLBO
                Xbest = Best_pos_TLBO;
            else
                Xbest = Best_pos_TSO;
            end
        end

        % Update the population with the best position found
        X(location, :) = Xbest;

        % Record the best score
        MIX_curve(t) = Best_score;

        % Increase population diversity
        X = X(randperm(SearchAgents), :);

        % Display the result of the current iteration
        disp(['MIX Iteration ' num2str(t) ': Best Cost = ' num2str(Best_score)]);
    end

    % Return the best score and position
    Best_pos = Xbest;
end
