%% Population Class Definition
% This class is used to orchastrate the whole population, making sure that
% all the individual agents move as they should, initiate as they should
% and so on. This class will also contain the information of each agent
% that is necessary for the results later.


classdef Population

    properties

        % Population
        agents;

        % Saved variables
        savevar;

    % End properties
    end

    methods

        function self = init(self, params)
            
            % In this function we initiate the population of agents and the
            % variables save functionality
           

            % For stochastic resetting, we want to create 3 different kinds
            % of agents. We have 1 that is not resetting, 1 that is
            % resetting according to the exponential distribution, and 1
            % that is 'intelligent'.
            nr_diff = 1;

            % The size of the population will depend on two variables
            % agent(i,j), where i=0,...,N, where N = the number of
            % heterogenous agents we will compare (different resetting 
            % strategies), and j=0,...,M, where M is the number of agents 
            % we want to average over to get a more correct output.


            % for goes to N = nr_diff, i.e. number of different
            % distributions or neural networks to run simulatenously.
            for i=1:nr_diff

                % how many averaging agents do we have?
                for j=1:params.ave_agent

                    % Create agent
                    self.agents{i, j} = Agent();
    
                    % Initiate each agent according to the resetting policy
                    switch i
                        case 1
                            % No resetting
                            self.agents{i, j} = ...
                                self.agents{i, j}.init('no', params);

                        case 2
                            % With resetting exponential distribution
                            self.agents{i, j} = ...
                                self.agents{i, j}.init('exp', params);

                        case 3
                            % With 'intelligent' resetting
                            self.agents{i, j} = ...
                                self.agents{i, j}.init('int', params);
                    end

                end

            end

            % Create and initialize the save variable class for the
            % population
            self.savevar = SaveVar();
            self.savevar = self.savevar.init(self.agents);
             
        % End init function
        end

        function self = move(self, world, params)

            % Loop through all the agents in population
            for i=1:size(self.agents, 1)
                for j=1:size(self.agents, 2)

                    % Get current resistance of the world
                    curr_res = world.get_res(self.agents{i, j}, params);
    
                    % Move agent
                    self.agents{i, j} = self.agents{i, j}.move( ...
                        curr_res, world, params);


                    % Check if the agent is at the goal
                    % Calculate the distance to goal from current position
                    tmp_dist = sqrt( ...
                        (self.agents{i, j}.x - world.goal_center(1))^2 + ... 
                        (self.agents{i, j}.y - world.goal_center(2))^2);

                    % Check if distance is smaller than the radius of goal,
                    % and we havnt found the goal yet
                    if ((tmp_dist < world.goal_rad) && ...
                            (self.agents{i, j}.g_found ~= true))

                        % If the agents is inside the radius of the
                        % goal, then we have found the goal => the
                        % agent has finished
                        self.agents{i, j}.g_found = true;

                        % Display that we have found the goal
                        disp('Found goal!')

                        % Stop the timer!
                        self.agents{i, j} = self.agents{i, j}.found_goal;

                    % End if
                    end

                end  
            end
 
            % Save variables
            self.savevar = self.savevar.store_pose(self.agents, params);

        % End function
        end

    % End methods
    end

% End classdef
end