%% Function for simulating agents in world
% This function is used to run 1 simulation iteration. I.e. for m agents,
% we run our N time step simulation.

% The input to this function should be
% A population: consists of agents, counters and savevars in a structure
% A world: assuming all agents should be simulated in the same world
% environment (if not, then idk?)
% A plotting handle: this should only be passed in if the plotting should
% be done during simulation, if the argument is missing, then it will
% simply not plot anything.


function [world, plotting] = SimMain(sim_id, world, params, plotting)


    % Clear last generation
    plotting = plotting.clear_plot(world.pop.agents, params);


    %% Loop through all simulation steps
    for i=1:params.N

        % Update world
        world = world.move(sim_id, params);

        % Plotting
        plotting = plotting.plot_motion(i, world.pop.agents(:,1), params);


%         % Check if goal is found during last motion 
%         if params.goal
%             if any(world.found == 1)
% 
%                 % Goal has been found
%                 disp('Goal found, breaking loop')
% 
%             end
% 
%         % End if
%         end

        

    % End for-loop
    end

    

   
end