%% Check boundary conditions
clear all; close all; clc

% What boundary condition to check
% 0 = unbounded
% 1 = periodic
% 2 = gliding
% 3 = reflective
wht_cond = 3;

%% Create box
% Boundary conditions
bnd_cond = 1;

% Boundary conditions box corners
bnd_cond_box.x = [-1, 1, 1, -1, -1];
bnd_cond_box.y = [-1, -1, 1, 1, -1];

%% Init start
% posi
x(1) = 0.75;
y(1) = 0;
theta(1) = (-1 + 2*rand) * pi/2;
% Speed
v = 0.3;
% Time
dt = 1;

%% Calculate next positions

% Plot
figure('name', 'motion')
hold on; grid on
axis([-2, 2, -2, 2])
% Plot box
plot(bnd_cond_box.x, bnd_cond_box.y, 'linewidth', 2, 'color', 'black')

for i=1:20

    % Set no collision
    col_det = false;

    % Change in position
    dx(i) = v * dt * cos(theta(i));
    dy(i) = v * dt * sin(theta(i));

    % Calculate collision point
    % Initiate with normal end point
    x_col(i) = x(i) + dx(i);
    y_col(i) = y(i) + dy(i);
    % Check for x, if x1 is outside of boundary
    if (abs(x(i) + dx(i)) > bnd_cond)
        % Set the x value to boundary value
        x_col(i) = sign(x(i) + dx(i)) * bnd_cond;
        % and set y according to the change in update length caused by
        % collision
        y_col(i) = (x_col(i) - x(i))*sin(theta(i))/cos(theta(i));   
        
        % Set if collision
        col_det = true;

    end
    
    % Check for y, if y1 is outside of boundary
    if (abs(y(i) + dy(i)) > bnd_cond)
        % Set the y value to boundary value
        y_col(i) = sign(y(i) + dy(i)) * bnd_cond;
        % and set x according to the change in update length caused by
        % collision1
        x_col(i) = (y_col(i) - y(i))*cos(theta(i))/sin(theta(i));

        % Set if collision
        col_det = true;

    end
    
    % Case for when we have unbounded
    switch wht_cond
        case 0
            % Nothing happens
            x(i+1) = x(i) + dx(i);
            y(i+1) = y(i) + dy(i);
            theta(i+1) = theta(i);
        case 1
            % Case when we have periodic boundary
            % check for x
            if (abs(x(i) + dx(i)) > bnd_cond)
                x(i+1) = -x(i) + dx(i);
            else
                x(i+1) = x(i) + dx(i);
            end
            % check for y
            if (abs(y(i) + dy(i)) > bnd_cond)
                y(i+1) = -y(i) + dy(i);
            else
                y(i+1) = y(i) + dy(i);
            end
            % Rotation
            theta(i+1) = theta(i);
        case 2
            % Fixed boundaries
            % Check for x
            if (abs(x(i) + dx(i)) > bnd_cond)
                x(i+1) = sign(x(i) + dx(i)) * bnd_cond;
            else
                x(i+1) = x(i) + dx(i);
            end
            % Check for y
            if (abs(y(i) + dy(i)) > bnd_cond)
                y(i+1) = sign(y(i) + dy(i)) * bnd_cond;
            else
                y(i+1) = y(i) + dy(i);
            end
            % Rotation
            theta(i+1) = theta(i);
        % Check for bounce boundaries
        case 3
            % Check for x
            if (abs(x(i) + dx(i)) > bnd_cond)
                x(i+1) = sign(x(i) + dx(i)) * bnd_cond - ...
                    sign(dx(i)) * (x(i) + dx(i) - sign(x(i) + dx(i)) * bnd_cond);
                % Rotation
                theta(i+1) = 2*sign((y(i) + dy(i)) - y(i)) * pi/2 - theta(i);
            else
                x(i+1) = x(i) + dx(i);
                theta(i+1) = theta(i);
            end
            % Check for x
            if (abs(y(i) + dy(i)) > bnd_cond)
                y(i+1) = sign(y(i) + dy(i)) * bnd_cond - ...
                    sign(dy(i)) * (y(i) + dy(i) - sign(y(i) + dy(i)) * bnd_cond);
                % Rotation
                theta(i+1) = 2*sign((x(i) + dx(i)) - x(i)) * pi/2 - theta(i);
            else
                y(i+1) = y(i) + dy(i);
                theta(i+1) = theta(i);
            end

    end

    
    if (col_det)
        % Plot allowed trajectory
        plot([x(i), x_col(i)], [y(i), y_col(i)], 'linewidth', 1.5, 'color', 'blue')
        % Plot unallowed trajectory
        plot([x_col(i), x(i+1)], [y_col(i), y(i+1)], 'linewidth', 1.5, 'color', 'red')
        pause
    else
        % Plot unallowed trajectory
        plot([x(i), x(i+1)], [y(i), y(i+1)], 'linewidth', 1.5, 'color', 'blue')
        pause
    end

end

% Take next step
% x2 = x + v * dt * cos(theta);
% y2 = y + v * dt * sin(theta);

%% plot
% figure('name', 'motion')
% hold on; grid on
% axis([-2, 2, -2, 2])
% % Plot box
% plot(bnd_cond_box.x, bnd_cond_box.y, 'linewidth', 2, 'color', 'black')
% 
% % Plot allowed trajectory
% plot([x(1), x_col(1)], [y(1), y_col(1)], 'linewidth', 1.5, 'color', 'blue')
% pause
% % Plot unallowed trajectory
% plot([x_col(1), x(2)], [y_col(1), y(2)], 'linewidth', 1.5, 'color', 'red')
% pause
% % Plot next step
% plot([x(2), x_col(2)], [y(2), y_col(2)], 'linewidth', 1.5, 'color', 'blue')
% pause
% % Plot unallowed trajectory
% plot([x_col(2), x(3)], [y_col(2), y(3)], 'linewidth', 1.5, 'color', 'red')


