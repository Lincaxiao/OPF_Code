function y = fun(x)
% 计算粒子的适应度
% input    输入粒子 e.g. 2台电容 9 18 1MW
% output   粒子适应度值
% y = sin(10 * pi * x) / x
data = case30;
data.bus(9, 4) = data.bus(9, 4) - ceil(x(1, 1)) * 1; % 把9节点接入无功 (MW)
data.bus(18, 4) = data.bus(18, 4) - ceil(x(1, 2)) * 1; % 把18节点接入无功 (MW)
res = runpf(data);
Ploss = sum(res.branch(:, 14) + res.branch(:, 16));
y = 1/Ploss;  % 网损 