clear all; clc


NeurNet = NeuralNetwork();

NeurNet = NeurNet.init();

% x = {round(64 * rand(1, 4)), round(64 * rand(1, 4)), round(64 * rand(1, 4)), round(64 * rand(1, 4))}';
% t = 20 * randn(1, 4);
% y = train(NeurNet.net, x, t);

for i=1:100

    x = {round(64 * rand(1)), round(64 * rand(1)), round(64 * rand(1)), round(64 * rand(1))}';
    y = NeurNet.net(x);

    fprintf('Input values: [%d, %d, %d, %d] \n', x{1}, x{2}, x{3}, x{4})
    fprintf('Output effort value: %.03f \n', y{1})

    pause(1)

end