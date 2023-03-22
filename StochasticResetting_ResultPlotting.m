%% Plotting Stochastic Resetting Results
% For presentation
clear all; clc

% Load the result file
sim_data = load('SavedResults/StochasticResetting_50kseconds_results4presentation.mat');


%% ---------- PLOTTING MOTION TRAJECTORIES ---------- %%

% First find the agents we want to plot
indx = randsample(1:50, 2);

% Agent 1
a1_x = sim_data.stochres.world.pop.savevar.pose_arr{1, indx(1)}(1,:);
a1_y = sim_data.stochres.world.pop.savevar.pose_arr{1, indx(1)}(2,:);

% Agent 2
a2_x = sim_data.stochres.world.pop.savevar.pose_arr{3, indx(2)}(1,:);
a2_y = sim_data.stochres.world.pop.savevar.pose_arr{3, indx(2)}(2,:);

figure('name', 'Trajectory')

% Plot the first agent
plot(a1_x, a1_y, 'color', 'b')
hold on; grid on

% Plot second agent
plot(a2_x, a2_y, 'color', 'r')

legend({'Non-resetting', 'Resetting'})
xlabel('Position')
ylabel('Position')
title('Trajectories of non-resetting (blue) and resetting (red) agents in space')

%% ---------- PLOTTING THE POSITION PROBABILITIES IN X AND Y ---------- %%

% Find different time scales to plot at
T_end = sim_data.params.N * sim_data.params.dt;

% How many plots to show
N_t = 5;

T1 = T_end / N_t;
T2 = 2*T1;
T3 = 3*T1;
T4 = 4*T1;
T5 = T_end;

% Get the non-resetting data
non_res_data = sim_data.stochres.world.pop.savevar.pose_arr(1,:);

% Get data for X and Y separate
for i=1:length(non_res_data)
    non_res_data_x(i,:) = non_res_data{i}(1,:);
    non_res_data_y(i,:) = non_res_data{i}(2,:);
end

% Get for T1
non_res_data_x_T1 = non_res_data_x(:, 1:T1/sim_data.params.dt);
non_res_data_y_T1 = non_res_data_y(:, 1:T1/sim_data.params.dt);
% Get for T2
non_res_data_x_T2 = non_res_data_x(:, 1:T2/sim_data.params.dt);
non_res_data_y_T2 = non_res_data_y(:, 1:T2/sim_data.params.dt);
% Get for T3
non_res_data_x_T3 = non_res_data_x(:, 1:T3/sim_data.params.dt);
non_res_data_y_T3 = non_res_data_y(:, 1:T3/sim_data.params.dt);
% Get for T4
non_res_data_x_T4 = non_res_data_x(:, 1:T4/sim_data.params.dt);
non_res_data_y_T4 = non_res_data_y(:, 1:T4/sim_data.params.dt);
% Get for T5
non_res_data_x_T5 = non_res_data_x(:, 1:T5/sim_data.params.dt);
non_res_data_y_T5 = non_res_data_y(:, 1:T5/sim_data.params.dt);


% reshape for histogram
% T1
non_res_data_x_T1 = reshape(non_res_data_x_T1, ...
    [size(non_res_data_x_T1,1)*size(non_res_data_x_T1,2), 1]);
non_res_data_y_T1 = reshape(non_res_data_y_T1, ...
    [size(non_res_data_y_T1,1)*size(non_res_data_y_T1,2), 1]);
% T2
non_res_data_x_T2 = reshape(non_res_data_x_T2, ...
    [size(non_res_data_x_T2,1)*size(non_res_data_x_T2,2), 1]);
non_res_data_y_T2 = reshape(non_res_data_y_T2, ...
    [size(non_res_data_y_T2,1)*size(non_res_data_y_T2,2), 1]);
% T3
non_res_data_x_T3 = reshape(non_res_data_x_T3, ...
    [size(non_res_data_x_T3,1)*size(non_res_data_x_T3,2), 1]);
non_res_data_y_T3 = reshape(non_res_data_y_T3, ...
    [size(non_res_data_y_T3,1)*size(non_res_data_y_T3,2), 1]);
% T4
non_res_data_x_T4 = reshape(non_res_data_x_T4, ...
    [size(non_res_data_x_T4,1)*size(non_res_data_x_T4,2), 1]);
non_res_data_y_T4 = reshape(non_res_data_y_T4, ...
    [size(non_res_data_y_T4,1)*size(non_res_data_y_T4,2), 1]);
% T5
non_res_data_x_T5 = reshape(non_res_data_x_T5, ...
    [size(non_res_data_x_T5,1)*size(non_res_data_x_T5,2), 1]);
non_res_data_y_T5 = reshape(non_res_data_y_T5, ...
    [size(non_res_data_y_T5,1)*size(non_res_data_y_T5,2), 1]);

% Specify the number of bars
num_bars = 20;
% Get the histogram values
% For x
[non_n1_x, non_x1] = hist(non_res_data_x_T1, num_bars);
[non_n2_x, non_x2] = hist(non_res_data_x_T2, num_bars);
[non_n3_x, non_x3] = hist(non_res_data_x_T3, num_bars);
[non_n4_x, non_x4] = hist(non_res_data_x_T4, num_bars);
[non_n5_x, non_x5] = hist(non_res_data_x_T5, num_bars);
% For y
[non_n1_y, non_y1] = hist(non_res_data_y_T1, num_bars);
[non_n2_y, non_y2] = hist(non_res_data_y_T2, num_bars);
[non_n3_y, non_y3] = hist(non_res_data_y_T3, num_bars);
[non_n4_y, non_y4] = hist(non_res_data_y_T4, num_bars);
[non_n5_y, non_y5] = hist(non_res_data_y_T5, num_bars);

% Normalize the data
% For x
non_n1_x_normalized = non_n1_x/numel(non_res_data_x_T1)/(non_x1(2)-non_x1(1)); 
non_n2_x_normalized = non_n2_x/numel(non_res_data_x_T2)/(non_x2(2)-non_x2(1));
non_n3_x_normalized = non_n3_x/numel(non_res_data_x_T3)/(non_x3(2)-non_x3(1));
non_n4_x_normalized = non_n4_x/numel(non_res_data_x_T4)/(non_x4(2)-non_x4(1));
non_n5_x_normalized = non_n5_x/numel(non_res_data_x_T5)/(non_x5(2)-non_x5(1));
% For y
non_n1_y_normalized = non_n1_y/numel(non_res_data_y_T1)/(non_y1(2)-non_y1(1)); 
non_n2_y_normalized = non_n2_y/numel(non_res_data_y_T2)/(non_y2(2)-non_y2(1));
non_n3_y_normalized = non_n3_y/numel(non_res_data_y_T3)/(non_y3(2)-non_y3(1));
non_n4_y_normalized = non_n4_y/numel(non_res_data_y_T4)/(non_y4(2)-non_y4(1));
non_n5_y_normalized = non_n5_y/numel(non_res_data_y_T5)/(non_y5(2)-non_y5(1));

% Plotting
figure('name', 'Position Probability Non-resetting')
% Plot x
subplot(1,2,1)
plot(non_x1, non_n1_x_normalized, 'r');
hold on; grid on
plot(non_x2, non_n2_x_normalized, 'b');
plot(non_x3, non_n3_x_normalized, ':', 'color', 'r');
plot(non_x4, non_n4_x_normalized, ':', 'color', 'b');
plot(non_x5, non_n5_x_normalized, '--', 'color', 'r');
xlim([-10, 10])
title({'Non-Resetting Agents Position Density Function', 'for x'})
xlabel('Positions in X')
ylabel('Frequency')
% Plot y
subplot(1,2,2)
plot(non_y1, non_n1_y_normalized, 'r');
hold on; grid on
plot(non_y2, non_n2_y_normalized, 'b');
plot(non_y3, non_n3_y_normalized, ':', 'color', 'r');
plot(non_y4, non_n4_y_normalized, ':', 'color', 'b');
plot(non_y5, non_n5_y_normalized, '--', 'color', 'r');
xlim([-10, 10])
title({'Non-Resetting Agents Position Density Function', 'for y'})
xlabel('Positions in Y')
ylabel('Frequency')

% Get the resetting data
res_data = sim_data.stochres.world.pop.savevar.pose_arr(3,:);

% Get data for X and Y separate
for i=1:length(res_data)
    res_data_x(i,:) = res_data{i}(1,:);
    res_data_y(i,:) = res_data{i}(2,:);
end

% Get for T1
res_data_x_T1 = res_data_x(:, 1:T1/sim_data.params.dt);
res_data_y_T1 = res_data_y(:, 1:T1/sim_data.params.dt);
% Get for T2
res_data_x_T2 = res_data_x(:, 1:T2/sim_data.params.dt);
res_data_y_T2 = res_data_y(:, 1:T2/sim_data.params.dt);
% Get for T3
res_data_x_T3 = res_data_x(:, 1:T3/sim_data.params.dt);
res_data_y_T3 = res_data_y(:, 1:T3/sim_data.params.dt);
% Get for T4
res_data_x_T4 = res_data_x(:, 1:T4/sim_data.params.dt);
res_data_y_T4 = res_data_y(:, 1:T4/sim_data.params.dt);
% Get for T5
res_data_x_T5 = res_data_x(:, 1:T5/sim_data.params.dt);
res_data_y_T5 = res_data_y(:, 1:T5/sim_data.params.dt);


% reshape for histogram
% For x
res_data_x_T1 = reshape(res_data_x_T1, ...
    [size(res_data_x_T1,1)*size(res_data_x_T1,2), 1]);
res_data_x_T2 = reshape(res_data_x_T2, ...
    [size(res_data_x_T2,1)*size(res_data_x_T2,2), 1]);
res_data_x_T3 = reshape(res_data_x_T3, ...
    [size(res_data_x_T3,1)*size(res_data_x_T3,2), 1]);
res_data_x_T4 = reshape(res_data_x_T4, ...
    [size(res_data_x_T4,1)*size(res_data_x_T4,2), 1]);
res_data_x_T5 = reshape(res_data_x_T5, ...
    [size(res_data_x_T5,1)*size(res_data_x_T5,2), 1]);
% For y
res_data_y_T1 = reshape(res_data_y_T1, ...
    [size(res_data_y_T1,1)*size(res_data_y_T1,2), 1]);
res_data_y_T2 = reshape(res_data_y_T2, ...
    [size(res_data_y_T2,1)*size(res_data_y_T2,2), 1]);
res_data_y_T3 = reshape(res_data_y_T3, ...
    [size(res_data_y_T3,1)*size(res_data_y_T3,2), 1]);
res_data_y_T4 = reshape(res_data_y_T4, ...
    [size(res_data_y_T4,1)*size(res_data_y_T4,2), 1]);
res_data_y_T5 = reshape(res_data_y_T5, ...
    [size(res_data_y_T5,1)*size(res_data_y_T5,2), 1]);

% Specify the number of bars
num_bars = 20;
% Get the histogram values
% For x
[n1_x, x1] = hist(res_data_x_T1, num_bars);
[n2_x, x2] = hist(res_data_x_T2, num_bars);
[n3_x, x3] = hist(res_data_x_T3, num_bars);
[n4_x, x4] = hist(res_data_x_T4, num_bars);
[n5_x, x5] = hist(res_data_x_T5, num_bars);
% For y
[n1_y, y1] = hist(res_data_y_T1, num_bars);
[n2_y, y2] = hist(res_data_y_T2, num_bars);
[n3_y, y3] = hist(res_data_y_T3, num_bars);
[n4_y, y4] = hist(res_data_y_T4, num_bars);
[n5_y, y5] = hist(res_data_y_T5, num_bars);

% Normalize the data
% for x
n1_x_normalized = n1_x/numel(res_data_x_T1)/(x1(2)-x1(1)); 
n2_x_normalized = n2_x/numel(res_data_x_T2)/(x2(2)-x2(1));
n3_x_normalized = n3_x/numel(res_data_x_T3)/(x3(2)-x3(1));
n4_x_normalized = n4_x/numel(res_data_x_T4)/(x4(2)-x4(1));
n5_x_normalized = n5_x/numel(res_data_x_T5)/(x5(2)-x5(1));
% For y
n1_y_normalized = n1_y/numel(res_data_y_T1)/(y1(2)-y1(1)); 
n2_y_normalized = n2_y/numel(res_data_y_T2)/(y2(2)-y2(1));
n3_y_normalized = n3_y/numel(res_data_y_T3)/(y3(2)-y3(1));
n4_y_normalized = n4_y/numel(res_data_y_T4)/(y4(2)-y4(1));
n5_y_normalized = n5_y/numel(res_data_y_T5)/(y5(2)-y5(1));

% Plotting
figure('name', 'Position Probability resetting')
% For x
subplot(1,2,1)
plot(x1, n1_x_normalized, 'r');
hold on; grid on
plot(x2, n2_x_normalized, 'b');
plot(x3, n3_x_normalized, ':', 'color', 'r');
plot(x4, n4_x_normalized, ':', 'color', 'b');
plot(x5, n5_x_normalized, '--', 'color', 'r');
xlim([-10, 10])
title({'Resetting Agents Position Density Function', 'for x'})
xlabel('Positions in X')
ylabel('Frequency')
% For y
subplot(1,2,2)
plot(y1, n1_y_normalized, 'r');
hold on; grid on
plot(y2, n2_y_normalized, 'b');
plot(y3, n3_y_normalized, ':', 'color', 'r');
plot(y4, n4_y_normalized, ':', 'color', 'b');
plot(y5, n5_y_normalized, '--', 'color', 'r');
xlim([-10, 10])
title({'Resetting Agents Position Density Function', 'for y'})
xlabel('Positions in Y')
ylabel('Frequency')



%% ---------- PLOT OF MSD FOR BOTH CASES ---------- %%

% Initialize the MSD array
MSD = zeros(2, sim_data.params.N);

        
% Calculate the MSD for the trajectories
for i=1:sim_data.params.N
    % Go through all the simulation steps

    % run through all the averaging agents
    for k=1:size(sim_data.stochres.world.pop.savevar.pose_arr, 2)

        % For the non-resetting
        MSD(1, i) = MSD(1, i) + ( ...
            (sim_data.stochres.world.pop.savevar.pose_arr{1, k}(1, i) - ...
            sim_data.stochres.world.pop.savevar.pose_arr{1, k}(1, 1))^2 +  ...
            (sim_data.stochres.world.pop.savevar.pose_arr{1, k}(2, i) - ...
            sim_data.stochres.world.pop.savevar.pose_arr{1, k}(2, 1))^2);

        % For the resetting
        MSD(2, i) = MSD(2, i) + ( ...
            (sim_data.stochres.world.pop.savevar.pose_arr{3, k}(1, i) - ...
            sim_data.stochres.world.pop.savevar.pose_arr{3, k}(1, 1))^2 +  ...
            (sim_data.stochres.world.pop.savevar.pose_arr{3, k}(2, i) - ...
            sim_data.stochres.world.pop.savevar.pose_arr{3, k}(2, 1))^2);

    end
end

% Divide by the number of averaging agents
MSD = MSD / size(sim_data.stochres.world.pop.savevar.pose_arr, 2);

% Plot the MSD
figure('name', 'MSD')
loglog(1:sim_data.params.N, MSD(1,:), 'linewidth', 2)
hold on; grid on
loglog(1:sim_data.params.N, MSD(2,:), 'linewidth', 2)
title({'Mean Square Displacement of', 'non-resetting and resetting agents'})
legend({'Non-resetting', 'Resetting'})
xlabel('Time')
ylabel('MSD')


%% ---------- PLOT TIME TIL GOAL ---------- %%

% Initialize time
t2goal = zeros(2, 1);

for i=1:size(sim_data.stochres.world.pop.agents, 2)
    % For each averaging agent

    % Add the time til goal was found for non-resetting
    t2goal(1) = t2goal(1) + sim_data.stochres.world.pop.agents(1, i).counter.t_goal;

    % Add the time til goal was found for resetting
    t2goal(2) = t2goal(2) + sim_data.stochres.world.pop.agents(3, i).counter.t_goal;


% End for
end

% Average the t2goal
t2goal = t2goal / i;

% Print
fprintf('--------------------------------------------------------- \n')
fprintf('FTP average over %d agents for non-resetting = %.2f s \n', i, t2goal(1))
fprintf('--------------------------------------------------------- \n')
fprintf('FTP average over %d agents for resetting = %.2f s \n', i, t2goal(2))
fprintf('--------------------------------------------------------- \n')
