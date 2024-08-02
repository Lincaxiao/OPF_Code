Max_loop_number = 500;
Max_iterations = 200;
Search_agents = 1500;
Fun_name = 'Fun_ieee30';

Global_Best_Score = inf;
Global_Best_pos = [];
Global_HO_curve = [];
Global_res = [];

parfor i = 1:Max_loop_number
    [Best_score, Best_pos, HO_curve, res] = runmain(Fun_name, Search_agents, Max_iterations);
    temp(i).Best_score = Best_score;
    temp(i).Best_pos = Best_pos;
    temp(i).HO_curve = HO_curve;
    temp(i).res = res;
end

for i = 1:Max_loop_number
    if temp(i).Best_score < Global_Best_Score
        Global_Best_Score = temp(i).Best_score;
        Global_Best_pos = temp(i).Best_pos;
        Global_HO_curve = temp(i).HO_curve;
        Global_res = temp(i).res;
    end
end
save('results.mat', 'Global_Best_Score', 'Global_Best_pos', 'Global_HO_curve', 'Global_res');
