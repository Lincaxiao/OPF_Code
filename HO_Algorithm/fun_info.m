function [lowerbound, upperbound, dimension, fitness] = fun_info(F)

    switch F
        % New functions with custom bounds
        case 'Fun'
            fitness = @Fun;
            lowerbound = [0.25, 0.25, 0.25, 0.25, 0.25, -0.13, -0.33, -0.24, -0.308, -0.25, -0.33, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.95, 0.95, 0.95, 0.95, 0.95, 0.95];
            upperbound = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1.1, 1.1, 1.1, 1.1, 1.1, 1.1, 1.05, 1.05, 1.05, 1.05, 1.05, 1.05];
            dimension = 23;
    
        otherwise
            error('Function name not recognized');
    end
    
    end
    
function y = Fun(x)
    xMax = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1.1, 1.1, 1.1, 1.1, 1.1, 1.1, 1.05, 1.05, 1.05, 1.05, 1.05, 1.05];
    xMin = [0.25, 0.25, 0.25, 0.25, 0.25, -0.13, -0.33, -0.24, -0.308, -0.25, -0.33, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.95, 0.95, 0.95, 0.95, 0.95, 0.95];
    data = case30;
    data.gen(2:6, 2) = x(1:5) .* (data.gen(2:6, 2))'; % 发电机有功功率
    data.gen(:, 3) = x(6:11) .* (data.gen(:, 3))';  % 发电机无功功率
    data.gen(:, 6) = x(12:17); % 发电机电压幅值
    data.branch(1:6, 9) = x(18:23); %变压器分接头位置
    opt = mpoption('VERBOSE', 0, 'OUT_ALL', 0);
    res = runpf(data, opt);
    Ploss = sum(res.branch(:, 14) + res.branch(:, 16)); % 网损

    % 计算成本
    Cost = 0;
    for i = 1:6
        P = res.gen(i, 2);
        Cost = Cost + res.gencost(i, 5) * P^2 + res.gencost(i, 6) * P;
    end

    % 计算惩罚函数
    penalty = 0;
    for i = 1:size(x, 1)
        if x(i) > xMax(i) 
            penalty = penalty + (x(i) - xMax(i)) * 5000;
        end
        if x(i) < xMin(i)
            penalty = penalty + (xMin(i) - x(i)) * 5000;
        end
    end

    % 计算电压稳定性
    V = res.bus(:, 8);
    Stability = 0; % the sum of the voltage deviation
    for i = 1:size(V, 1)
        Stability = Stability + (V(i) - 1)^2;
        if V(i) < 0.98 || V(i) > 1.02
           penalty = penalty + V(i)*0.3;
        end
    end 

    y = Cost + penalty;
end