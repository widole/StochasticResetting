%% Script for creating Agents

classdef Agent

    properties
        % Necessary properties of agent class

        % Agent identifiers
        i;
        j;

        % Position and motion
        x;
        y;
        theta;
        v;

        % Homecoming boolean (1 if agent is returning, 0 if agent is
        % searching)
        return_home = 0;

        % Memory array of agent, storing what it has explored
        mem_arr;

        % Counter that is agent specific (rotation and run counters)
        counter;

        % Boolean for storing if the goal has been found or not
        g_found = false;

    end
    
    methods
        % Agent specific functions

        function self = init_agent(self, sim_id, params, i, j)
            % Initializing the agent

            % Initialize the rotation to random value between [-pi, pi]
            self.theta = (-1 + 2*rand) * pi;

            % Get initial velocity (is set in params)
            self.v = params.v;

            % Initialize start position of agent
            if strcmp(sim_id, 'sr')
                % if stochastic resetting simulation is started, then the
                % agent should be first in origin (i.e. [0, 0])

                self.x = 0;
                self.y = 0;

            else
                % If not stochastic reset, then the agent can start with in
                % [-2, 2] * cell_size of arena.

                self.x = 2 * params.cell_size * (-1 + 2*rand);
                self.y = 2 * params.cell_size * (-1 + 2*rand);
                
            end

            % Initiate the memory array, in the beginning it is empty
            if strcmp(sim_id, 'ga')
                % If genetic algorithm simulation is run, then the agent
                % should initiate a 256 element long array, which should
                % store whether the agent has found a place it has not yet
                % been at or not. (256 is set as a parameter in params)

                self.mem_arr = [zeros(params.mem_sz - 1, 1); 1];

            elseif strcmp(sim_id, 'lf')
                % If levy flight, what do we use the memory array for then?

                self.mem_arr = 0;

            elseif strcmp(sim_id, 'sr')
                % For stochastic resetting, the memory array should
                % contain, the time length since last reset + the distance
                % from origin?

                self.mem_arr = [0; 0];
                
            end
            

            % Create counter for the agent (the counter keeps track of the
            % tumbling rate/run time, as well as the stochastic resetting
            % times)
            self.counter = Counter();

            % Initiate the counters
            self.counter = self.counter.init_counter( ...
                self.mem_arr, sim_id, params, i, j);

        % End function
        end

        % Updates the current position
        function self = move(self, sim_id, res, world_params, params)


            %% Update x and y

            % x position update
            dx = self.v * params.dt * cos(self.theta);

            % y position update
            dy = self.v * params.dt * sin(self.theta);

            % Update position according to world
            self = self.cmp_pose_world(world_params, dx, dy);

            %% Update stochastic reset

            % For stochastic resetting, check if close enough to home
            if (abs(self.x) < params.epsilon && abs(self.y) < params.epsilon)

                self.return_home = 0;

            end

            %% Check counters

            % Update counters
            [self.counter, eff_reset, stoch_reset] = self.counter.upd_counters(sim_id, self.return_home, res, self.mem_arr, params);

            % Check if counters were reset, then perform action
            if eff_reset == true

                % Rotate
                self = self.rotate(params);

            % End if
            end

            if stoch_reset == true

                % Set return home policy
                self = self.sto_res();

            % End if
            end

        end

        % Check agents position compared to world and it parameters
        function self = cmp_pose_world(self, world_params, dx, dy)

            % First check if the agent is inside the boundary box, if there
            % is one
            switch world_params.bnd_cond

                % Case for when we have unbounded
                
                case 0

                    % Nothing happens
                    self.x = self.x + dx;
                    self.y = self.y + dy;

                % Case when we have periodic boundary
                case 1

                    % check for x
                    if ((self.x + dx) > world_params.wrld_sz) || ...
                            ((self.x + dx) < -world_params.wrld_sz)

                        self.x = -self.x + dx;

                    else

                        self.x = self.x + dx;

                    end

                    % check for y
                    if ((self.y + dy) > world_params.wrld_sz) || ...
                            ((self.y + dy) < -world_params.wrld_sz)

                        self.y = -self.y + dy;

                    else

                        self.y = self.y + dy;

                    end

                % Fixed boundaries
                case 2

                    % Check for x
                    if (abs(self.x + dx) > world_params.wrld_sz)

                        self.x = sign(self.x + dx) * world_params.wrld_sz;

                    else

                        self.x = self.x + dx;

                    end

                    % Check for y
                    if (abs(self.y + dy) > world_params.wrld_sz)

                        self.y = sign(self.y + dy) * world_params.wrld_sz;

                    else

                        self.y = self.y + dy;

                    end

                % Check for bounce boundaries
%                 case 3
%                     % Check for x
%                     if (abs(agent.x + dx) > self.wlrd_sz)
%                         x = sign(agent.x + dx) * self.wlrd_sz - ...
%                             sign(dx) * (agent.x + dx - sign(agent.x + dx) * self.wlrd_sz);
%                         % Rotation
%                         theta = agent.theta + sign(dy) * pi/2;
%                     else
%                         x = agent.x + dx;
%                         theta = agent.theta;
%                     end
%                     % Check for y
%                     if (abs(agent.y + dy) > self.wlrd_sz)
%                         y = sign(agent.y + dy) * self.wlrd_sz - ...
%                             sign(dy) * (agent.y + dy - sign(agent.y + dy) * self.wlrd_sz);
%                         % Rotation
%                         theta = agent.theta - sign(dx) * pi/2;
%                     else
%                         y = agent.y + dy;
%                         theta = agent.theta;
%                     end
                    
                    
            end

        end

        
        function self = rotate(self, params)
            % Update the agents rotation (theta)

            if (self.return_home)
                self.theta = self.theta;
            else
                % Update the particles rotation
                self.theta = self.theta + (-1 + 2*rand) * params.rot_upd;
            end

        end

        % Reset agent position to origin
        function self = sto_res(self)

            % Reset position to 0
%             self.x = 0;
%             self.y = 0;


            % Set global value to 1 to show current resetting
            self.return_home = 1;

            % Find direction of home and set as angle
            self.theta = atan2((0 - self.y), (0 - self.x));

        end

        % Update memory of agent
        function self = upd_mem(self, found_area)

            % Find which area the agent has visited
            self.mem_arr = [self.mem_arr(2:end); found_area];

        end

        % Reset agent
        function self = reset(self, agentType, wb, params)

            % Reset agents rotation
            self.theta = (-1 + 2*rand) * pi;

            % Reset agents position
            if params.stoch_res

                % If stochastic resetting is used, then the agents always
                % starts at origin
                self.x = 0;
                self.y = 0;

            else

                % Init position, if not stochastic resetting is used, then
                % the agent should start at random location
                self.x = 2 * params.cell_size * (-1 + 2*rand);
                self.y = 2 * params.cell_size * (-1 + 2*rand);
                
            end

            % Set new neural network parameters if wb was supplied
            if strcmp(agentType, 'GA')


                


                %% Set the supplied weights and biases
                % Get size of hidden weights
                hweights_size = size(self.counter.eff_gen.hidden_weights);
                % Reshape to correct size
                hweights = reshape(wb(1:hweights_size(1)*hweights_size(2)), hweights_size(1), hweights_size(2));
                % Get size of output weights
                oweights_size = size(self.counter.eff_gen.output_weights);
                % Reshape to correct size
                oweights = reshape(wb(hweights_size(1)*hweights_size(2)+1:end), oweights_size(1), oweights_size(2));

                
                %% Print out comparison

                disp("Original Hidden")
                self.counter.eff_gen.hidden_weights
                disp("New Hidden")
                hweights

                disp("Original Output")
                self.counter.eff_gen.output_weights
                disp("New Output")
                oweights


                % Update weights and biases
                self.counter.eff_gen.hidden_weights = hweights;
                self.counter.eff_gen.output_weights = oweights;

            end

            % Reset memory
            self.mem_arr = [zeros(params.mem_sz - 1, 1); 1];

            % Reset counters
            self.counter = self.counter.reset(self.mem_arr);

        % End function
        end

        function self = found_goal(self)
            % If the goal is found, then we update the variable here

            self.g_found = true;

            % Stop the timer
            self.counter = self.counter.g_found();

        % End function
        end

    end

end