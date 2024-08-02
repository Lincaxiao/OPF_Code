function [Best_score, Best_pos, HO_curve, res] = runmain(Fun_name, SearchAgents, Max_iterations)
    [lowerbound, upperbound, dimension, fitness] = fun_info(Fun_name); 
    [Best_score, Best_pos, HO_curve] = HO(SearchAgents, Max_iterations, lowerbound, upperbound, dimension, fitness);
    opt = mpoption('VERBOSE', 0, 'OUT_ALL', 0);
    res = runpf(case_ieee30,opt);