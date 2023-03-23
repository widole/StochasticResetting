%% Counter class
% This class is used for generating values used as time lengths for
% rotating and resetting, as well as keeping track of the remaining time
% for each time step dt. Should be used as a sub-class for an agent, so
% that each agent has its own counter class.

classdef Counter

    properties
        % Necessary properties for the counter class

        % run time generator
        rt_generator;

        % stochastic reset time generator
        sr_generator;

        % variable for current run time
        r_time;

        % variable for current resetting time
        sr_time;

        % Timer for counting when goal was found
        t_goal = 0;
        % Boolean for if the agent has found the goal
        b_goal = false;

    end

    methods

        function self = init(self, reset, params)

            % First we create our run time generators, this is program
            % specific.
            % For stochastic resetting, what run time generator do
            % we want to use then? Right now we use a normal
            % distribution (stable with alpha = 2)

            % Load run time generator
            self.rt_generator = makedist('Stable', ...
                'alpha', params.alpha, ...
                'beta', params.beta, ...
                'gam', params.gamma, ...
                'delta', params.delta);

            % Create the stochastic resetting time generator, there are 3
            % choices, as input as reset. It can be 
            % 'no' = no resetting will occur
            % 'exp' = exponential distribution resetting time
            % 'int' = neural network generated resetting time
            switch reset

                case 'no'

                    % For no resetting, we create a normal distribution
                    % with 'inf' long mean time and no variance
                    self.sr_generator = makedist( ...
                        'normal', (params.N + 1) * params.dt, 0);

                case 'exp'
                    % Create exponential distribution to draw resetting
                    % time from

                    self.sr_generator = makedist( ...
                        'Exponential', 'mu', 1 / params.sr_rate);

                case 'int'
                    % This is for the neural network, it has not been
                    % implemented yet.

                    self.sr_generator = makedist( ...
                        'Exponential', 'mu', 1 / (2 * params.sr_rate));
                
            % End switch
            end


            % Draw initial values

            % Draw run time value
            self.r_time = self.draw_rt();

            % Draw stochastic resetting time value
            self.sr_time = self.draw_sr();


        % End function statement
        end

        function y = draw_rt(self)

            % The tumbling time for stochastic resetting is also
            % based on the stable distribution
            y = abs(random(self.rt_generator));

        % End draw_rt function
        end

        function y = draw_sr(self)

            % Draw stochastic resetting time from distribution
            y = abs(random(self.sr_generator));

        % End draw_sr function
        end

        function [self, rt_reset, sr_reset] = upd_counters(self, ret_home, res, mem_arr, params)

            % Initiate the return to false
            rt_reset = false;
            sr_reset = false;

            if ~(ret_home)
                % If the agent is not returning home currently, then we
                % should update our counters, but if it is, then we should
                % not
            

                % Update the effort value (run time)
                self.r_time = self.r_time - 2^(res) * params.dt;

                % Update the stochastic resetting value
                self.sr_time = self.sr_time - params.dt;

                if self.r_time <= 0
                    % If our run time value is at or below 0, then we
                    % should rotate and draw new

                    % set rotate output to true
                    rt_reset = true;
    
                    % Draw a new effort value
                    self.r_time = self.draw_rt();

                end

                if self.sr_time <= 0
                    % If our stochastic reset time value drops to or below
                    % 0, then we reset the agents position to home
                    
                    % set return home output to true
                    sr_reset = true;

                    % reset our stochastic reset timer
                    self.sr_time = self.draw_sr();
                    
                end

                % Update the goal timer
                if ~(self.b_goal)
                    self.t_goal = self.t_goal + params.dt;
                end

            end


            % Check goal found timer
            if (self.b_goal ~= true)

                self.t_goal = self.t_goal + params.dt;

            % End if
            end
            
        % End function
        end

        function self = g_found(self)

            % Check that goal is found
            b_goal = true;

        end


    % End methods
    end

% End class
end