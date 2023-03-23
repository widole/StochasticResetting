%% Saving simulation variables
% This class is used to save the position, reset values and explored areas
% for each simulation run for all the active agents.


classdef SaveVar

    properties

        % Position array
        pose = {};

        % Resetting array
        reset = {};  
        
    end

    methods

        function self = init(self, agents)

            % Loop through all the agents to save their current positions
            for i=1:size(agents, 1)
                for j=1:size(agents, 2)

                    % Save positions to pose array
                    self.pose(i, j) = {[agents{i, j}.x; agents{i, j}.y]};

                    % Initiate the resetting array
                    self.reset(i, j) = {0};
        
                end
            end

        % End function
        end

        % Save agent variables
        function self = store(self, world, agents, params)

            % Save position to variable
            self = self.store_pose(agents, params);

        % End function
        end

         % Add current position to pose_arr
         function self = store_pose(self, agents, params)

             for i=1:size(agents, 1)
                 for j=1:size(agents,2)

                     % Add position to list
                     self.pose{i, j}(:, end+1) = ...
                         [agents{i, j}.x; agents{i, j}.y];

                     % Add reset value to list
                     if agents{i, j}.return_home
                         self.reset{i, j}(end+1) = 1;
                     else
                         self.reset{i, j}(end+1) = 0;
                     end
                 end
             end

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