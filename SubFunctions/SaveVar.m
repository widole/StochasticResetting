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

    % End methods
    end

% End class
end