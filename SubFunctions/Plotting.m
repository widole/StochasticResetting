%% Class definition for plotting results of simulation
% Used for plotting the results

classdef Plotting

    properties
        
        % Figure for continuously plotting motion of agent in area
        fig_cont_motion;

        % Save axis
        ax = {};

        g_ax;
        g_x;
        g_y;

        % Holder for title continuous motion
        t_cont;

    end

    methods


        function self = init(self, pop, world, params)

            % Initiate continuous plotting figure
            self.fig_cont_motion = figure('name', 'Continuous Motion Plot'); % , 'WindowState','maximized');
            self.t_cont = get(gca,'Title');
            set(self.t_cont,'String',strcat('Motion at t = ', num2str(0), '%.1f'));

            if world.bound_cond ~= 0
                axis([-world.world_size, world.world_size, ...
                    -world.world_size, world.world_size]);
            end
            hold on;


            th = 0:pi/50:2*pi;
            self.g_x = world.goal_rad * cos(th) + world.goal_center(1);
            self.g_y = world.goal_rad * sin(th) + world.goal_center(2);
            self.g_ax = plot(self.g_x, self.g_y, 'color', 'red');


            for i=1:length(pop.agents)
                % Save initial position of agent
                self.ax{i} = plot(pop.agents{i}.x, pop.agents{i}.y, ...
                    'o', 'color', 'blue', 'linewidth', 1.5, 'markersize', 5);
            end

        end

        function self = plot_motion(self, tstep, agents, params)

            % Chose the right figure
            figure(self.fig_cont_motion)
            set(self.t_cont,'String',strcat('Motion at t = ', num2str(tstep * params.dt, '%.1f')));

            for i=1:length(agents)
                % Delete axis
                delete(self.ax{i})
    
                % Replot axis
                if (agents{i}.return_home)
                    self.ax{i} = plot(agents{i}.x, agents{i}.y, 'o', 'color', 'red', 'linewidth', 1.5, 'markersize', 5);
                else
                    self.ax{i} = plot(agents{i}.x, agents{i}.y, 'o', 'color', 'blue', 'linewidth', 1.5, 'markersize', 5);
                end

            % End for-loop
            end

        % End function
        end

        function self = clear_plot(self, agents, params)

            % Chose the right figure
            figure(self.fig_cont_motion)
            % clear figure
            cla

            % Plot the goal again
            self.g_ax = plot(self.g_x, self.g_y, 'color', 'red');


        % End function
        end

        function self = example_traj(self, pop, world, params)

            figure('name', 'Example Trajectories')

            % First plot the goal
            plot(self.g_x, self.g_y, 'color', 'red');
            hold on; grid on


            for i=1:size(pop.agents, 1)

                % Get random averaging agent
                j = randsample(1:size(pop.agents,2), 1);

                plot(pop.savevar.pose{i, j}(1, :), pop.savevar.pose{i, j}(2, :))

            end

            xlabel('Position')
            ylabel('Position')
            title('Example Trajectories of Agents')
            legend({'No Reset', 'Exponential Reset', 'Intelligent Reset'})

        end
        
        
        
        function self = plot_result(self, world, savevar, params)

            %% Set-up
            % Todays date
            date = datetime('now','TimeZone','local','Format','yy-MM-dd-HH-mm');
            
            %% Plot the 2D motion
            % If number of agents < 4 we create a gif and a plot of the
            % complete motion
            if (length(savevar) < 4)

                % File name
                name = sprintf("Trajectories_%s", date);

                % Create figure
                trajfig = figure('name', '2D motion');
                hold on; grid on

                % Settings
                set(0,'DefaultTextFontName','Times');
                set(0,'DefaultAxesFontName','Times');
                set(0,'DefaultAxesFontSize',12);
                set(0,'DefaultTextFontSize',12);
                set(0,'DefaultLineLineWidth',1);
                set(0,'DefaultFigurePaperType','a4letter');

                % First set plot axes according to the world size
                if world.world_params.bnd_cond ~= 0
                    axis([-world.world_params.wrld_sz, world.world_params.wrld_sz, ...
                        -world.world_params.wrld_sz, world.world_params.wrld_sz]);
                end

                % Plot where the goal is, if there is a goal
                if params.goal
                    th = 0:pi/50:2*pi;
                    xunit = params.goal_rad * cos(th) + world.goal.center(1);
                    yunit = params.goal_rad * sin(th) + world.goal.center(2);
                    plot(xunit, yunit, 'color', 'red');
                end

                % Plot motion for each agent
                for i=1:length(savevar.pose_arr)
                    % Get color for each trajectory
                    switch i
                        case 1
                            trajcolor = 'blue';
                        case 2
                            trajcolor = 'red';
                        case 3
                            trajcolor = 'green';
                    end

                    % Plot the trajectories
                    plot(savevar.pose_arr{i}(1,:), savevar.pose_arr{i}(2,:), 'color', trajcolor, 'linewidth', 1.5)
                end

                % Save figure
                saveas(trajfig, sprintf("SavedResults/MotionTrajectories/%s", name), 'epsc')

            end

            %% Create trajectory gif

            % File name
            name = sprintf("MotionGif_%s", date);

            % Create figure
            figure('name', '2D motion')
            hold on; grid on

            % Settings
            set(0,'DefaultTextFontName','Times');
            set(0,'DefaultAxesFontName','Times');
            set(0,'DefaultAxesFontSize',12);
            set(0,'DefaultTextFontSize',12);
            set(0,'DefaultLineLineWidth',1);
            set(0,'DefaultFigurePaperType','a4letter');

            % First set plot axes according to the world size
            if world.bnd_cond ~= 0
                axis([-world.wrld_sz, world.wrld_sz, ...
                    -world.wrld_sz, world.wrld_sz]);
            end

            % Plot where the goal is, if there is a goal
            if params.goal
                th = 0:pi/50:2*pi;
                xunit = world.goal.rad * cos(th) + world.goal.center(1);
                yunit = world.goal.rad * sin(th) + world.goal.center(2);
                plot(xunit, yunit, 'color', 'red');
            end


            % Loop through all positions
            for i=1:length(savevar.pose_arr{1})

                % Loop through all the agents
                for j=1:length(savevar.pose_arr)

                    % Plot the trajectory point
                    p(j) = plot(savevar.pose_arr{j}(1,i), savevar.pose_arr{j}(2,i), ...
                        'o', 'color', 'blue', 'linewidth', 1.5);

                end

                % Export to gif
                exportgraphics(gca, ...
                    sprintf("SavedResults/MotionGifs/%s.gif", name), "Append", true)

                % Clear axis
                delete(p);

            end


            %% Plot the number of explored areas for each agent

            % File name
            name = sprintf("ExploredAreas_%s", date);

            % Create figure
            explafig = figure('name', '2D motion');
            hold on; grid on

            % Settings
            set(0,'DefaultTextFontName','Times');
            set(0,'DefaultAxesFontName','Times');
            set(0,'DefaultAxesFontSize',12);
            set(0,'DefaultTextFontSize',12);
            set(0,'DefaultLineLineWidth',1);
            set(0,'DefaultFigurePaperType','a4letter');

            % Loop through all the agents
            for i=1:length(savevar.pose_arr)

                % Get amount of explored areas for agent
                tmp_expl_area = length(savevar.expl_area{i});

                % Plot the trajectory point
                p(j) = bar(i, tmp_expl_area, 'color', 'blue');

            end

            % Save figure
            saveas(explafig, sprintf("SavedResults/ExploredAreas/%s", name), 'epsc')







%             % Plot motion of x and y separately with color matching
%             % stochastic resetting
%             if params.stoch_res
%                 for i=2:length(savevar.pose_arr)
%                     
%                     if savevar.reset_arr(i)
%                         subplot(2,1,1)
%                         plot([i-1, i], [savevar.pose_arr(1, i-1), savevar.pose_arr(1,i)], 'linewidth', 1.5, 'color', 'red')
%                         subplot(2,1,2)
%                         plot([i-1, i], [savevar.pose_arr(2, i-1), savevar.pose_arr(2,i)], 'linewidth', 1.5, 'color', 'red')
%                     else
%                         subplot(2,1,1)
%                         plot([i-1, i], [savevar.pose_arr(1, i-1), savevar.pose_arr(1,i)], 'linewidth', 1.5, 'color', 'blue')
%                         subplot(2,1,2)
%                         plot([i-1, i], [savevar.pose_arr(2, i-1), savevar.pose_arr(2,i)], 'linewidth', 1.5, 'color', 'blue')
%                     end
%     
%                 end
%             else
%                 subplot(2,1,1)
%                 plot(savevar.pose_arr(1,:), 'linewidth', 1.5, 'color', 'blue')
%                 subplot(2,1,2)
%                 plot(savevar.pose_arr(2,:), 'linewidth', 1.5, 'color', 'blue')
%             end

        end
 

        function self = plotSRresults(self, world, savevar, params)
            % Plotting the results from the stochastic resetting


            % Take the overall motion done
            %% Plot MSD

            MSD = zeros(size(savevar.pose_arr, 1), params.N);

            
            % Calculate the MSD for the trajectories
            for i=1:params.N
                % Go through all the simulation steps

                % Go through each heterogenity agent
                for j=1:size(savevar.pose_arr, 1)

                    % run through all the averaging agents
                    for k=1:size(savevar.pose_arr, 2)
    
                        MSD(j, i) = MSD(j, i) + ( ...
                            (savevar.pose_arr{j, k}(1, i) - savevar.pose_arr{j, k}(1, 1))^2 +  ...
                            (savevar.pose_arr{j, k}(2, i) - savevar.pose_arr{j, k}(2, 1))^2);  % y
           
                    end

                    MSD(j, i) = MSD(j, i) / params.N;

                end
            end

            % Plot MSD
            figure('name', 'MSD')
            

            for i=1:size(MSD, 1)

                loglog(1:params.N, MSD(i, :), 'o-')
                hold on; grid on

            end


            %% ---------- PLOT TIME TIL GOAL ---------- %%

            % Initialize time
            t2goal = zeros(size(world.pop.agents, 1), 1);

            % Find the min value of FTP
            tmin = params.N * params.dt * ones(size(world.pop.agents, 1), 1);

            for i=1:size(world.pop.agents, 1)
                % For each heterogeneous agent

                for j=1:size(world.pop.agents, 2)
                    % For each averaging

                    %  Calculate the total time for all agents
                    t2goal(i) = t2goal(i) + world.pop.agents(i,j).counter.t_goal;

                    % Check if the t_goal is less than the current min
                    if (world.pop.agents(i,j).counter.t_goal < tmin(i))
                        % Save the current as new min
                        tmin(i) = world.pop.agents(i,j).counter.t_goal;

                    % End if
                    end

                % End for
                end

                % Average the t2goal
                t2goal(i) = t2goal(i) / j;

            % End for
            end

            figure('name', 'FTP goal times')
            subplot(2,1,1)
            stem(1:size(world.pop.agents, 1), t2goal)
            hold on; grid on
            yline(params.N*params.dt)
            title('Average FTP')

            subplot(2,1,2)
            stem(1:size(world.pop.agents, 1), tmin)
            hold on; grid on
            yline(params.N*params.dt)
            title('Min FTP')


            %% ---------- PLOT MOTIONS ---------- %%

            figure('name', 'Trajectories')
            hold on; grid on
            
            for i=1:size(world.pop.agents, 1)
                % Go through each heterogeneous agent

                % Get random agent
                indx_agent = randsample(1:size(world.pop.agents, 2), 1);

                % Plot that agents trajectory
                plot(world.pop.savevar.pose_arr{i, indx_agent}(1, :), world.pop.savevar.pose_arr{i, indx_agent}(2, :))

            % End for
            end

            legend({'Agent No Reset', 'Agent Fixed Reset', 'Agent Exp Reset 1', 'Agent Exp Reset 2'})

            plot(self.g_x, self.g_y, 'color', 'red');





        % End function
        end

    % End method
    end

% End class
end












