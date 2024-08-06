function y = fit(x)
    % 1-54: P  55-108: V 109-117: T 118-129: Q
    xMax = [100, 100, 100, 100, 550, 185, 100, 100, 100, 100, ...
        320, 414, 100, 107, 100, 100, 100, 100, 100, 119, ...
        304, 148, 100, 100, 255, 260, 100, 491, 492, 805.2, ...
        100, 100, 100, 100, 100, 100, 577, 100, 104, 707, ...
        100, 100, 100, 100, 352, 140, 100, 100, 100, 100, ...
        136, 100, 100, 100, 1.1, 1.1, 1.1, 1.1, 1.1, 1.1, ...
        1.1, 1.1, 1.1, 1.1, 1.1, 1.1, 1.1, 1.1, 1.1, 1.1, ...
        1.1, 1.1, 1.1, 1.1, 1.1, 1.1, 1.1, 1.1, 1.1, 1.1, ...
        1.1, 1.1, 1.1, 1.1, 1.1, 1.1, 1.1, 1.1, 1.1, 1.1, ...
        1.1, 1.1, 1.1, 1.1, 1.1, 1.1, 1.1, 1.1, 1.1, 1.1, ...
        1.1, 1.1, 1.1, 1.1, 1.1, 1.1, 1.1, 1.1, 1.1, 1.1, ...
        1.1, 1.1, 1.1, 1.1, 1.1, 1.1, 1.1, 30,  30,  30 , ...
        30,  30,  30,  30,  30,  30,  30,  30,  30];
    xMin = [0,   0,   0,   0,   0,   0,   0,   0,   0,   0, ...
        0,   0,   0,   0,   0,   0,   0,   0,   0,   0, ...
        0,   0,   0,   0,   0,   0,   0,   0,   0,   0, ...
        0,   0,   0,   0,   0,   0,   0,   0,   0,   0, ...
        0,   0,   0,   0,   0,   0,   0,   0,   0,   0, ...
        0,   0,   0,   0,   0.95,0.95,0.95,0.95,0.95,0.95, ...
        0.95,0.95,0.95,0.95,0.95,0.95,0.95,0.95,0.95,0.95, ...
        0.95,0.95,0.95,0.95,0.95,0.95,0.95,0.95,0.95,0.95, ...
        0.95,0.95,0.95,0.95,0.95,0.95,0.95,0.95,0.95,0.95, ...
        0.95,0.95,0.95,0.95,0.95,0.95,0.95,0.95,0.95,0.95, ...
        0.95,0.95,0.95,0.95,0.95,0.95,0.95,0.95,0.90,0.90, ...
        0.90,0.90,0.90,0.90,0.90,0.90,0.90,0,   0,   0,   ...
        0,   0,   0,   0,   0,   0,   0,   0,   0];
    data = case118;
    data.gen(:, 2) = x(1:54); % 发电机有功功率
    data.gen(:, 6) = x(55:108); % 发电机电压幅值
    data.branch(8, 9) = x(109); % 变压器分接头位置
    data.branch(32, 9) = x(110);
    data.branch(36, 9) = x(111);
    data.branch(61, 9) = x(112);
    data.branch(93, 9) = x(113);
    data.branch(95, 9) = x(114);
    data.branch(102, 9) = x(115);
    data.branch(107, 9) = x(116);
    data.branch(127, 9) = x(117);
    data.bus(34, 6) = x(118); % 并联电容无功补偿
    data.bus(44, 6) = x(119);
    data.bus(45, 6) = x(120);
    data.bus(46, 6) = x(121);
    data.bus(48, 6) = x(122);
    data.bus(74, 6) = x(123);
    data.bus(79, 6) = x(124);
    data.bus(82, 6) = x(125);
    data.bus(83, 6) = x(126);
    data.bus(105, 6) = x(127);
    data.bus(107, 6) = x(128);
    data.bus(110, 6) = x(129);
    opt = mpoption('VERBOSE', 0, 'OUT_ALL', 0);
    res = runpf(data, opt);
    Ploss = sum(res.branch(:, 14) + res.branch(:, 16)); % 网损
    Cost = 0;
    for i = 1:54
        P = res.gen(i, 2);
        Cost = Cost + res.gencost(i, 5) * P^2 + res.gencost(i, 6) * P;
    end
    penalty = 0;
    for i = 1:129
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
    for i = 1:118
        if V(i) > Vmax
            penalty = penalty + (V(i) - Vmax) * 100 + 5000000;
        end
        if V(i) < Vmin
            penalty = penalty + (Vmin - V(i)) * 100 + 5000000;
        end
    end
    y = Cost + penalty;
end