%% Create the world class
% This is the main class called by the simulation classes (either compare
% different strategies, simulate certain strategies or the genetic
% algorithm training) The world contains both the environment as well as
% the population of agents.

classdef World

    properties

        % Check if obstacles is in world
        world_type;

        % Boundary conditions
        bound_cond;

        % Size of cells
        cell_size;

        % Size of area units
        area_unit;

        % Size of world
        world_size;

        % Center of goal
        goal_center;

        % Radius of goal
        goal_rad;


    end

    methods

        function self = init(self, params)
            % Initialize the world

            % Should the world contain obstacles, 1 for yes, 0 for no
            self.world_type = params.obstacles;

            % Set the boundary conditions
            % This can 0 for unbounded environment, 1 for periodic
            % boundaries, 2 for fixed boundaries or 3 for bouncy boundaries
            self.bound_cond = params.bnd_cond;

            % Set cell_size
            % The cell size defines how close together and large the
            % obstacles in the environment are
            self.cell_size = params.cell_size;

            % Set area_unit
            % Areas units are the smallest area in the environment, this is
            % what is used to determine if an agents has discovered a part
            % of the environment or not
            self.area_unit = params.area_unit;

            % Set world size
            % If the world is bounded, then we set the world size as a
            % certain determined amount of cells
            if (params.bnd_cond ~= 0)
                self.world_size = ...
                    params.world_size * self.cell_size;
            else
                self.world_size = 0;
            end

            % Create goal and save coordinate
            % Find center
            r_tmp = (.2 + (1 - .2) * rand);
            theta_tmp = 2 * pi * rand;
            self.goal_center = ...
                r_tmp * [cos(theta_tmp); sin(theta_tmp)];

            % Save goal radius
            self.goal_rad = params.goal_rad;


            %% Create obstacles (Not implemented yet)
 

        % End of init function
        end

        function res = get_res(self, agent, params)

            % Function for getting the current resistance in the
            % environment that the agent interacts with

            % Currently there is only a constant resistance
            res = params.res;

            % Check which resistance area the agent is inside
%             x_cell = double(idivide(self.pop.agents(i, j).x, int8(self.world_params.cell_size), 'floor'));

            % Calculate the remainder of xCell / 2, should give us either a 0,
            % if xCell is even and 1 if xCell is odd
%             remi_cell = rem(x_cell, 2);

            % Calculate the resistance
%             if remi_cell == 0 
    
%                 res = params.env_r(1);
    
%             else
    
%                 res = params.env_r(2);
    
%             end

        end

        function [x, y] = corr_pose(self, x, y, dx, dy)

            % Check agent updated position according to world, if it
            % collides, move outside of boundaries, etc.

            % Depending on the boundary conditions, the agent should
            % collide, move or bounce back, when interacting with the
            % boundaries
            switch self.bound_cond

                %(0 = unbounded, 1 = periodic, 2 = fixed, 3 = bounce)
                
                case 0
                    % Unbounded, nothing happens
                    x = x + dx;
                    y = y + dy;

                case 1
                    % Periodic boundary conditions, returns to otherside
                    % when outside
                    if ((x + dx) > self.world_size) || ...
                            ((x + dx) < -self.world_size)
                        x = -x + dx;
                    else
                        x = x + dx;
                    end
                    if ((y + dy) > self.world_size) || ...
                            ((y + dy) < -self.world_size)
                        y = -y + dy;
                    else
                        y = y + dy;
                    end

                case 2
                    % Fixed boundaries, meaning that the agent can not move
                    % outside the boundaries
                    % Check for x
                    if (abs(x + dx) > self.world_size)
                        x = sign(x + dx) * self.world_size;
                    else
                        x = x + dx;
                    end
                    if (abs(y + dy) > self.world_size)
                        y = sign(y + dy) * self.world_size;
                    else
                        y = y + dy;
                    end
                % Check for bounce boundaries
%                 case 3
%                     % Check for x
%                     if (abs(agent.x + dx) > self.wlrd_sz)
%                         x = sign(agent.x + dx) * self.wlrd_sz - ...
%                             sign(dx) * (agent.x + dx - sign(agent.x + dx) * self.wlrd_sz);
%                         % Rotation
%                         theta = agent.theta + sign(dy) * pi/2;
%                     else
%                         x = agent.x + dx;
%                         theta = agent.theta;
%                     end
%                     % Check for y
%                     if (abs(agent.y + dy) > self.wlrd_sz)
%                         y = sign(agent.y + dy) * self.wlrd_sz - ...
%                             sign(dy) * (agent.y + dy - sign(agent.y + dy) * self.wlrd_sz);
%                         % Rotation
%                         theta = agent.theta - sign(dx) * pi/2;
%                     else
%                         y = agent.y + dy;
%                         theta = agent.theta;
%                     end
                    
                    
            end

        % End corr_pose function
        end

    % End methods
    end


end