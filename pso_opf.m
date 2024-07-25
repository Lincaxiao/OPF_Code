clear % Clear all variables
close all % Close all figures
clc % Clear the command window


% 发电机有功功率、发电机母线电压、变压器分接头位置以及可切换的VAR源的无功功率

%%% This algorithm can find the maximum of a function accepting 2 variables %%%
% Define the related parameters
numberofParticles = 10; % The number of particles
maxIter = 50; % The maximum number of iterations

% The inertia weight would decrease linearly from wMax to wMin
% To fit the reality that the Swarm would converge to the global best fitness value gradually
wMax = 1; % The maximum inertia weight      
wMin = 0.001; % The minimum inertia weight

c1 = 1.49445; % The cognitive coefficient
c2 = 1.49445; % The social coefficient
vMax = 1; % The upper bound of the velocity         ***vMax, vMin 改成上面的变量的约束，例如有六台发电机就加6行有功功率(有slack节点可能只要5行)，还有相应的母线电压等等**
vMin = -vMax; % The lower bound of the velocity     ***相应的rand、x、v也要改成 n * 1 的矩阵***
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
Swarm.GBEST.O = -inf; % Initialize the global best fitness value to negative infinity
% Creat an array to store the globle best value of each iteration
globalBest = zeros(1, maxIter); % Initialize the array
for k = 1 : numberofParticles
    Swarm.Particles(k).X = 10 * rand(1, 2) - 5; % Initialize the position of the particle to a random value between -5 and 5
    Swarm.Particles(k).V = zeros(1, 2); % Initialize the velocity of the particle to zero

    % Set the personal best of the particle to the initial position
    Swarm.Particles(k).PBEST.X = Swarm.Particles(k).X;
    % Calculate the fitness value of the particle
    Swarm.Particles(k).O = fun(Swarm.Particles(k).X);
    % Set the personal best fitness value of the particle to the initial fitness value
    Swarm.Particles(k).PBEST.O = Swarm.Particles(k).O;
    % Update the global best if the current particle has a better fitness value than the global best
    if Swarm.Particles(k).O > Swarm.GBEST.O
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

        % Calculate the fitness value of the particle
        Swarm.Particles(k).O = fun(Swarm.Particles(k).X);

        % Update the personal best of the particle if the current fitness value is better than the personal best
        if Swarm.Particles(k).O > Swarm.Particles(k).PBEST.O
            Swarm.Particles(k).PBEST.X = Swarm.Particles(k).X;
            Swarm.Particles(k).PBEST.O = Swarm.Particles(k).O;
        end

        % Update the global best if the current fitness value is better than the global best
        if Swarm.Particles(k).O > Swarm.GBEST.O
            Swarm.GBEST.X = Swarm.Particles(k).X;
            Swarm.GBEST.O = Swarm.Particles(k).O;
        end
    end
    % Add the global best value of this iteration to the array
    globalBest(t) = Swarm.GBEST.O;
end
% 在最后对于全局最优情况运行一次runpf
data = case30;
data.bus(9, 4) = data.bus(9, 4) - ceil(Swarm.GBEST.X(1)) * 1; % 把9节点接入无功 (MW)
data.bus(18, 4) = data.bus(18, 4) - ceil(Swarm.GBEST.X(2)) * 1; % 把18节点接入无功 (MW)
res = runpf(data);

% Display the global best fitness value and the global best position 
disp(['The global best fitness value is ', num2str(Swarm.GBEST.O)]);
disp(['The global best position is (', num2str(Swarm.GBEST.X(1)), ', ', num2str(Swarm.GBEST.X(2)), ')']);
% Display the global best value of each iteration
figure;
plot(1:maxIter, globalBest);
title('The global best value of each iteration');
xlabel('Iteration');
ylabel('Global best value');
% Escape the figure is overridden by the next figure
hold on;

disp(['The initial global best fitness value is ', a]);