%% 由Mohammad Hussien Amiri和Nastaran Mehrabi Hashjin设计和开发
function [Best_score, Best_pos, HO_curve] = HO(SearchAgents, Max_iterations, lowerbound, upperbound, dimension, fitness)

    % 变量的下界初始化
    lowerbound = ones(1, dimension) .* (lowerbound);
    % 变量的上界初始化
    upperbound = ones(1, dimension) .* (upperbound);
    
    %% 初始化
    for i = 1:dimension
        % 初始种群生成
        X(:, i) = lowerbound(i) + rand(SearchAgents, 1) .* (upperbound(i) - lowerbound(i));
    end
    
    % 计算初始种群的适应度值
    for i = 1:SearchAgents
        L = X(i, :);
        fit(i) = fitness(L);
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
    
        %% 第一阶段：河马在河流或池塘中的位置更新（探索）
        for i = 1:SearchAgents/2
            % 定义优势河马的位置
            Dominant_hippopotamus = Xbest;
            % 随机生成一些用于更新位置的变量
            I1 = randi([1, 2], 1, 1);
            I2 = randi([1, 2], 1, 1);
            Ip1 = randi([0, 1], 1, 2);
            % 随机选择一个小组
            RandGroupNumber = randperm(SearchAgents, 1);
            RandGroup = randperm(SearchAgents, RandGroupNumber);
    
            % 计算随机小组的均值位置
            MeanGroup = mean(X(RandGroup, :)) .* (length(RandGroup) ~= 1) + X(RandGroup(1, 1), :) * (length(RandGroup) == 1);
            % 生成用于位置更新的随机因子
            Alfa{1,:} = (I2 * rand(1, dimension) + (~Ip1(1)));
            Alfa{2,:} = 2 * rand(1, dimension) - 1;
            Alfa{3,:} = rand(1, dimension);
            Alfa{4,:} = (I1 * rand(1, dimension) + (~Ip1(2)));
            Alfa{5,:} = rand;
            % 随机选择因子A和B
            A = Alfa{randi([1, 5]), :};
            B = Alfa{randi([1, 5]), :};
            % 更新位置X_P1
            X_P1(i, :) = X(i, :) + rand(1, 1) .* (Dominant_hippopotamus - I1 .* X(i, :));
            % 根据迭代次数调整探索程度
            T = exp(-t / Max_iterations);
            if T > 0.6
                % 当T大于0.6时，使用A因子更新位置
                X_P2(i, :) = X(i, :) + A .* (Dominant_hippopotamus - I2 .* MeanGroup);
            else
                % 当T小于等于0.6时，随机选择使用A或B因子更新位置
                if rand() > 0.5
                    X_P2(i, :) = X(i, :) + B .* (MeanGroup - Dominant_hippopotamus);
                else
                    X_P2(i, :) = ((upperbound - lowerbound) * rand + lowerbound);
                end
            end
            % 确保更新后的位置在界限内
            X_P2(i, :) = min(max(X_P2(i, :), lowerbound), upperbound);
            X_P1(i, :) = min(max(X_P1(i, :), lowerbound), upperbound);  % ???????
            % 计算X_P1的适应度
            L = X_P1(i, :);
            F_P1(i) = fitness(L);
            % 如果X_P1的适应度更好，则更新位置和适应度值
            if F_P1(i) < fit(i)
                X(i, :) = X_P1(i, :);
                fit(i) = F_P1(i);
            end
    
            % 计算X_P2的适应度
            L2 = X_P2(i, :);
            F_P2(i) = fitness(L2);
            % 如果X_P2的适应度更好，则更新位置和适应度值
            if F_P2(i) < fit(i)
                X(i, :) = X_P2(i, :);
                fit(i) = F_P2(i);
            end
        end
    
        %% 第二阶段：河马防御捕食者（探索）
        for i = 1 + SearchAgents/2 : SearchAgents
            % 随机生成捕食者位置
            predator = lowerbound + rand(1, dimension) .* (upperbound - lowerbound);
            L = predator;
            F_HL = fitness(L);
            % 计算捕食者与河马的距离
            distance2Leader = abs(predator - X(i, :));
            % 生成用于位置更新的随机因子
            b = unifrnd(2, 4, [1, 1]);
            c = unifrnd(1, 1.5, [1, 1]);
            d = unifrnd(2, 3, [1, 1]);
            l = unifrnd(-2 * pi, 2 * pi, [1, 1]);
            % 生成Levy飞行随机向量
            RL = 0.05 * levy(SearchAgents, dimension, 1.5);
    
            % 根据适应度值更新河马位置
            if fit(i) > F_HL
                X_P3(i, :) = RL(i, :) .* predator + (b ./ (c - d .* cos(l))) .* (1 ./ distance2Leader);
            else
                X_P3(i, :) = RL(i, :) .* predator + (b ./ (c - d .* cos(l))) .* (1 ./ (2 .* distance2Leader + rand(1, dimension)));
            end
            % 确保更新后的位置在界限内
            X_P3(i, :) = min(max(X_P3(i, :), lowerbound), upperbound);
    
            % 计算X_P3的适应度
            L = X_P3(i, :);
            F_P3(i) = fitness(L);
            % 如果X_P3的适应度更好，则更新位置和适应度值
            if F_P3(i) < fit(i)
                X(i, :) = X_P3(i, :);
                fit(i) = F_P3(i);
            end
        end
    
        %% 第三阶段：河马逃离捕食者（开发）
        for i = 1:SearchAgents
            % 定义局部搜索的上下界
            LO_LOCAL = (lowerbound ./ t);
            HI_LOCAL = (upperbound ./ t);
            % 生成用于位置更新的随机因子
            Alfa{1,:} = 2 * rand(1, dimension) - 1;
            Alfa{2,:} = rand(1, 1);
            Alfa{3,:} = randn;
            % 随机选择因子D
            D = Alfa{randi([1, 3]), :};
            % 更新位置X_P4
            X_P4(i, :) = X(i, :) + (rand(1, 1)) .* (LO_LOCAL + D .* (HI_LOCAL - LO_LOCAL));
            % 确保更新后的位置在界限内
            X_P4(i, :) = min(max(X_P4(i, :), lowerbound), upperbound);
    
            % 计算X_P4的适应度
            L = X_P4(i, :);
            F_P4(i) = fitness(L);
            % 如果X_P4的适应度更好，则更新位置和适应度值
            if F_P4(i) < fit(i)
                X(i, :) = X_P4(i, :);
                fit(i) = F_P4(i);
            end
        end
    
        % 记录当前迭代的最佳目标函数值
        best_so_far(t) = fbest;
        % 显示当前迭代次数和最佳成本
        disp(['迭代 ' num2str(t) ': 最佳成本 = ' num2str(best_so_far(t))]);
        
        % 输出最佳得分、最佳位置和HO曲线
        Best_score = fbest;
        Best_pos = Xbest;
        HO_curve = best_so_far;
    end
    end