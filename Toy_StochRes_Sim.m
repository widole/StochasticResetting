%% Toy Stochastic Resetting Simulation
clear all;close all;clc

%% CREATE 1 STOCHASTIC RESETTING SIMULATION

% Time step
dt = 0.01;
N = 10^(4);

D = 0.5;


% Stochastic resetting distribution
sr_gen = makedist('Exponential', 'mu', 1 / 0.25);

% Draw resetting time
sr_time = abs(random(sr_gen));

% Save resetting points
res_indx = 1;

x_sr = zeros(N, 1);

for i=2:N

    % Resetting
    x_sr(i) = x_sr(i - 1) + sqrt(2*D*dt)*randn(1);

    % Check resetting
    sr_time = sr_time - dt;

    if (sr_time <= 0)
        x_sr(i) = 0;

        y_res(res_indx) = i;
        res_indx = res_indx + 1;

        sr_time = abs(random(sr_gen));
    end

end

t = linspace(0, dt*N, N)';

% Plotting motion
figure('name','resetting trajectory')
plot(t, x_sr, "Color", 'r')
hold on; grid on
for i=1:res_indx - 1
    plot([t(y_res(i) - 1), t(y_res(i))], [x_sr(y_res(i) - 1), 0], 'color', 'b', 'linewidth', 2)
end
xlabel('Time [s]')
ylabel('Position')
title('Trajectory of Agent with Resetting')


%% Brownian Motion Simulation
% Set-up simulations
% Time step
dt = 0.01;
% Nr steps
N = 10^(5);

% How many agents to average over
Nr_Agents = 1000;

% Simulate each agent
x = zeros(Nr_Agents, N);

for i=1:N

    for j=1:Nr_Agents

        x(j, i) = x(j, i) + randn(1);

    end

end




