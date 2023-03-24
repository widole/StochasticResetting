%% Class definition of stochastic resetting simulation

classdef StochasticResettingSimulation

    properties
        
        % Class filled with the population
        pop;

        % Class for the world in which the population interacts
        world;

        % Class for plotting the continuous motion
        plotting;

    % End properties
    end

    methods
        % Methods contains all the class defined functions

        function self = init(self, params)

            % Create the world
            self.world = World();
            % and initialize
            self.world = self.world.init(params);

            % Initiate population
            self.pop = Population();
            self.pop = self.pop.init(params);

        % End init
        end

        function [self, plotting, trackingObjects] = run(self, trackingObjects, plotting, params)

            % Function for running the simulation of agents in the world.
            % This will run throught all the simulation steps.

            % Clear last generation
            plotting = plotting.clear_plot(self.pop.agents, params);

            % Loop through all simulation steps
            for i=1:params.N
            
                % Update all agents positions
                self.pop = self.pop.move(self.world, params);
            
                % Plotting
                plotting = plotting.plot_motion(i, self.pop.agents(:,1), params);

                % Get frame from plotting
                trackingObjects = trackingObjects.getFrame( ...
                    plotting.fig_cont_motion(1));

                % Detect objects
                trackingObjects = trackingObjects.objDetect();
            
            end
        end

        function [self, av_g_time] = results(self, plotting, params)
            
            % Average time til goal for each kind of agent
            for i=1:size(self.pop.agents, 1)
                
                tmp_goal_time = 0;

                for j=1:size(self.pop.agents, 2)

                    tmp_goal_time = tmp_goal_time + ...
                        self.pop.agents{i, j}.counter.t_goal;

                end

                % Save time and average
                av_g_time(i) = tmp_goal_time / j;

            end

            % Example trajectory
            plotting.example_traj(self.pop, self.world, params);

            % Intelligent agent resetting distribution

        % End function
        end
    
        
    % End methods
    end


% End class
end