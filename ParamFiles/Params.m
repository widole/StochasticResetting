%% Parameter File
% Here the parameter class is define, the instance of this class will
% contain all the parameters necessary for simulation. For different
% simulations, different parameters should be used.

classdef Params

    properties
        
        %% Simulation parameters (user-set)

        % Suppress plotting during simulation
        sup_plot = false;

        % Save found areas
        sav_area = true;

        % Save position array
        sav_pose = true;

        %% Simulation iteration parameters (can be set by user)

        % Numnber of resistance value pair to investigate
%         nr_r = 1;

        % Number of alpha values to check
%         nr_a = 1;

        % Number of simulations per alpha/resistance pair to check
%         nr_s = 1;

        %% Simulation time parameters (can be set by user)
        % Time step
        dt = 0.5;

        % Simulation steps
        N = 10^(6); %256; % 10^(4);

        
        %% Particle behaviour parameters (changes to the distributions can be changed by user)
        % Particle velocity
        v = 0.01;

        % Particles rotation update
        rot_upd = pi / 6;



        % Stochastic resetting

        % If stochastic resetting is used or not (0 for no, 1 for yes)
        stoch_res = 0;

        % Stochastic resetting rate
        stoch_r = .02; % .05

        % Memory size of agent
        mem_sz = 256;

        
        %% World/environment parameters (changes to obstacles, boundaries, etc)
        % Obstacle identification (0 for no obstacles, 1 for convex
        % obstacles and 2 for concave obstacles)
        obst_id = 0;

        % Boundary conditions (0 = unbounded, 1 = periodic, 2 = fixed, 3 =
        % bounce)
        bnd_cond = 0;

        % Size of cells in environment (i.e. the length between resistance
        % variations
        cell_size = 1;

        % Area units (i.e. the set size of "explorable" environment points)
        area_unit = 0.05;

        % Home epsilon
        epsilon = 0.005;

        % Set the world size, as in how many cells it should contain
        world_size = 3;

        % Set to true if world should have a goal point (point/area that
        % indicates a goal)
        goal = true;

        % goal radius
        goal_rad = .05;

        % Resistance of environment
        env_r = [0, 0];

        %% Genetic Algorithm parameters
       
        % Populations size
        pop_size = 100;


        % Mutation rate
        p = 0.01;

        %% Levy flight parameters

        % Decide the alpha values to test
        alpha = [1, 1.05, 1.1, 1.15, 1.20, 1.25, 1.30, 1.35, 1.40, ...
            1.45, 1.50, 1.55, 1.60, 1.65, 1.70, 1.75, 1.80, 1.85, 1.90, ...
            1.95, 2];

        % Set effort levy distribution values
        beta = 0;       % Beta (For actual levy flight, should be 1?)
        gamma = 1;      % c?
        delta = 0;      % mu?


        %% Population parameters

        % amount of agents to average over
        nr_agents = 100;

        % nr of generations to run
        nr_population = 300;

        %% Neural Network parameters

        nr_input_nodes = 4;

        nr_hidden_nodes = 2;

        nr_output_nodes = 1;

        init_weight_max = .5;

    end

end