%% Normal Simulation Main File
% Main simulation function file, by using this class, we can run all the
% different simulations needed

classdef SimMain

    properties

        %% Classes
        % World class
        world;

        % Agent class
        agents;

        % Counter class
        counters;

        % SaveVar class
        savevar;

        % Plotting class
        plotting;

        %% Variables
        % Current resistance
        curr_res;

        % Current area
        curr_area;

        % Found area
        found_area;


    end

    methods

        % Initiate simulation
        function self = init(self, params)

            % Create and initiate all classes needed for simulation (based
            % on Params

            % Initiate world
            self.world = World();
            self.world = self.world.init(params);

             % Initiate agents
            self.agents = Agent();
            self.agents = self.agents.init(params);

            % Initiate counter
            self.counters = Counter();
            self.counters = self.counters.init(params);

            % Initiate saving variables
            self.savevar = SaveVar();
            self.savevar = self.savevar.init(self.agents, self.world, params);

            % Initiate plotting
            self.plotting = Plotting();
            self.plotting = self.plotting.init(self.agents, self.world, params);

        end

        % Run simulation
        function self = run(self, params)

            %% Start simulation
            % Check initial resistance value
            self.curr_res = self.world.set_res(self.agents, params);

            %% Simulation Loop

            % Start loop
            for i=2:params.N
%             while true
            
                % Move agents
                self.agents = self.agents.move(self.world, params);
            
                % Update agent motion in plot
                self.plotting = self.plotting.plot_motion(self.agents, self.world);
            
                % Check which area agent is in
                self.curr_area = self.world.cmp_pose_area(self.agents);
            
                % Check resistance of agents position
                self.curr_res = self.world.set_res(self.agents, params);
                
                % Save variables to arrays
                [self.savevar, self.found_area] = self.savevar.save_area(self.curr_area);
                self.savevar = self.savevar.save_pose(self.agents, self.found_area, params);

                % Update agent memories
                self.agents = self.agents.upd_mem(self.found_area);
                    
                % Check counters
                [self.counters, self.agents] = self.counters.upd_counters(self.agents, self.curr_res, params);
            
                % Check if goal has been reached
                found = self.world.cmp_pose_goal(self.agents);
            
                if (found)
            
                    disp(sprintf('Time to find goal: %f'), self.counters.goal_t)
                    break;
            
                end
            
            end
            
            
            %% Plotting
            
            self.plotting = self.plotting.plot_result(self.savevar, params);
            
            %% Finish Simulation
            
            % Save variables to files
            
            self.savevar.save_2_file(params);




        end

    end

end