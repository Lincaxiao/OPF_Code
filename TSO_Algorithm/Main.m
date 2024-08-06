clc;  % 清除命令窗口
clear;  % 清除所有变量
close all;  % 关闭所有图形窗口

% 定义要测试的目标函数编号
Fun_name = 'Fun_case118';  % 测试函数编号
% 定义金枪鱼群算法的种群大小
SearchAgents = 10;
% 定义最大迭代次数
Max_iterations = 200;
% 获取目标函数的下界、上界、维度和适应度函数
[lowerbound, upperbound, dimension, fitness] = fun_info(Fun_name);
% 调用金枪鱼群算法
[Best_score, Best_pos, TSO_curve] = TSO(SearchAgents, Max_iterations, lowerbound, upperbound, dimension, fitness);

% 对最终的最优解进行runpf
data = case_ieee30;
data.gen(:, 6) = Best_pos(1 : 6);  % 发电机电压幅值
data.branch(11, 9) = Best_pos(7);  % 变压器分接头位置
data.branch(12, 9) = Best_pos(8);
data.branch(15, 9) = Best_pos(9);
data.branch(36, 9) = Best_pos(10);
data.gen(2:6, 2) = Best_pos(21:25);  % 发电机有功功率
data.bus(10, 6) = Best_pos(11);
data.bus(12, 6) = Best_pos(12);
data.bus(15, 6) = Best_pos(13);
data.bus(17, 6) = Best_pos(14);
data.bus(20, 6) = Best_pos(15);
data.bus(21, 6) = Best_pos(16);
data.bus(23, 6) = Best_pos(17);
data.bus(24, 6) = Best_pos(18);
data.bus(29, 6) = Best_pos(19);
res = runpf(data);
data = case118;
data.gen(:, 2) = Best_pos(1 : 54);  % 发电机有功功率
data.gen(:, 6) = Best_pos(55 : 108);  % 发电机电压幅值
data.branch(8, 9) = Best_pos(109);  % 变压器分接头位置
data.branch(32, 9) = Best_pos(110);
data.branch(36, 9) = Best_pos(111);
data.branch(61, 9) = Best_pos(112);
data.branch(93, 9) = Best_pos(113);
data.branch(95, 9) = Best_pos(114);
data.branch(102, 9) = Best_pos(115);
data.branch(107, 9) = Best_pos(116);
data.branch(127, 9) = Best_pos(117);
data.bus(34, 6) = Best_pos(118); % 并联电容无功补偿
data.bus(44, 6) = Best_pos(119);
data.bus(45, 6) = Best_pos(120);
data.bus(46, 6) = Best_pos(121);
data.bus(48, 6) = Best_pos(122);
data.bus(74, 6) = Best_pos(123);
data.bus(79, 6) = Best_pos(124);
data.bus(82, 6) = Best_pos(125);
data.bus(83, 6) = Best_pos(126);
data.bus(105, 6) = Best_pos(127);
data.bus(107, 6) = Best_pos(128);
data.bus(110, 6) = Best_pos(129);
res = runpf(data);
% 计算发电成本
Cost = 0;
for i = 1 : 6
    P = res.gen(i, 2);
    Cost = Cost + res.gencost(i, 5) * P ^ 2 + res.gencost(i, 6) * P;
end
% 计算网损
Ploss = sum(res.branch(:, 14) + res.branch(:, 16));
disp(['The final cost is ', num2str(Cost)]);
disp(['The final Ploss is ', num2str(Ploss)]);
% 打印发电机的有功功率
disp(['The final P is ', num2str(res.gen(:, 2)')]);

% 显示通过TSO算法获得的最佳解
display(['通过TSO算法获得的' [num2str(Fun_name)], '的最佳解是 : ', num2str(Best_pos)]);
% 显示通过TSO算法找到的目标函数的最佳最优值
display(['通过TSO算法找到的' [num2str(Fun_name)], '的目标函数最佳值是 : ', num2str(Best_score)]);

% 创建图形窗口并绘制TSO算法的收敛曲线
figure = gcf;  % 获取当前图形窗口
semilogy(TSO_curve, 'Color', '#b28d90', 'LineWidth', 2);  % 绘制半对数曲线
xlabel('迭代');  % x轴标签
ylabel('到目前为止获得的最佳分数');  % y轴标签
box on;  % 显示坐标轴框线
% 设置图形窗口中的所有对象字体为 Times New Roman
set(findall(figure, '-property', 'FontName'), 'FontName', 'Times New Roman');
legend('TSO');  % 图例