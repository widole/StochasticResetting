%% Saving simulation variables
% This class is used to save the position, reset values and explored areas
% for each simulation run for all the active agents.


classdef SaveVar

    properties

        %% Arrays for saved variables

        % Position array
        pose_arr = {};

        % Resetting array
        reset_arr = {};

        % Explored areas
        expl_area = {};    
        

    end

    methods

        % Initialize arrays
        function self = init_savevar(self, sim_id, world_params, agents, params)

            % Go through each agent
            for i=1:size(agents, 1)
                for j=1:size(agents, 2)

                    % Init pose_arr array
                    if strcmp(sim_id, 'sr')
                        self.pose_arr(i,j) = {[agents(i,j).x; agents(i,j).y]};
                    else
                        self.pose_arr(i, j) = {[agents(i, j).x; agents(i, j).y; 1]};
                    end
        
                    % Init expl_area array
                    if strcmp(sim_id, 'lf') || strcmp(sim_id, 'ga') 
                        curr_area = self.cmp_pose_area(world_params, agents(i, j));
                        self.expl_area(i, j) = {curr_area};
                    end
        
                    % If stochastic resetting then add values to the reset_arr
                    if params.stoch_res
        
                        self.reset_arr(i, j) = {0};
        
                    end
                end
            % End for-loop
            end

        % End function
        end

        % Save agent variables
        function [self, agents] = store_vars(self, sim_id, world_params, agents, params)

            % Loop through all the agents
            for i=1:size(agents, 1)
                for j=1:size(agents, 2)

                    % Find current area in world
                    curr_area = self.cmp_pose_area(world_params, agents(i, j));
    
                    if strcmp(sim_id, 'lf') || strcmp(sim_id, 'ga')
                        % Add current area to explored area list
                        [self, found_area] = self.save_area(i, j, curr_area);

                        % Save position to variable
                        self = self.save_pose(i, j, agents(i, j), params, found_area);

                        % Update agents memory
                        agents(i, j) = agents(i, j).upd_mem(found_area);

                    else
                        
                        % Save position to variable
                        self = self.save_pose(i, j, agents(i, j), params);

                    end
    
                    
    
                    

                end
            end

        % End function
        end
        
        % Check agents position within world to check what area is explored
        function curr_area = cmp_pose_area(self, world_params, agent)
            
            % Find integer n for x position area unit
            n_x = floor(agent.x / world_params.area_unit);

            % Find integer n for y position area unit
            n_y = floor(agent.y / world_params.area_unit);

            % Explored area is
            curr_area = [n_x, n_y] * world_params.area_unit;

        % End function
        end

        % Add current position to pose_arr
        function self = save_pose(self, i, j, agent, params, found_area)

            % Add position to list
            if nargin < 6
                self.pose_arr{i, j}(:, end+1) = [agent.x; agent.y];
            else
                self.pose_arr{i, j}(:, end+1) = [agent.x; agent.y; found_area]; %[self.pose_arr, [agent.x; agent.y; found_area]];
            end

            % If stochastic resetting then add values to the reset_arr
            if params.stoch_res
                if agent.stoch_res_curr
                    self.reset_arr{i, j}(end+1) = 1;
                else
                    self.reset_arr{i, j}(end+1) = 0;
                end
            end


        end

        % Add current area unit to expl_area
        function [self, found_area] = save_area(self, i, j, curr_area)

            % Set found_area to 0
            found_area = 0;

            % Compare to list
            is_present = any(ismember(self.expl_area{i, j}, curr_area, 'rows'));

            % Add if not already visited
            if ~is_present

                % Add to expl_are array
                self.expl_area{i, j} = [self.expl_area{i, j}; curr_area];

                % Set found_area to 1
                found_area = 1;

            end

        end

        % Save all variables to file end of simulation
        function save_2_file(self, params)

            prompt = "Input file name for simulation results: ";

            file_name = input(prompt, 's');

            save(sprintf('SavedResults/%s', file_name), "self", "params");

        end
        
    % End methods
    end

% End class
end