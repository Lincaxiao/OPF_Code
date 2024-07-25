function [newVelocity] = calculateVelocityPractice...
    (pastVelocity, c1, c2, pBest, gBest, currentX, vMax, vMin, w)
%%% Calculate the new velocity %%%
% velocity: a 2-element vector representing the velocity of the particle
% c1: cognitive coefficient 
% c2: social coefficient 
% pBest: personal best 
% currentX: current position 
% vMax, vMin: the upper and lower bounds of the velocity 
% w: inertia weight 
% Detailed calculation idea: The new velocity is the sum of three parts:
% the inertia part, the cognitive part, and the social part.
% The inertia part is the product of the inertia weight and the past velocity.
% The cognitive part is the product of the cognitive coefficient, a random number, 
% and the difference between the personal best and the current position.
% The social part is the product of the social coefficient, a random number, 
% and the difference between the global best and the current position.
% Equation: v = w * v + c1 * r1 * (pBest - currentX) + c2 * r2 * (gBest - currentX)

% Calculate the inertia part

% Generate two random numbers

% Calculate the cognitive part

% Calculate the social part

% Calculate the new velocity

% Limit the velocity to the maximum and minimum values

end