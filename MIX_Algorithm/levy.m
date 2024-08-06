% 代码来源于研究：
%'多目标布谷鸟搜索设计优化 Xin-She Yang, Suash Deb'。
% 由Hemanth Manjunatha在2015年11月13日编写。

% 输入参数
% n    -> 步数
% m    -> 维度数
% beta -> 幂律指数  % 注意：1 < beta < 2
% 输出
% z    -> 'n'个Levy步在'm'维度
%_________________________________________________________________________
function [z] = levy(n, m, beta)

  % 计算分子部分，用于Levy飞行分布的标准化
  num = gamma(1 + beta) * sin(pi * beta / 2); 
  
  % 计算分母部分，用于Levy飞行分布的标准化
  den = gamma((1 + beta) / 2) * beta * 2^((beta - 1) / 2);

  % 计算标准差
  sigma_u = (num / den)^(1 / beta); 

  % 生成正态分布的随机数，均值为0，标准差为sigma_u
  u = random('Normal', 0, sigma_u, n, m); 
  
  % 生成标准正态分布的随机数
  v = random('Normal', 0, 1, n, m);

  % 计算Levy飞行步长
  z = u ./ (abs(v).^(1 / beta));

end