clc;  % 清除命令窗口
clear;  % 清除所有变量
close all;  % 关闭所有图形窗口

% 定义要测试的目标函数编号
Fun_name = 'Fun_ieee30';  % 测试函数编号
% 定义河马优化算法的种群大小
SearchAgents = 1500;  
% 定义最大迭代次数
Max_iterations = 100;  
% 获取目标函数的下界、上界、维度和适应度函数
[lowerbound, upperbound, dimension, fitness] = fun_info(Fun_name);  
% 调用河马优化算法
[Best_score, Best_pos, HO_curve] = HO(SearchAgents, Max_iterations, lowerbound, upperbound, dimension, fitness);

% 对最终的最优解进行runpf
%data = case30;
%data.gen(2:6, 2) = Best_pos(1:5) .* (data.gen(2:6, 2))';  % 发电机有功功率
%data.gen(:, 3) = Best_pos(6:11) .* (data.gen(:, 3))';  % 发电机无功功率
%data.gen(:, 6) = Best_pos(12:17);  % 发电机电压幅值
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

% 显示通过HO算法获得的最佳解
display(['通过HO算法获得的' [num2str(Fun_name)], '的最佳解是 : ', num2str(Best_pos)]);
% 显示通过HO算法找到的目标函数的最佳最优值
display(['通过HO算法找到的' [num2str(Fun_name)], '的目标函数最佳值是 : ', num2str(Best_score)]);

% 创建图形窗口并绘制HO算法的收敛曲线
figure = gcf;  % 获取当前图形窗口
semilogy(HO_curve, 'Color', '#b28d90', 'LineWidth', 2);  % 绘制半对数曲线
xlabel('迭代');  % x轴标签
ylabel('到目前为止获得的最佳分数');  % y轴标签
box on;  % 显示边框
% 设置图形窗口中所有对象的字体为Times New Roman
set(findall(figure, '-property', 'FontName'), 'FontName', 'Times New Roman');
legend('HO');  % 图例