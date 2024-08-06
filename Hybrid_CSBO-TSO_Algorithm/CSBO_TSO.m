clc;
clear;

fitness = @(x) fit_ieee30(x);

nVar = 25; % Number of Decision Variables
a = 0.7; % a1 代表了个体向最优个体靠近的程度
z = 0.05; % Probability of random resetting

VarSize = [1, nVar]; % Decision Variables Matrix Size

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
VarMax = [1.10, 1.10, 1.10, 1.10, 1.10, 1.10, 1.10, 1.10, 1.10, 1.10...
        5,    5,  5,  5,  5,  5, 5,  5,  5, 200, 80, 50, 35, 30, 40];
VarMin = [0.95, 0.95, 0.95, 0.95, 0.95, 0.95, 0.90, 0.90, 0.90, 0.90...
        0,    0,    0,    0,    0,    0,    0,    0,    0, 50, 20, 15, 10, 10, 12];
MaxIt = 120000; % 最大迭代次数
nPop = 300; % 种群大小
NR = nPop / 3; % NR 是种群中的肺循环个体数目

empty_plant.Position = [];
empty_plant.Cost = [];

pop = repmat(empty_plant, nPop, 1); % 初始化种群数组
BestSol.Cost = inf;

for i = 1:numel(pop)
    pop(i).Position = unifrnd(VarMin, VarMax, VarSize);
    pop(i).Cost = fitness(pop(i).Position);
    sigma1(i,:) =rand(VarSize);
    if pop(i).Cost < BestSol.Cost
        BestSol = pop(i);
    end
    BestCost1(i) = BestSol.Cost;
end

it = nPop;

while it <= MaxIt
    Costs = [pop.Cost];
    BestCost = min(Costs);
    WorstCost = max(Costs);
    t_factor = (1 - it / MaxIt) ^ (it / MaxIt);

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
        save("CSBO_TSO_result.mat", "BestCost1")
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

    for i = 1:(numel(pop)-NR)
        C = it / MaxIt;
        a1 = a + (1 - a) * C; % a1 代表了个体向最优个体靠近的程度
        a2 = (1 - a) * (1 - C);
        if rand > 0.5
            r1 = rand;
            Beta = exp(r1 * exp(3 * cos(pi * (MaxIt - it + 1) / MaxIt))) * cos(2 * pi * r1);
            if it/MaxIt > rand
                New_Position = a1 * (BestSol.Position + Beta * abs(BestSol.Position - pop(i).Position)) + a2 * pop(i).Position;
                if fitness(New_Position) < pop(i).Cost
                    pop(i).Position = New_Position;
                    pop(i).Cost = fitness(New_Position);
                    if pop(i).Cost < BestSol.Cost
                        BestSol = pop(i);
                    end
                end
            else
                IndivRand = unifrnd(VarMin, VarMax, VarSize);
                New_Position = a1 * (IndivRand + Beta * abs(IndivRand - pop(i).Position)) + a2 * pop(i).Position;
                if fitness(New_Position) < pop(i).Cost
                    pop(i).Position = New_Position;
                    pop(i).Cost = fitness(New_Position);
                    if pop(i).Cost < BestSol.Cost
                        BestSol = pop(i);
                    end
                end
            end
        else
            TF = (rand > 0.5) * 2 - 1;
            if rand < 0.5
                New_Position = BestSol.Position + rand(1, nVar) .* (BestSol.Position - pop(i).Position) + TF * t_factor^2 .* (BestSol.Position - pop(i).Position);
                if fitness(New_Position) < pop(i).Cost
                    pop(i).Position = New_Position;
                    pop(i).Cost = fitness(New_Position);
                    if pop(i).Cost < BestSol.Cost
                        BestSol = pop(i);
                    end
                end
            else
                New_Position = TF * t_factor^2 .* pop(i).Position;
                if fitness(New_Position) < pop(i).Cost
                    pop(i).Position = New_Position;
                    pop(i).Cost = fitness(New_Position);
                    if pop(i).Cost < BestSol.Cost
                        BestSol = pop(i);
                    end
                end
            end
        end
        it = it + 1;            
    end

    disp(['Iteration ' num2str(it) ': Best Cost = ' num2str(BestSol.Cost)]);
end

BestSol.Position

% 创建图形窗口并绘制TSO算法的收敛曲线
figure = gcf;  % 获取当前图形窗口
plot(BestCost1, 'Color', '#b28d90', 'LineWidth', 2);  % 绘制正常曲线
xlabel('迭代');  % x轴标签
ylabel('到目前为止获得的最佳分数');  % y轴标签
box on;  % 显示坐标轴框线
% 设置图形窗口中的所有对象字体为 Times New Roman
set(findall(figure, '-property', 'FontName'), 'FontName', 'Times New Roman');
legend('CSBO_TSO');  % 图例