%% Comparison Main Class Definition
% This class is used to simulate the difference between different
% strategies, or over multiple iterations with the same strategy.

classdef CompMain

    properties

        % World variables
        world;

        % Population
        pop;

        % Plotting variable
        plotting;

    end

    methods

        % Running the class's main functionality
        function self = run(self, params)

            % Create world and initialize
            self.world = World();
            self.world = self.world.init_world(params);

            % Create the population of individuals (agents)
            self.pop = self.create_pop(params);

            % Create plotting and initialize
            self.plotting = Plotting();
            self.plotting = self.plotting.init( ...
                self.pop, self.world, params);

            % Run simulation main function (separate file)
            % Simulate population
            if (params.sup_plot) % If we suppress plotting during simulation

                [self.pop, self.world, ~] = SimMain( ...
                    self.pop, self.world, params);

            else % If we plot during simulation

                [self.pop, self.world, self.plotting] = SimMain( ...
                    self.pop, self.world, params, self.plotting);

            end

        end

        % Function for creating the population of agents for the simulation
        function pop = create_pop(self, params)


            % Create agent and initialize
            for i=1:(params.nr_pop)
                pop.agents(i) = Agent();
                pop.agents(i) = pop.agents(i).init(params);
            end

            % Create counter and initialize
            pop.counter = Counter();
            pop.counter = pop.counter.init(pop.agents, params);

            % Create save variable class and initialize
            pop.savevar = SaveVar();
            pop.savevar = pop.savevar.init(pop.agents, self.world, params);



        end

    end
    

end