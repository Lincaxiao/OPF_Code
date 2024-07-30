clear % Clear all variables
close all % Close all figures
clc % Clear the command window


% 发电机有功功率、发电机母线电压、变压器分接头位置以及可切换的VAR源的无功功率

%%% This algorithm can find the maximum of a function accepting 2 variables %%%
% Define the related parameters
numberofParticles = 1000; % The number of particles
maxIter = 50; % The maximum number of iterations

% The inertia weight would decrease linearly from wMax to wMin
% To fit the reality that the Swarm would converge to the global best fitness value gradually
wMax = 1; % The maximum inertia weight      
wMin = 0.001; % The minimum inertia weight

c1 = 1.49445; % The cognitive coefficient
c2 = 1.49445; % The social coefficient
%       P2(%) P3 P4 P5 P6 Q1(%) Q2 Q3 Q4 Q5 Q6 V1   V2,  V3,  V4   V5   V6    r1    r2    r3    r4    r5    r6
xMax = [1,    1, 1, 1, 1, 1,    1, 1, 1, 1, 1, 1.1, 1.1, 1.1, 1.1, 1.1, 1.1,  1.05, 1.05, 1.05, 1.05, 1.05, 1.05];
xMin = [0.25, 0.25, 0.25, 0.25, 0.25, -0.13,-0.33,-0.24,-0.308,-0.25,-0.33, 0.9, 0.9, 0.9, 0.9, 0.9, 0.9, 0.95, 0.95, 0.95, 0.95, 0.95, 0.95];
vMax = 0.05 * (xMax - xMin); % The maximum velocity
vMin = -vMax; % The minimum velocity         
%   ***相应的rand、x、v也要改成 n * 1 的矩阵***
%***在进行计算的时候，注意行与行之间的对应***

% Define the swarm structure with suitable retractions
Swarm = struct(...
    'Particles', struct(...
        'X', [], ...
        'V', [], ...
        'PBEST', struct(...
            'X', [], ...
            'O', []...
        ), ...
        'O', []...
    ), ...
    'GBEST', struct(...
        'X', [], ...
        'O', []...
    )...
);

% Initialize the particles
Swarm.GBEST.O = inf; % Initialize the global best fitness value to infinity
% Creat an array to store the globle best value of each iteration
globalBest = zeros(1, maxIter); % Initialize the array
for k = 1 : numberofParticles
    Swarm.Particles(k).X = xMin + (xMax - xMin) .* rand(size(xMin)); % Initialize the position of the particle to a random value between xMin and xMax
    Swarm.Particles(k).V = zeros(size(xMin)); % Initialize the velocity of the particle to zero

    % Set the personal best of the particle to the initial position
    Swarm.Particles(k).PBEST.X = Swarm.Particles(k).X;
    % Calculate the fitness value of the particle
    Swarm.Particles(k).O = fun(Swarm.Particles(k).X);
    % Set the personal best fitness value of the particle to the initial fitness value
    Swarm.Particles(k).PBEST.O = Swarm.Particles(k).O;
    % Update the global best if the current particle has a better fitness value than the global best
    if Swarm.Particles(k).O < Swarm.GBEST.O
        Swarm.GBEST.X = Swarm.Particles(k).X;
        Swarm.GBEST.O = Swarm.Particles(k).O;
    end
end
% print the initial global best fitness value
a = num2str(Swarm.GBEST.O);


% Main loop
for t = 1 : maxIter
    % Update the inertia weight
    w = wMax - t * ((wMax - wMin) / maxIter);
    
    % Update the position and velocity of each particle
    for k = 1 : numberofParticles
        newVelocity = calculateVelocity(Swarm.Particles(k).V, c1, c2, Swarm.Particles(k).PBEST.X, Swarm.GBEST.X, Swarm.Particles(k).X, vMax, vMin, w);
        Swarm.Particles(k).V = newVelocity;
        Swarm.Particles(k).X = Swarm.Particles(k).X + Swarm.Particles(k).V;
        % Limit the position to the maximum and minimum values
        Swarm.Particles(k).X = min(Swarm.Particles(k).X, xMax);
        Swarm.Particles(k).X = max(Swarm.Particles(k).X, xMin);

        % Calculate the fitness value of the particle    *************************
        Swarm.Particles(k).O = fun(Swarm.Particles(k).X);
        % Update the personal best of the particle if the current fitness value is better than the personal best
        if Swarm.Particles(k).O < Swarm.Particles(k).PBEST.O
            Swarm.Particles(k).PBEST.X = Swarm.Particles(k).X;
            Swarm.Particles(k).PBEST.O = Swarm.Particles(k).O;
        end

        % Update the global best if the current fitness value is better than the global best
        if Swarm.Particles(k).O < Swarm.GBEST.O
            Swarm.GBEST.X = Swarm.Particles(k).X;
            Swarm.GBEST.O = Swarm.Particles(k).O;
        end
    end
    % Add the global best value of this iteration to the array
    globalBest(t) = Swarm.GBEST.O;
    if Swarm.Particles(k).O == 0
        break;
    end
end
% 对最终的最优解进行runpf
data = case30;
data.gen(2:6, 2) = Swarm.GBEST.X(1:5) .* (data.gen(2:6, 2))'; % 发电机有功功率
data.gen(:, 3) = Swarm.GBEST.X(6:11) .* (data.gen(:, 3))';  % 发电机无功功率
data.gen(:, 6) = Swarm.GBEST.X(12:17); % 发电机电压幅值
res = runpf(data);
% 计算发电成本
Cost = 0;
for i = 1 : 6
    Cost = Cost + res.gencost(i, 5) * res.gen(i, 2) ^ 2 + res.gencost(i, 6) * res.gen(i, 2);
end
disp(['The final cost is ', num2str(Cost)]);

% Display the global best fitness value and the global best position
disp(['The global best fitness value is ', num2str(Swarm.GBEST.O)]);
% Display the global best value of each iteration
figure;
plot(1:maxIter, globalBest);
title('The global best value of each iteration');
xlabel('Iteration');
ylabel('Global best value');
% Escape the figure is overridden by the next figure
hold on;

disp(['The initial global best fitness value is ', a]);