function [Best_score, Best_pos, MIX_curve] = MIX(SearchAgents, Max_iterations, lowerbound, upperbound, dimension, fitness)
    
    % 变量下界初始化
    lowerbound = ones(1,dimension).*(lowerbound);
    % 变量上界初始化
    upperbound = ones(1,dimension).*(upperbound);
    % 预分配MIX曲线
    MIX_curve = zeros(1, Max_iterations);
    % 预分配种群适应度数组
    fit = zeros(SearchAgents, 1);

    %% 初始化
    for i = 1:dimension
        % 初始种群生成
        X(:,i) = lowerbound(i) + rand(SearchAgents,1).*(upperbound(i)-lowerbound(i));
    end

    % 计算初始种群的适应度值
    for i = 1:SearchAgents
        L = X(i,:);
        fit(i) = fitness(L);
    end

    %% 主循环
    for t = 1 : Max_iterations
        %% 更新最佳候选解
        [best,location] = min(fit);
        % 初始化最优位置和最优目标函数值
        if t == 1
            Xbest = X(location,:);  % 最优位置
            fbest = best;           % 优化目标函数值
        elseif best < fbest
            fbest = best;
            Xbest = X(location,:);
        end
        [Best_score_HO, Best_pos_HO, X_HO] = Mul_HO(X(1:floor(SearchAgents / 3), :), 1, lowerbound, upperbound, dimension, fitness);
        [Best_score_TLBO, Best_pos_TLBO, X_TLBO] = Mul_TLBO(X(floor(SearchAgents / 3) + 1:floor(2 * SearchAgents / 3), :), 1, lowerbound, upperbound, dimension, fitness);
        [Best_score_TSO, Best_pos_TSO, X_TSO] = Mul_TSO(X(floor(2 * SearchAgents / 3) + 1:SearchAgents, :), 1, lowerbound, upperbound, dimension, fitness);
        X = [X_HO; X_TLBO; X_TSO];
        % 根据返回的最优位置和最优目标函数值更新最优位置和最优目标函数值
        Best_score = min([Best_score_HO, Best_score_TLBO, Best_score_TSO]);
        if Best_score < fbest
            fbest = Best_score;
            Xbest = Best_pos;
        end
        % 将更新的最优值对应的最优位置更新
        if Best_score_HO == Best_score
            X(location, :) = Best_pos_HO;
        elseif Best_score_TLBO == Best_score
            X(location, :) = Best_pos_TLBO;
        else
            X(location, :) = Best_pos_TSO;
        end
        MIX_curve(t) = Best_score;
        Best_pos = Xbest;
        % 随机交换不同的行，使得种群多样性增加
        X = X(randperm(SearchAgents), :);
        disp(['MIX第', num2str(t), '次迭代的最优成本是 : ', num2str(Best_score)]);
    end
end