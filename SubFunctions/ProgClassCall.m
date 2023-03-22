%% Main simulation script
% This script is called from the main Main.m file in order to start the
% simulations. After the simulations are completed, the variables and
% results will be saved in a .mat file in the SavedResults folder. From the
% Main.m file, we can run and plot previously ran simulations or start a
% new one with certain parameters. This separates the actual simulation
% from the showing of results, which can be beneficial in some cases.

%% Parameters
% The first thing to do, is load the parameter class, this contains all the
% simulation parameters used for the simulation. If anything is to be
% changed before the simulation takes place, \ParamFiles\Params.m is where
% to do that.

% Load parameters
params = Params();


%% Create the separate program dependent on what the input is

% User input dependent class creation
switch list{indx}

    % First case, normal simulation
    case 'New Simulation'

        % Create Class
        comparesim = CompMain();
        comparesim = comparesim.run(params);

        % Plot results
        comparesim.plotting.plot_result( ...
            comparesim.world, comparesim.pop.savevar, params);

    % Second case, genetic algorithm to find neural network candidate
    case 'Genetic Algorithm'

        % Create class
        genalg = GAMain();
        genalg = genalg.init_GA(params);

        % Run alogirithm
        [genalg, fittest_ind] = genalg.run_GA(params);

    % Third case, simulate levy flight in different environments
    case 'Levy Flight'

        % Create class
        levfli = LevFli();
        levfli = levfli.init_lf(params);

        levfli = levfli.run(params);

        disp('Run levy')
        % Run simulation
        % run

    case 'Stochastic Reset'

        % create stochastic resetting class
        stochres = StochasticReset();
        stochres = stochres.init_SR(params);

        stochres = stochres.run(params);

        % Run simulation

       
end







