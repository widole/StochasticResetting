%% Our implementation of a neural network

classdef NeuralNetwork

    properties
    
            %% Create arrays
            input;
            hidden;
            output;
            
            hidden_weights;
            output_weights;
            
            dhidden_weights;
            doutput_weights;
        


    end

    methods

        function self = init_NeuralNetwork(self, params)
            % In this function we initialize the network to get random
            % weights and biases and create the nodes

            %% Initialize arrays

            % Create arrays for nodes
            self.input = zeros(params.nr_input_nodes, 1);
            self.hidden = zeros(params.nr_hidden_nodes, 1);
            self.output = zeros(params.nr_output_nodes, 1);
            
            % init arrays for storing weights
            self.hidden_weights = zeros(params.nr_input_nodes + 1, params.nr_hidden_nodes);
            self.output_weights = zeros(params.nr_hidden_nodes + 1, params.nr_output_nodes);

            % init array for storing weight changes
%             self.dhidden_weights = zeros(params.nr_input_nodes+1, params.nr_hidden_nodes);
%             self.doutput_weights = zeros(params.nr_hidden_nodes+1, params.nr_output_nodes);

            %% Initialize weights and biases

            %----- Weights Inputs -> Hidden -----%
            for i=1:params.nr_hidden_nodes
                % for each hidden node
                for j=1:params.nr_input_nodes+1
                    % for each input node (+1 for bias)

                    % Initialize the change in weights
%                     self.dhidden_weights(j,i) = 0.0;

                    % get random value
                    R = rand;

                    % Use random to set init weight between
                    % [-init_weight_max, init_weight_max]
                    self.hidden_weights(j,i) = 2 * (R - .5) * params.init_weight_max;

                end
            end

            %----- Weights Hidden -> Output -----%
            for i=1:params.nr_output_nodes
                % for each output node
                for j=1:params.nr_hidden_nodes+1
                    % for each hidden nodes (+1 for bias)

                    % Initialize the change in weights
%                     self.doutput_weights(j,i) = 0.0;

                    % get random value
                    R = rand;

                    % use the random to set initi weight between
                    % [-init_weight_max, init_weight_max]
                    self.output_weights(j,i) = 2 * (R - .5) * params.init_weight_max;

                end
            end
            
            
            
        % End function
        end


        function y = get_output(self, mem_arr)


            %% Set input to input
            for i=1:length(self.input)

                self.input(i) = mem_arr{i};

            % End for
            end

            %% Compute hidden layer activation
            for i=1:length(self.hidden)

                % First run the bias through
                accum = self.hidden_weights(length(self.input)+1, i);

                % run the inputs through the weights
                for j=1:length(self.input)

                    % add the value
                    accum = accum + self.input(j) * self.hidden_weights(j,i);

                end

                % run the activation (relu in this case)
                self.hidden(i) = max(0, accum);

            % End for
            end

            %% Compute output layer activations
            for i=1:length(self.output)

                % Calculate bias
                accum = self.output_weights(length(self.hidden)+1, i);

                for j=1:length(self.hidden)

                    % Add the value
                    accum = accum + self.hidden(j) * self.output_weights(j,i);

                end

                % run the activation (relu in this case)
                self.output(i) = max(0, accum);

            end

            %% Set output
    
            % Return output
            y = self.output;          
            
        % End function
        end

        
    % End methods
    end

% End class
end