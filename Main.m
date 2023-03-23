%% Main file for Stochastic Resetting Simulations
clear all; close all; clc
% This is the main file for the Stochastic Resetting project. For
% background please refer to Yael Roichman's research group at Tel Aviv
% University.

% Here we also want to add more details on how the simulations work.

% We want to compare the time to reach the goal (randomly placed in the
% arena) for an agent without resetting, with resetting of different
% values, as well as for intelligent resetting (i.e. the agent should learn
% when to reset).

% First we load the parameters-file
params = Params();

%% Run Main Simulation (Calls sub-script)

% Start Learning Phase (for learning agents, unless learning has already
% been done (should have a save file for latest intelligent agents
% resetting functionality))

% Start main simulation phase (comparison between all the different agents)
% Create the stochastic resetting class for simulations, this contains all
% the necessary parts for simulating stochastic resetting.
StochResSimClass = StochasticResettingSimulation();

% Initiate the stochastic resetting simulation class
StochResSimClass = StochResSimClass.init(params);

% Initiate plotting
% Create plotting instance
plotting = Plotting();
plotting = plotting.init( ...
    StochResSimClass.pop, StochResSimClass.world, params);

% Run the main simulation of stochastic resetting class
StochResSimClass = StochResSimClass.run(plotting, params);

% finish and show results from stochastic resetting
StochResSimClass = StochResSimClass.results(plotting, params);



%% Save the simulation results

% Get the date
date = datetime('today');
% Create file name
filename = sprintf('SavedResults\\%s.mat', date);

% Save file
save(filename, 'StochResSimClass');