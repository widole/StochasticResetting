%% Main Script for Genetic Algorithm
% To run the genetic algorithm to get a "optimized" shallow neural network
% for generating effort values that should maximize the found amount of
% cells.


classdef GAMain

    properties

        %% Genetic Algorithm sub-classes needed
        % Evaluation class
        Evaluation;

        % Selection class
        Selection;

        % Crossbreed class
        Crossbreed;

        % Mutate class
        Mutate;

        %% Variables for generational comparison

        % Explored areas for all agents during all generations
        gen_expl_areas;

        % Alpha values for all agent over all generations
        gen_alpha;


        %% Variables needed

        % World
        world;

        % Plot
        plotting;

        % Result
        results;

    end

    methods

        % Initialize the genetic algorithm class
        function self = init_GA(self, params)

            % Create the necessary classes
            self.world = World();
            
            % Initiate world
            self.world = self.world.init_world(params);

            % Initiate inhabitants
            self.world = self.world.init_population('ga', params);

            % Create plotting class and initialize plotting
            self.plotting = Plotting();
            self.plotting = self.plotting.init_PLOT(self.world, params);

        end

        % Main Genetic Algorithm function
        function [self, fittest_ind] = run_GA(self, params)

                
            % Loop over all the generations
            for i=1:params.nr_gen

                fprintf('Simulating generation nr: %d \n', i)

                % Simulate population for one generation
                [self.world, ~] = SimMain(self.world, params, self.plotting);

                % Save the result from simulation into structure
                self.results{i} = self.world.pop.savevar;

                % Create new population
                self = self.new_gen(params);

            % End for-loop
            end

            % Clear last generation
            self.plotting = self.plotting.clear_plot(self.world.pop.agents);

            % Plot results
            self.plotting.plot_GAresults(self.results, params);

            % Return the best individual
            [fittest_ind, ~] = self.find_fittest();

        % End function
        end


        % Find fittest individual from population
        function [best_agent, nr_area] = find_fittest(self)

            % Find the length of the explored areas array for each agent in
            % population
            nr_expl_areas = cellfun(@length, self.world.pop.savevar.expl_area);

            % Find the index of max explored areas
            [nr_area, I] = max(nr_expl_areas);

            % Return the agent and the amount of explored areas
            best_agent = self.world.pop.agents(I);

        % End function
        end

        % Create new generation of agents
        function self = new_gen(self, params)

            % Select individuals
            selected_individuals = self.select();

            % Loop through the selected individuals
            for i=1:2:length(selected_individuals)

                % Breed children
                tmp_children = self.breed(selected_individuals(i:i+1));

                children{i} = tmp_children{1};
                children{i+1} = tmp_children{2};
                
    
                % Mutate children
                tmp_mutated_children = self.mutate(children);

                mutated_children{i} = tmp_mutated_children{1};
                mutated_children{i+1} = tmp_mutated_children{2};

            end

            % Call world function reset generations
            self.world = self.world.reset_gen_GA(mutated_children, params);

        % End function
        end

        % Function for selecting N individuals
        function selected_individuals = select(self)

            % Loop N time
            for i=1:length(self.world.pop.agents)

                % Get two individuals
                [tmp_vals, idx] = datasample(self.world.pop.savevar.expl_area, 2);

                % Find the best one
                [max_val, max_idx] = max([length(tmp_vals{1}), length(tmp_vals{2})]);


                % Save best individuals weights and biases
                hweights = self.world.pop.agents(idx(max_idx)).counter.eff_gen.hidden_weights;
                hweights = reshape(hweights, size(hweights,1)*size(hweights,2), 1);
                oweights = self.world.pop.agents(idx(max_idx)).counter.eff_gen.output_weights;
                oweights = reshape(oweights, size(oweights,1)*size(oweights,2), 1);
                
                selected_individuals{i} = [hweights; oweights];


            end

        % End function
        end

        % Function for creating new individuals
        function children = breed(self, parents)

            % Get first parts
            children{1} = parents{1}(1:4);
            children{2} = parents{2}(1:4);

            % mix first cross-over with 90 procent probability
            if rand <= 0.9

                % First child
                children{1} = [children{1}; parents{2}(5:9)];

                % Second child
                children{2} = [children{2}; parents{1}(5:9)];

            else

                % First child
                children{1} = [children{1}; parents{1}(5:9)];

                % Second child
                children{2} = [children{2}; parents{2}(5:9)];

            % End if
            end

            % mix second cross-over with 90 procent probability
            if rand <= 0.9

                % First child
                children{1} = [children{1}; parents{1}(10:13)];

                % Second child
                children{2} = [children{2}; parents{2}(10:13)];

            else

                % First child
                children{1} = [children{1}; parents{2}(10:13)];

                % Second child
                children{2} = [children{2}; parents{1}(10:13)];

            % End if
            end

        % End function
        end

        % Functions for mutations
        function mutated_chromosome = mutate(self, chromosomes)
            % This function takes the whole chromosome of an individual as
            % input, with a probability of p, this chromosome will mutate
            % where one gene will be altered with a value from a normal
            % distribution with mean 0 and std.dev 0.1

            % Loop through input
            for i=1:length(chromosomes)
                % Return chromosome
                mutated_chromosome{i} = chromosomes{i};

                for j=1:length(mutated_chromosome{i})
    
                    % Probability
                    if rand <= (1/length(mutated_chromosome{i})) % 0.01 % p
    
                        % Mutation value
                        r = normrnd(0, 0.1);
    
%                         % Obtain random chromosome
%                         [y, idx] = datasample(mutated_chromosome{i}, 1);
    
                        % Mutate and return
                        mutated_chromosome{i}(j) = mutated_chromosome{i}(j) + r;
    
                    % End if
                    end

                % End for
                end


            % End for-loop
            end
                
        % end function
        end

    % End methods
    end

% End class definition
end




