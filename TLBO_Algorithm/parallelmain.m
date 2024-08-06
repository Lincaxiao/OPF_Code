Max_loop_number = 6;
Max_iterations = 300;
Search_agents = 300;
Fun_name = 'Fun_ieee30';

Global_Best_Score = inf;
Global_Best_pos = [];
Global_TLBO_curve = [];
Global_res = [];

parfor i = 1:Max_loop_number
    [Best_score, Best_pos, TLBO_curve, res] = runmain(Fun_name, Search_agents, Max_iterations);
    temp(i).Best_score = Best_score;
    temp(i).Best_pos = Best_pos;
    temp(i).TLBO_curve = TLBO_curve;
    temp(i).res = res;
end

for i = 1:Max_loop_number
    if temp(i).Best_score < Global_Best_Score
        Global_Best_Score = temp(i).Best_score;
        Global_Best_pos = temp(i).Best_pos;
        Global_TLBO_curve = temp(i).TLBO_curve;
        Global_res = temp(i).res;
    end
end
Global_Best_Score_now = Global_Best_Score;
Global_Best_pos_now = Global_Best_pos;
Global_TLBO_curve_now = Global_TLBO_curve;
Global_res_now = Global_res;
% 如果存在results.mat文件，则加载该文件
if exist('results.mat', 'file')
    load('results.mat');
    if Global_Best_Score_now < Global_Best_Score
        Global_Best_Score = Global_Best_Score_now;
        Global_Best_pos = Global_Best_pos_now;
        Global_TLBO_curve = Global_TLBO_curve_now;
        Global_res = Global_res_now;
    end
end

save('results.mat', 'Global_Best_Score', 'Global_Best_pos', 'Global_TLBO_curve', 'Global_res');
data = case_ieee30;
data.gen(:, 6) = Global_Best_pos(1 : 6);
data.branch(11, 9) = Global_Best_pos(7);
data.branch(12, 9) = Global_Best_pos(8);
data.branch(15, 9) = Global_Best_pos(9);
data.branch(36, 9) = Global_Best_pos(10);
data.gen(2:6, 2) = Global_Best_pos(21:25);
data.bus(10, 6) = Global_Best_pos(11);
data.bus(12, 6) = Global_Best_pos(12);
data.bus(15, 6) = Global_Best_pos(13);
data.bus(17, 6) = Global_Best_pos(14);
data.bus(20, 6) = Global_Best_pos(15);
data.bus(21, 6) = Global_Best_pos(16);
data.bus(23, 6) = Global_Best_pos(17);
data.bus(24, 6) = Global_Best_pos(18);
data.bus(29, 6) = Global_Best_pos(19);
res = runpf(data);
disp(Global_res.gen(:, 2)');
disp(['The final ploss is ', num2str(Global_Best_Score)]);
disp(['The global best pos is ', num2str(Global_Best_pos)]);
