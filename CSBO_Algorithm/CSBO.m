
%%%%%  Circulatory System Based Optimization (CSBO): an expert multilevel biologically
%%%%%                             inspired meta-heuristic algorithm
%%%%%                 ENGINEERING APPLICATIONS OF COMPUTATIONAL FLUID MECHANICS
%%%%%                       https://doi.org/10.1080/19942060.2022.2098826

clc;
clear;


%% Problem Definition

fitness=@(x) fit(x);

nVar=129;                 % Number of Decision Variables

VarSize=[1 nVar];       % Decision Variables Matrix Size

VarMax = [100, 100, 100, 100, 550, 185, 100, 100, 100, 100, ...
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
VarMin = [0,   0,   0,   0,   0,   0,   0,   0,   0,   0, ...
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




%% CSBO Parameters

MaxIt = 3000000;    % Maximum Number of Iterations

nPop = 450;         % Population Size

NR=nPop/3;         % NR 是种群中的肺循环个体数目
%% Initialization


empty_plant.Position = [];
empty_plant.Cost = [];

pop = repmat(empty_plant, nPop, 1);    % Initial Population Array
% Initialize Best Solution Ever Found
BestSol.Cost=inf;

for i = 1:numel(pop)
    
    % Initialize Position
    pop(i).Position = unifrnd(VarMin, VarMax, VarSize);
    
    % Evaluation
    pop(i).Cost = fitness(pop(i).Position);
    
    sigma1(i,:) =rand(VarSize);
    if pop(i).Cost<=BestSol.Cost
        BestSol.Position=pop(i).Position;
        BestSol.Cost=pop(i).Cost;
    end
    BestCost1(i)=BestSol.Cost;
end



%% CSBO Main Loop

it=nPop;
% % for it=1:MaxIt
while it<=MaxIt
    
    
    % Get Best and Worst Cost Values
    Costs = [pop.Cost];
    BestCost = min(Costs);
    WorstCost = max(Costs);
    
    
    for i = 1:numel(pop) % numel 表示数组中元素的个数
        %%%
        %% 对于每一个个体，随机选取若干个个体，向更好的个体靠近，向不好的个体远离 %%
        %%%
        newsol = empty_plant;
        Pos(1,:) = 0*unifrnd(VarMin, VarMax, VarSize); % unifrind 生成均匀分布的随机数
        
        A=randperm(nPop);
        A(A==i)=[];
        a1=A(1);
        a2=A(2);
        a3=A(3);
        a4=A(4);
        a5=A(5);
        Costs = [pop.Cost];
        BestCost = min(Costs);
        WorstCost = max(Costs);
        AA1=((pop(a2).Cost-pop(a3).Cost)/abs(pop(a3).Cost-pop(a2).Cost)); % AA1 和 AA2 是适应度差异比例
        if (pop(a2).Cost-pop(a3).Cost)==0
            AA1=1;
        end
        AA2=((pop(a1).Cost-pop(i).Cost)/abs(pop(a1).Cost-pop(i).Cost));
        if (pop(a1).Cost-pop(i).Cost)==0
            AA2=1;
        end
        %%%Movement of blood mass 在静脉中
        Pos= pop(i).Position+(AA2*sigma1(i)).*(pop(i).Position-pop(a1).Position)+(AA1*sigma1(i)).*(pop(a3).Position-pop(a2).Position);
        
        
        newsol.Position =Pos;
        
        
        newsol.Position = max(newsol.Position, VarMin);
        newsol.Position = min(newsol.Position, VarMax);
        
        % Evaluate
        newsol.Cost = fitness(newsol.Position);
        % 
        if newsol.Cost<pop(i).Cost
            pop(i)=newsol;
            if pop(i).Cost<=BestSol.Cost
                BestSol=pop(i);
            end
            
        end
        it=it+1;
        BestCost1(it)=BestSol.Cost; % BestCost1 记录每一代的最优解
    end
    
    
    % 将种群按照适应度从小到大排序
    [~, SortOrder]=sort([pop.Cost]);
     pop = pop(SortOrder);
    
    %Population or blood mass flow in 系统循环
    i=0;
    newpop1 = [];
    for i = 1:(numel(pop)-NR)   % NR 是种群中的肺循环个体数目，即这部分个体不参与系统循环
        Pos1(1,:) = 0*unifrnd(VarMin, VarMax, VarSize);
        Costs = [pop.Cost];
        BestCost = min(Costs);
        WorstCost = max(Costs);
        ratioi= (pop(i).Cost - WorstCost)/(BestCost - WorstCost);
        newsol = empty_plant;  % empty_plant 是一个空结构体，用于存储新的个体
        
        A=randperm(nPop); % randperm 生成随机排列
        A(A==i)=[];
        a1=A(1);
        a2=A(2);
        a3=A(3);
        sigma1(i,:)=ratioi; % sigma1 是一个矩阵，用于存储每个个体每一列的适应度比例
        newsol.Position =pop(a1).Position+(sigma1(i)).*(pop(a3).Position-pop(a2).Position); % 实际上a3, a2 就是随机选取的两个个体 (扰动)
        see=pop(i).Position; % see 是当前个体的位置
        
        for j =1:nVar 
            if rand>0.9 % 以0.1的概率进行扰动
                Pos1(1,j) =newsol.Position(1,j);
            else
                Pos1(1,j)= see(1,j); % 否则保持不变
            end
        end
        newsol.Position =Pos1; % 更新位置
        % 边界处理
        newsol.Position = max(newsol.Position, VarMin);
        newsol.Position = min(newsol.Position, VarMax);
        
        
        % Evaluate
        newsol.Cost = fitness(newsol.Position);
        if newsol.Cost<pop(i).Cost
            pop(i)=newsol;
            if pop(i).Cost<=BestSol.Cost
                BestSol=pop(i);
            end
        end
        it=it+1;
        BestCost1(it)=BestSol.Cost;
    end
    % Population or blood mass flow in 肺循环
    newpop = [];
    i=0;
    
    for i = ((numel(pop)-NR)+1):numel(pop) % 遍历种群的后小半部分，即肺循环部分
        newsol = empty_plant; % 初始化新的个体
        
        % 将肺循环部分的个体进行扰动；randn/it：一个标准正态分布的随机数除以迭代次数it；rand(1,nVar)：生成一个1*nVar的随机数
        newsol.Position =pop(i).Position + (randn/it) .* rand(1,nVar) .* (VarMax-VarMin); %%% revised
        
        % Apply Lower/Upper Bounds
        newsol.Position = max(newsol.Position, VarMin);
        newsol.Position = min(newsol.Position, VarMax);
        
        % Evaluate
        newsol.Cost = fitness(newsol.Position);
        if newsol.Cost<pop(i).Cost
            pop(i)=newsol;
            if pop(i).Cost<=BestSol.Cost
                BestSol=pop(i);
            end
        end
        it=it+1;
        BestCost1(it)=BestSol.Cost;
        
        sigma1(i,:)=rand(VarSize);
    end
    
    
    
    
    % Display Iteration Information
    disp(['Iteration ' num2str(it) ': Best Cost = ' num2str(BestCost1(it))]);
    
end



BestSol.Position

plot(log(BestCost1),'b','LineWidth',2); hold on
