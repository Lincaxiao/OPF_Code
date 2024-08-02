function [lowerbound, upperbound, dimension, fitness] = fun_info(F)

    switch F
        % New functions with custom bounds
        case 'Fun_case30'
            fitness = @Fun_case30;
            lowerbound = [0.25, 0.25, 0.25, 0.25, 0.25, -0.13, -0.33, -0.24, -0.308, -0.25, -0.33, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.95, 0.95, 0.95, 0.95, 0.95, 0.95];
            upperbound = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1.1, 1.1, 1.1, 1.1, 1.1, 1.1, 1.05, 1.05, 1.05, 1.05, 1.05, 1.05];
            dimension = 23;
        case 'Fun_ieee30'
            fitness = @Fun_ieee30;
            lowerbound = [0.95, 0.95, 0.95, 0.95, 0.95, 0.95, 0.90, 0.90, 0.90, 0.90...
                             0,    0,    0,    0,    0,    0,    0,    0,    0, 50, 20, 15, 10, 10, 12];
            upperbound = [1.10, 1.10, 1.10, 1.10, 1.10, 1.10, 1.10, 1.10, 1.10, 1.10...
                            5,    5,  5,  5,  5,  5, 5,  5,  5, 200, 80, 50, 35, 30, 40];
            dimension = 25;

        otherwise
            error('Function name not recognized');
    end
    
    end
    
function y = Fun_case30(x)
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
        if V(i) < 0.94 || V(i) > 1.06
           penalty = penalty + V(i)*0.3;
        end
    end 

    y = Cost + penalty;
end

function y = Fun_ieee30(x)
    %       V1,   V2,   V5,   V8,   V11,  V13   T11   T12   T15   T36  
    %       Q10   Q12   Q15   Q17   Q20   Q21   Q23   Q24   Q29
    xMax = [1.10, 1.10, 1.10, 1.10, 1.10, 1.10, 1.10, 1.10, 1.10, 1.10...
        5,    5,  5,  5,  5,  5, 5,  5,  5, 200, 80, 50, 35, 30, 40];
    xMin = [0.95, 0.95, 0.95, 0.95, 0.95, 0.95, 0.90, 0.90, 0.90, 0.90...
        0,    0,    0,    0,    0,    0,    0,    0,    0, 50, 20, 15, 10, 10, 12];
    data = case_ieee30;
    data.gen(:, 6) = x(1 : 6); % 发电机电压幅值
    data.branch(11, 9) = x(7); % 变压器分接头位置
    data.branch(12, 9) = x(8); 
    data.branch(15, 9) = x(9); 
    data.branch(36, 9) = x(10);
    % 并联电容无功补偿
    data.bus(10, 6) = x(11);
    data.bus(12, 6) = x(12);
    data.bus(15, 6) = x(13);
    data.bus(17, 6) = x(14);
    data.bus(20, 6) = x(15);
    data.bus(21, 6) = x(16);
    data.bus(23, 6) = x(17);
    data.bus(24, 6) = x(18);
    data.bus(29, 6) = x(19);
    data.gen(2:6, 2) = x(21:25); % 发电机有功功率
    opt = mpoption('VERBOSE', 0, 'OUT_ALL', 0);
    res = runpf(data, opt);
    Ploss = sum(res.branch(:, 14) + res.branch(:, 16)); % 网损
    Cost = 0;
    for i = 1:6
        P = res.gen(i, 2);
        Cost = Cost + res.gencost(i, 5) * P^2 + res.gencost(i, 6) * P;
    end
    penalty = 0;
    for i = 1:25
        if x(i) > xMax(i) 
            penalty = penalty + (x(i) - xMax(i))^2 * 50 + 5;
        end
        if x(i) < xMin(i)
            penalty = penalty + (xMin(i) - x(i))^2 * 50 + 5;
        end
    end
    Vmax = 1.06;
    Vmin = 0.94;
    V = res.bus(:, 8);
    for i = 1:30
        if V(i) > Vmax
            penalty = penalty + (V(i) - Vmax) * 100;
        end
        if V(i) < Vmin
            penalty = penalty + (Vmin - V(i)) * 100;
        end
    end
    y = Ploss + penalty;
end