%% This is class is used to simulate levy flights

classdef LevFli

    properties

        world;

        plotting;

        sim_id = 'lf';

    % End properties
    end

    methods

        function self = init_lf(self, params)

            % Create world instance
            self.world = World();
            self.world = self.world.init_world(params);

            % Initiate inhabitants
            self.world = self.world.init_population('lf', params);

            % Create plotting instance
            self.plotting = Plotting();
            self.plotting = self.plotting.init_PLOT(self.world, params);

        % End init function
        end

        function self = run(self, params)

            % Call simulation function, this runs through all the steps N
            % defined in params
            [self.world, self.plotting] = SimMain(self.sim_id, self.world, params, self.plotting);


            % Plot results
            self.plotting = self.plotting.plotLFresults(self.world, self.world.pop.savevar, params);

        % End run function
        end

    % End methods
    end

% End class
end