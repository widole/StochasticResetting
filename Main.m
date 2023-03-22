%% Main Simulation Project File
clear all; close all; clc
% For further reading of Levy Flight implementation please see
% "Evolutionarily Emergent Foraging Strategies for Active Agents" by Emil
% Jansson,
% link: https://odr.chalmers.se/items/e10d85ed-38d4-499d-ba98-65ccfd515f11

% For Stochastic Resetting, please check Yael Roichmans group's research at
% the Tel Aviv University

% Structure of program is classes: always starts with capital letter for
% each word, no spaces, underscores etc. Class methods, no capital letters,
% underscores to separate words, same for properties

%% Run Simulation Script

% While loop to rerun the program after it has finished
while true
    % Program selection questions
    list = {'New Simulation', 'Genetic Algorithm', 'Levy Flight', 'Stochastic Reset'};
    [indx,tf] = listdlg('ListString', list);


%     answer = questdlg('What do you want to do?', ...
% 	    'Program Selection', ...
% 	    'New Simulation', 'Genetic Algorithm', 'Levy Flight', 'Cancel', ...
%         'Genetic Algorithm');
    
    if tf
        % Handle response
        switch list{indx}
            case 'New Simulation'
                disp([list{indx} ': Starting new simulation...'])
                ProgClassCall;
                break;
            case 'Genetic Algorithm'
                disp([list{indx} ': Starting Genetic Algorithm Training...'])
                ProgClassCall;
                break;
            case 'Levy Flight'
                disp([list{indx} ': Starting Levy Flight simulation'])
                ProgClassCall;
                break;
            case 'Stochastic Reset'
                disp([list{indx} ': Strarting Stochastic Resetting simulation...'])
                ProgClassCall;
                break;
            case 'Cancel'
                disp('Shutting down...')
                break
        end
    else
        disp('Shutting down...')
        break
    end
end