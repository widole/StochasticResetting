%% Class definition of stochastic resetting simulation

classdef StochasticReset

    properties
        % Here we gather all the necessary variables for the class

        world;

        plotting;

        sim_id = 'sr';

    % End properties
    end

    methods
        % Methods contains all the class defined functions

        function self = init_SR(self, params)

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

            % Call simulation function, this runs through all the steps N
            % defined in params
            [self.world, self.plotting] = SimMain(self.sim_id, self.world, params, self.plotting);


            % Plot results
            self.plotting = self.plotting.plotSRresults(self.world, self.world.pop.savevar, params);

        % End run
        end

    % End methods
    end


% End class
end