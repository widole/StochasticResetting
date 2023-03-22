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
        srt_generator;

        % variable for current run time
        r_time;

        % variable for current resetting time
        s_time;

        % Timer for counting when goal was found
        t_goal = 0;
        % Boolean for if the agent has found the goal
        b_goal = false;

    end

    methods
        % necessary functions for the counter class

        % Initialize the counter
        function self = init_counter(self, mem_arr, sim_id, params, i, j)

            % First we create our run time generators, this is program
            % specific.
            switch sim_id

                case 'ga'
                    % In the case of genetic algorithm, we create a neural
                    % network to take care of the run times

                    % Load run time generator
                    self.rt_generator = NeuralNetwork();

                    % Initiate run time generator
                    self.rt_generator = ...
                        self.rt_generator.init_NeuralNetwork(params);

                case 'lf'
                    % For levy flight, the run time generator is the levy
                    % distribution from which we will take run time values

                    % Load run time generator
                    self.rt_generator = makedist('Stable', ...
                        'alpha', params.alpha(i), ...
                        'beta', params.beta, ...
                        'gam', params.gamma, ...
                        'delta', params.delta);

                case 'sr'
                    % For stochastic resetting, what run time generator do
                    % we want to use then? Right now we use a normal
                    % distribution (stable with alpha = 2)

                    % Load run time generator
                    self.rt_generator = makedist('Stable', ...
                        'alpha', 2, ...
                        'beta', params.beta, ...
                        'gam', params.gamma, ...
                        'delta', params.delta);

            % End switch
            end

            % Stochastic resetting generator, if stochastic reset is the
            % program of choice
            if strcmp(sim_id, 'sr')
                % The stochastic resetting function should be also
                % dependent on the heterogenity number of the agent.
                % Ranging from no resetting, fixed time resetting,
                % exponential and "smart" resetting.

                % Create generators
                switch i
                    case 1
                        % In the first case, the generator is infinite,
                        % since we do not want to reset.

                        self.srt_generator = makedist('normal', (params.N + 1) * params.dt, 0);

                    case 2
                        % In the second case, we have a fixed reset time.
                        % What this time should be can depend on a lot of
                        % parameters but we should try to find a value that
                        % is somewhat good.

                        self.srt_generator = makedist('normal', 10, 0);

                    case 3
                        % Case 3, is the exponential distribution case, now
                        % the stochastic resetting time values will be
                        % taken from an exponential distribution.

                        self.srt_generator = makedist( ...
                            'Exponential', 'mu', 1 / params.stoch_r);

                    case 4
                        % Case 4 is smart, this should contain a neural
                        % network, that will create stochastic resetting
                        % values for optimizing resetting times. NOT BEEN
                        % IMPLEMENTED YET

                        self.srt_generator = makedist( ...
                            'Exponential', 'mu', 1 / (2 * params.stoch_r));
                
                % End switch
                end
                

            % End if
            end

            % Draw initial values

            % Draw run time value
            self.r_time = self.draw_rt(sim_id, mem_arr);

            % Draw stochastic resetting time value
            self.s_time = self.draw_srt(sim_id);


        % End function statement
        end

        % Function for drawing effort value
        function y = draw_rt(self, sim_id, mem_arr)

            % Way of creating effort value depends on program
            switch sim_id

                % For genetic algorithm
                case 'ga'

                    % Draw value from neural network
                    x = self.get_net_inp(mem_arr)'; % {0, 0, 0, 0}';
                    y = self.rt_generator.get_output(x);

                case 'lf'

                    y = abs(random(self.rt_generator));

                case 'sr'
                    % The tumbling time for stochastic resetting is also
                    % based on the stable distribution

                    y = abs(random(self.rt_generator));

            % End switch
            end

        % End function statement
        end

        % Function to turn memory array to valid input to network
        function x = get_net_inp(self, mem_arr)

            % Loop through the 4 inputs
            for i=1:4

                % Start ind
                i_start = (i-1)*64 + 1;
                
                % End index
                i_stop = i*64;
                
                x{i} = sum(mem_arr(i_start:i_stop));

            % End for-loop
            end

        % End function
        end
        
        % Update the counters i.e. count down, and if that is the case =>
        % do actions
        function [self, eff_reset, stoch_reset] = upd_counters(self, sim_id, return_home, res, mem_arr, params)

            % Initiate the return to false
            eff_reset = false;
            stoch_reset = false;
            

            %% Update the effort value
            self.r_time = self.r_time - 2^(res) * params.dt;

            % Check if we are currently not moving towards home
            % (stochasrtic resetting)
            if ~(return_home)
    
                % Check if our effort value is or below 0
                if self.r_time <= 0
    
                    % if the effort drops to or below 0 then we should
                    % update the agents rotation, this will be done by
                    % setting the output to true
                    eff_reset = true;
    
                    % Draw a new effort value
                    self.r_time = self.draw_rt(sim_id, mem_arr);
    
                end
            end

            %% Check the stochastic reset

            if strcmp(sim_id, 'sr')
                % If running stochastic resetting, then we also update our
                % stochjastic resetting time

                % if the agent is not currently returning home
                if ~(return_home)

                    self.s_time = self.s_time - params.dt;

                end
                
    
                if self.s_time <= 0
    
                    % If the stochastic reset value drops down to or below 0
                    % then we reset the agents position to 0
                    
                    % return true
                    stoch_reset = true;

                    % reset our stochastic reset timer
                    self.s_time = self.draw_srt(sim_id);
                    
    
                end

            end

            % Check goal found timer
            if ((params.goal) && (self.b_goal ~= true))

                self.t_goal = self.t_goal + params.dt;

            % End if
            end
            
        % End function
        end

        % Reset counters for new generation
        function self = reset(self, mem_arr)

            % Draw new effort value
            self.eff_val = self.draw_eff(mem_arr);

        % End function
        end

        function y = draw_srt(self, sim_id)
            % Draw stochastic resetting time value

            if strcmp(sim_id, 'sr')
                % Only if we are simulating stochastic resetting should we
                % draw a stochastic resetting time

                y = abs(random(self.srt_generator));

            else

                y = 0;

            % End if
            end

        % End function
        end

        function self = g_found(self)
            % If the goal is found, we set our boolean to true => we stop
            % counting on that timer

            self.b_goal = true;

        % End function
        end

    % End methods
    end

% End class
end