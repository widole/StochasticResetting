%% Classdef for Tracking Objects

classdef Tracking

    properties

        % Segmentation threshold (value to distinguish if the pixel is 1 or 0)
        segmentationThreshold = 0.0005;

        % Parameters
        motionModel = 'ConstantVelocity';
        % initialLocation = [0, 0];
        initialEstimateError = 1E5 * ones(1,2);
        motionNoise = [25, 10]; % 1];
        measurementNoise = 25;

        foregroundDetector;
        blobAnalyzer;
        videoPlayer;
        kalmanFilter;

        % Initiate arrays for saving video images, detections and trackings
        accumulatedImage      = 0;
        accumulatedDetections = zeros(0, 2);
        accumulatedTrackings  = zeros(0, 2);

        % Initiate variables to hold values
        trackedLocation = [];

        % Set tracked initialized to false in order to check when we have first
        % detection
        isTrackInitialized;

        % Save current frame
        frame;
    
    % End properties
    end

    methods

        function self = init(self)
            
            % Create foreground detector (this is our "system")
            self.foregroundDetector = vision.ForegroundDetector(...
                    'NumTrainingFrames', 10, 'InitialVariance', ...
                    self.segmentationThreshold);
            % Create blod analyzer (What is this for?)
            self.blobAnalyzer = vision.BlobAnalysis('AreaOutputPort', false, ...
                    'MinimumBlobArea', 60, 'CentroidOutputPort', true);

            % Create video player to show detections
            self.videoPlayer = vision.VideoPlayer( ...
                'Position', [100,100,500,400]);

            % Set tracked initialized to false in order to check when we have first
            % detection
            self.isTrackInitialized = false;

        end

        function self = getFrame(self, fig)

            % Get axis
            ax = fig.CurrentAxes;
            % Set background color to black
            ax.Color = 'black';
            % Set units to pixels
            ax.Units = 'pixels';

            % Get position and size of figure
            rect = get(ax, 'Position');

            % Save plot as frame
            self.frame = frame2im(getframe(fig, rect));

        end

        function self = objDetect(self)

            % Turn the frame into gray-scale as well as from image to single
            % precision (i.e. instead of 3 values per pixel, we have 1)
            grayImage = rgb2gray(im2single(self.frame));

            % Now we use the step function to first detect the foreground vs
            % background of the image
            foregroundMask = step(self.foregroundDetector, grayImage);
            % Save object that has been detected from the foreground mask
            detection = step(self.blobAnalyzer, foregroundMask);

            % If an object is detected or not, we set true of false here
            if (isempty(detection))
                objectDetected = false;
            else
                % Save only the first detected object in case there are several
                detection = detection(1,:);
                objectDetected = true;
            end

            % Kalman Filtering

            if ~self.isTrackInitialized
        
                % If we provide an initial location, then we do not have to check
                % this step really? The question is if it is beneficial to provide
                % an initial location or not. In the real system I guess we would
                % not know where they start.
                if objectDetected
                    % Initialize a track by creating a Kalman filter when the ball is
                    % detected for the first time. This is a function provided by
                    % Computer Vision Toolbox
                    self.kalmanFilter = configureKalmanFilter( ...
                        self.motionModel, detection, ...
                        self.initialEstimateError, self.motionNoise, ...
                        self.measurementNoise);
            
                    % Set is tracked to true to not repeat this step
                    self.isTrackInitialized = true;
        
                    % Since this is the initial position, we set it as the true
                    % corrected initial estimation
                    self.trackedLocation = correct( ...
                        self.kalmanFilter, detection);
        
                    % Provide label
                    label = 'Initial';
        
                else
        
                    % If the object is not detected initially, then we set this
                    self.trackedLocation = [];
                    % And no label
                    label = '';
        
                end
            
            else
              % Use the Kalman filter to track the ball.
              if objectDetected % The ball was detected.
                % Reduce the measurement noise by calling predict followed by
                % correct.
                % Predict is also a provided Computer Vision functions
                predict(self.kalmanFilter);
                % As well as correct is
                self.trackedLocation = correct(self.kalmanFilter, detection);
                label = 'Corrected';
              else % The ball was missing.
                % Predict the ball's location.
                self.trackedLocation = predict(self.kalmanFilter);
                label = 'Predicted';
              end
            end
        
            % Save the results of frame
            self.accumulatedImage = max(self.accumulatedImage, self.frame);
            self.accumulatedDetections = [self.accumulatedDetections; ...
                detection];
            self.accumulatedTrackings = [self.accumulatedTrackings; ...
                self.trackedLocation];
        
            % Combine the foregroundmask and the actual image to show the results
            combinedImage = max(repmat(foregroundMask, [1,1,3]), ...
                im2single(self.frame));
        
              if ~isempty(self.trackedLocation)
                shape = 'circle';
                region = self.trackedLocation;
                region(:, 3) = 5;
                combinedImage = insertObjectAnnotation(combinedImage, shape, ...
                  region, {label}, 'Color', 'red');
              end
        
            % Show image
            step(self.videoPlayer, combinedImage);
        
        
        end
    
        function self = showTrack(self, savevar, params)
            
            
            % Compare the real and tracked trajectories
        
            % Transform from positions from pixels to scale
            vidHeight = size(self.frame, 1);
            vidWidth = size(self.frame, 2);
            
            if (params.bnd_cond ~= 0)
                matHeight = 2 * params.world_size;
                matWidth = 2 * params.world_size;
            else
%                 matHeight = (max(savevar.pose{1}(1, :)) + 5) - ...
%                     (min(savevar.pose{1}(1, :)) - 5);
%                 matWidth = (max(savevar.pose{1}(2, :)) + 5) - ...
%                     (min(savevar.pose{1}(2, :)) - 5);
            end
            
            acc_track(:,1) = self.accumulatedTrackings(:,1) .* ...
                (matWidth / vidWidth);
            acc_track(:,2) = self.accumulatedTrackings(:,2) .* ...
                (matHeight / vidHeight);
            
            acc_track(:,1) = (acc_track(:, 1) - matWidth / 2); %  - acc_track(1,2));
            acc_track(:,2) = - (acc_track(:, 2) - matHeight / 2); %  - acc_track(1,1));
            
            figure('name', 'Real vs Tracked')
            axis([-params.world_size, params.world_size, ...
                    -params.world_size, params.world_size]);
            hold on; grid on
            
            p_track = plot(acc_track(:,1), acc_track(:, 2), 'r-o', 'markersize', 5);
            p_act = plot(savevar.pose{1}(1, :), savevar.pose{1}(2, :), 'b-x', 'markersize', 5);
            
            xlabel('Position [mm]')
            ylabel('Position [mm]')
            title('Real vs Tracked Positions')
            legend({'Tracked', 'Real'})

        end


    % End methods
    end

% End classdef
end