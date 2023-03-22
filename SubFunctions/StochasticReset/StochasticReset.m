%% Class definition of stochastic resetting simulation

classdef StochasticReset

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
            self.world = self.world.init_world(params);

            % Initiate population
            self.world = self.world.init_population(self.sim_id, params);

            % Create plotting instance
            self.plotting = Plotting();
            self.plotting = self.plotting.init_PLOT(self.world, params);

        % End init
        end

        function self = run(self, params)

            %% Function for simulating agents in world
% This function is used to run 1 simulation iteration. I.e. for m agents,
% we run our N time step simulation.

% The input to this function should be
% A population: consists of agents, counters and savevars in a structure
% A world: assuming all agents should be simulated in the same world
% environment (if not, then idk?)
% A plotting handle: this should only be passed in if the plotting should
% be done during simulation, if the argument is missing, then it will
% simply not plot anything.


function [world, plotting] = SimMain(sim_id, world, params, plotting)


    % Clear last generation
    plotting = plotting.clear_plot(world.pop.agents, params);


    %% Loop through all simulation steps
    for i=1:params.N

        % Update world
        world = world.move(sim_id, params);

        % Plotting
        plotting = plotting.plot_motion(i, world.pop.agents(:,1), params);


%         % Check if goal is found during last motion 
%         if params.goal
%             if any(world.found == 1)
% 
%                 % Goal has been found
%                 disp('Goal found, breaking loop')
% 
%             end
% 
%         % End if
%         end

        

    % End for-loop
    end

    

   
end

            % Call simulation function, this runs through all the steps N
            % defined in params
            [self.world, self.plotting] = SimMain(self.sim_id, self.world, params, self.plotting);


            % Plot results
            self.plotting = self.plotting.plotSRresults(self.world, self.world.pop.savevar, params);

        % End run
        end

        function self = results(self, params)
            % Include results here

        % End function
        end
    % End methods
    end


% End class
end