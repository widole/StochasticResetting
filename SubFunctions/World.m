%% Create the world class
% This is the main class called by the simulation classes (either compare
% different strategies, simulate certain strategies or the genetic
% algorithm training) The world contains both the environment as well as
% the population of agents.

classdef World

    %% Defining the properties of the class
    properties

        %% World

        world_params;

        %% Population

        pop;

        %% Found goal

        found_goal;

    end

    %% Defining the methods of the class
    methods

        % Initialize world
        function self = init_world(self, params)

            %% Set world_type
            % can be 0 for clean environment, 1 for convex
            % obstacles and 2 for concave obstacles

            self.world_params.world_type = params.obst_id;

            %% Set boundary condition
            % This can 0 for unbounded environment, 1 for periodic
            % boundaries, 2 for fixed boundaries or 3 for bouncy boundaries

            self.world_params.bnd_cond = params.bnd_cond;

            %% Set cell_size
            % The cell size defines how close together and large the
            % obstacles in the environment are

            self.world_params.cell_size = params.cell_size;

            %% Set area_unit
            % Areas units are the smallest area in the environment, this is
            % what is used to determine if an agents has discovered a part
            % of the environment or not

            self.world_params.area_unit = params.area_unit;

            %% Set world size
            % If the world is bounded, then we set the world size as a
            % certain determined amount of cells

            if (params.bnd_cond ~= 0)

                self.world_params.wrld_sz = ...
                    params.world_size * self.world_params.cell_size;

            else

                self.world_params.wrld_sz = 0;

            % End if statement
            end

            %% Set goal point
            % If specific goal point will be used, then create random goal
            % in world

            if params.goal

                % Set goal to true
                self.world_params.goal.exists = true;

                % Find a random initial point
                r_tmp = (.2 + (1 - .2) * rand);
                theta_tmp = 2 * pi * rand;
                self.world_params.goal.center = ...
                    r_tmp * [cos(theta_tmp); sin(theta_tmp)];

                % Find radius
                self.world_params.goal.rad = params.goal_rad;

            % End if statement
            end

            %% Set obstacles size
            % if obstacles is to be used, then we set the radius of the
            % obstacles here, this will be used to check if the agents are
            % not inside the obstacles in the environment
            
            % Check the world type first
            switch self.world_params.world_type

                % If no obstacles
                case 0

                    self.world_params.obst_rad = -1;

                % If we have convex obstacles
                case 1

                    self.world_params.obst_rad = ...
                        0.8 * self.world_params.cell_size / 2;

                % If we have concave obstacles
                case 2

                    self.world_params.obst_rad = ...
                        sqrt((0.2)^(2) + 1) * self.world_params.cell_size / 2;

                % What was this used for? I dont even remember, I think for
                % bouncy boundary conditions
%                 case 3
%                     % Add number for nr of boxes to use
%                     tmp_box_nr = 1;
% 
%                     % Create boundary box
%                     self.obst_rad = tmp_box_nr * self.cell_size;
% 
%                     % Create linspaces for creating the gradient of box
%                     xy_grad = linspace(-tmp_box_nr * self.cell_size, ...
%                         tmp_box_nr * self.cell_size, tmp_box_nr * 20);
% 
%                     % Create gradient matrix
%                     self.grad_matrix = exp(-(xy_grad.^2 + (xy_grad.^2)'));


            % End of switch statement
            end

        % End of init function
        end

        % Initiate inhabitants
        function self = init_population(self, sim_id, params)

            %% Create population of agents

            % Number of agents (i.e. population size)
            if strcmp(sim_id, 'ga')

                % For genetic algorithm, the population size is
                % pre-determined in the params file.

                nr_hetero = params.pop_size;

            elseif strcmp(sim_id, 'lf')
                
                % For levy flights, the population size is determined in
                % how many alpha values we want to simulatenously test. The
                % array of alpha values is also stated in params

                nr_hetero = length(params.alpha);

            elseif strcmp(sim_id, 'sr')

                % For stochastic resetting we have a fixed amount of
                % heterogenous agents that we test against each other

                nr_hetero = 4; % 4;

            end

            %% Creating the simulated population
            % The size of the population will depend on two variables
            % agent(i,j), where i=0,...,N, where N = the number of
            % heterogenous agents we will compare (different alpha values,
            % stochastic resetting distribution or genetic algorithms), and
            % j=0,...,M, where M is the number of agents we want to average
            % over to get a more correct output.


            % for goes to N = nr_hetero, i.e. number of different
            % distributions or neural networks to run simulatenously.
            for i=1:nr_hetero

                % how many averaging agents do we have?
                for j=1:params.nr_agents

                    % Create agent
                    self.pop.agents(i, j) = Agent();
    
                    % Initiate each agent
                    self.pop.agents(i, j) = ...
                        self.pop.agents(i, j).init_agent( ...
                        sim_id, params, i, j);

                end

            end

            % Create and initialize the save variable class for the
            % population
            self.pop.savevar = SaveVar();

            self.pop.savevar = self.pop.savevar.init_savevar( ...
                sim_id, self.world_params, self.pop.agents, params);


            if params.goal
                % Create found_goal array to save whether an agent has
                % found the goal or not
                self.found_goal = zeros(size(self.pop.agents));

            % End if statement
            end
             

        % End function init_population
        end

        % Update world as a time step
        function self = move(self, sim_id, params)

            % Loop through all the agents in population
            for i=1:size(self.pop.agents, 1)

                for j=1:size(self.pop.agents, 2)

                    % Check current resistance
                    curr_res = self.set_res(i, j, params);
    
                    % Move agent
                    self.pop.agents(i, j) = self.pop.agents(i, j).move(sim_id, curr_res, self.world_params, params);

                    % Check if agent is at to goal


                    if params.goal
                        % If we are running stochastic resetting for example, where
                        % we want to find a specific goal. Then we test to see if
                        % the agents have found that goal, if so, then we save that
                        % value

                        % Calculate the distance to goal from current position
                        tmp_dist = sqrt( ...
                            (self.pop.agents(i, j).x - self.world_params.goal.center(1))^2 + ... 
                            (self.pop.agents(i, j).y - self.world_params.goal.center(2))^2);

                        % Check if distance is smaller than the radius of goal
                        if ((tmp_dist < self.world_params.goal.rad) && ...
                                (self.found_goal(i, j) ~= true))

                            % If the agents is inside the radius of the
                            % goal, then we have found the goal => the
                            % agent has finished
                            self.found_goal(i, j) = true;

                            % Display that we have found the goal
                            disp('Found goal!')

                            % Stop the timer!
                            self.pop.agents(i, j) = self.pop.agents(i, j).found_goal;

                        % End if
                        end

                    % End if
                    end  


                end

            % End for-loop
            end
 

            % Save variables
            [self.pop.savevar, ~] = self.pop.savevar.store_vars(sim_id, self.world_params, self.pop.agents, params);
            [~, self.pop.agents] = self.pop.savevar.store_vars(sim_id, self.world_params, self.pop.agents, params);

        % End function
        end

        % Set the resistance
        function res = set_res(self, i, j, params)

            % Check which resistance area the agent is inside
            x_cell = double(idivide(self.pop.agents(i, j).x, int8(self.world_params.cell_size), 'floor'));

            % Calculate the remainder of xCell / 2, should give us either a 0,
            % if xCell is even and 1 if xCell is odd
            remi_cell = rem(x_cell, 2);

            % Calculate the resistance
            if remi_cell == 0 
    
                res = params.env_r(1);
    
            else
    
                res = params.env_r(2);
    
            end

        end

        % Reset world population
        function self = reset_gen_GA(self, new_chromosomes, params)

            % Loop through the population
            for i=1:size(self.pop.agents, 1)
                for j=1:size(self.pop.agents, 2)

                    % Obtain weights and biases
                    tmp_wb = new_chromosomes{i, j};
    
                    % Reset agents
                    self.pop.agents(i, j) = self.pop.agents(i, j).reset('GA', tmp_wb, params);

                end
            % End for-loop
            end

            % Reset save variables class
            self.pop.savevar = self.pop.savevar.init_savevar(self.world_params, self.pop.agents, params);

        % End function
        end

    end


end