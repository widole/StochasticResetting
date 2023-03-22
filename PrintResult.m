%% Check GA outcome


%% Plot average alpha value over generations
for i=1:length(genalg.gen_alpha)

    % Calculate average alpha
    gen_mean_alpha(i) = mean(genalg.gen_alpha{i});

    % Calculate average amount of explored areas
    gen_mean_expl(i) = mean(genalg.gen_expl_areas{i});

end


% Plot averages
figure('name', 'Mean alpha and amount of explored areas by generation')
% First plot alphas
subplot(2,1,1)
plot(1:params.nr_gen, gen_mean_alpha, 'o-', 'linewidth', 1.5, 'color', 'blue')
% Explored areas
subplot(2,1,2)
plot(1:params.nr_gen, gen_mean_expl, 'o-', 'LineWidth', 1.5, 'color', 'blue')