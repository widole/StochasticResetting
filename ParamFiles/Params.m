%% Parameter File
% Here the parameter class is define, the instance of this class will
% contain all the parameters necessary for simulation. For different
% simulations, different parameters should be used.

classdef Params

    properties
        %% Simulation parameters

        % Time step
        dt = 0.5;

        % Simulation steps
        N = 10^(3);

        % Averaging number (how many agents to simulate and average over)
        ave_agent = 100;

        %% Particle Parameters

        % Velocity
        v = 0.01;

        % Rotation max
        rot_upd = pi / 6;

        % Stochastic resetting rates (What rates do we want to compare
        % between for checking if stochastic resetting works, and comparing
        % it to the intelligent version?)
        sr_rate = .02; % [0, .02, .2];

        % Memory size of agents (should agents have any memory in this
        % case?)
        mem_sz = 256;

        
        % Motion parameters
        alpha = 2;      % Stability parameter
        beta = 0;       % Beta (For actual levy flight, should be 1?)
        gamma = 1;      % c?
        delta = 0;      % mu?

        
        %% Environment Parameters

        % World resistance to motion
        res = 1;

        % Should we have obstacles in the arena (1 for yes, 0 for no)
        obstacles = 0;

        % Home epsilon (distances to absolute 0 that counts as home)
        epsilon = 0.005;

        % Boundary conditions (0 = unbounded, 1 = periodic, 2 = fixed, 3 =
        % bounce)
        bnd_cond = 2;

        % Set the world size, as in how many cells it should contain
        world_size = 3;

        % Size of cells in environment (i.e. the length between resistance
        % variations
        cell_size = 1;

        % Area units (i.e. the set size of "explorable" environment points)
        area_unit = 0.05;

        % Radius of the goal in the environment
        goal_rad = .05;

    end

end