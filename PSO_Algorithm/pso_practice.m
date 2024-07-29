clear % Clear all variables
close all % Close all figures
clc % Clear the command window

%%% This algorithm can find the maximum of a function accepting 2 variables %%%
% Define the related parameters
numberofParticles = 500; % The number of particles
maxIter = 300; % The maximum number of iterations

% The inertia weight would decrease linearly from wMax to wMin
% To fit the reality that the Swarm would converge to the global best fitness value gradually
wMax = 1; % The maximum inertia weight
wMin = 0.001; % The minimum inertia weight

c1 = 2; % The cognitive coefficient
c2 = 0.2; % The social coefficient
vMax = 0.4; % The upper bound of the velocity
vMin = -vMax; % The lower bound of the velocity

% Define the objective function
function z = rastriginMax(x, y)
    z = -(20 + x.^2 + y.^2 - 10 * (cos(2 * pi * x) + cos(2 * pi * y)));
end

%% TODO: Define the structure of the swarm

%% TODO: Initialize the particles

%% TODO: Creat an array to store the globle best value of each iteration

    % Randomly initialize the position of the particle, from -5 to 5
    % Initialize the velocity of the particle to zero
    % Set the personal best of the particle to the initial position
    % Calculate the fitness value of the particle
    % Set the personal best fitness value of the particle to the initial fitness value
    % Update the global best if the current particle has a better fitness value than the global best

% Main loop

    % Update the inertia weight
    
    % Update the position and velocity of each particle
        % Calculate the fitness value of the particle
        % Update the personal best of the particle if the current fitness value is better than the personal best
        % Update the global best if the current fitness value is better than the global best

    % Add the global best value of this iteration to the array


% Display the global best fitness value and the global best position 

% Display the global best value of each iteration

% Escape the figure is overridden by the next figure
hold on;

% Display the whole graph of the Rastrigin function

% Display the actual global maximum of the Rastrigin function


