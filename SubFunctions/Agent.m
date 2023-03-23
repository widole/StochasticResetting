%% Script for creating Agents

classdef Agent

    properties


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

        function self = init(self, reset, params)
            
            % Initializing the agent, give it a start location and
            % rotation. It should also initialize the counters for tumbling
            % and resetting.

            % Initialize the rotation to random value between [-pi, pi]
            self.theta = (-1 + 2*rand) * pi;

            % Get initial velocity (is set in params)
            self.v = params.v;

            % Initialize start position of agent
            self.x = 0;
            self.y = 0;

            % What should the memory array contain for stochastic
            % resetting? (TO DO)
            self.mem_arr = [0; 0];
            

            % Create counter for the agent (the counter keeps track of the
            % tumbling rate/run time, as well as the stochastic resetting
            % times)
            self.counter = Counter();

            % Initiate the counter
            self.counter = self.counter.init(reset, params);

        % End init function
        end

        % Updates the current position
        function self = move(self, curr_res, world, params)


            % If we are returning home, then the agent should turn towards
            % middle constantly
            if self.return_home
                % Find direction of home and set as angle
                self.theta = atan2((0 - self.y), (0 - self.x));
            end

            % Update X and Y
            dx = self.v * params.dt * cos(self.theta);
            dy = self.v * params.dt * sin(self.theta);

            % Check world, if position allowed
            [self.x, self.y] = world.corr_pose(self.x, self.y, dx, dy);

            % Check if close enough to home to break return home motion
            if (abs(self.x) < params.epsilon && ...
                    abs(self.y) < params.epsilon)
                self.return_home = 0;
            end

            % Update the counters
            [self.counter, rt_reset, sr_reset] = ...
                self.counter.upd_counters( ...
                self.return_home, curr_res, self.mem_arr, params);

            % If counters have resetted, then perform the actions
            if rt_reset == true
                % Rotate
                self = self.rotate(params);
            end
            if sr_reset == true
                % Return home
                self = self.ret_home();
            end

        end

        function self = rotate(self, params)
            
            % Update agents rotation
            if (self.return_home)
                self.theta = self.theta;
            else
                self.theta = self.theta + (-1 + 2*rand) * params.rot_upd;
            end

        end

        function self = ret_home(self)

            % Set that agent is returning home
            self.return_home = 1;

            % Find direction of home and set as angle
            self.theta = atan2((0 - self.y), (0 - self.x));

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