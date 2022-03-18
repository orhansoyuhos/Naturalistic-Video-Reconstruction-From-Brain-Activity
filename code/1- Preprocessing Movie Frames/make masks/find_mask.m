function find_mask(eye_gazes, output_name, target_size)

tic
%% Define the raw frame

frame = [720 1280];
native_frame = [546 1280];

k = (frame(1)-native_frame(1))/2;

raw_frame = ones(frame(1), frame(2), 3)*-255;
raw_frame(k+1 : frame(1)-k, :, :) = 255;

% imshow(mask)

%% Eye tracking data (1000 Hz; 1000 lines per second)
% x subjects, movie_run-x,  %change the name accordingly
sub_eyeGaze_data = struct2table(tdfread(eye_gazes));

% length of data valid for all subjects
until = height(sub_eyeGaze_data);
until = until - mod(until,40);

% X and Y(+87 due to the gray bars) coordinates of the eye gazes for all subjects
x = table2array(sub_eyeGaze_data(1:until, 1));
y = table2array(sub_eyeGaze_data(1:until, 2)) + 87;

% preprocess eye gaze data for visualization: take the average of 40 lines for each frame (25fps)
x = squeeze(mean(reshape(x, 40, []), 1, 'omitnan'));
y = squeeze(mean(reshape(y, 40, []), 1, 'omitnan'));

disp('reading the eye-gaze data is done')

%% Shifting the video frames
currentFolder = pwd;
mkdir('edited_frames');

h = waitbar(0, 'Please wait: shifting the video frames...');

% shift each frame according to eye gaze locations
for ii = 1:length(x)
    
    if ii > length(x)
        break
    end
    
    % each frame
    my_image = raw_frame;
    if isnan(x(ii)) && isnan(y(ii))
        shifted_image = my_image;
    else
        shifted_image = shift_frame(my_image, x(ii), y(ii));
    end
    filename = [sprintf('%05d', ii) '.jpg'];
    fullname = fullfile(currentFolder, 'edited_frames', filename);
    imwrite(shifted_image, fullname, 'jpg');
    
    waitbar(ii/length(x), h);
    
end

disp('shifting the video frames is done')

%% Construct a VideoWriter object, which creates a Motion-JPEG AVI file by default.
outputVideo = VideoWriter(fullfile(currentFolder, output_name));
outputVideo.FrameRate = 25;
open(outputVideo);

h = waitbar(0, 'Please wait: writing the output video...');

% Loop through the image sequence, load each image, and then write it to the video.
imageNames = dir(fullfile(currentFolder, 'edited_frames', '*.jpg'));
imageNames = {imageNames.name}';
N = length(imageNames);

for ii = 1:N
    img = imread(fullfile(currentFolder, 'edited_frames', imageNames{ii}));
    
    %%% make it e.g. 720x720
    %Create a Rectangle object that specifies the spatial extent of the crop window.
    r = centerCropWindow2d(size(img), target_size);
    %Crop the image to the spatial extents. Display the cropped region.
    J = imcrop(img, r);
    
    writeVideo(outputVideo, J)
    
    if mod(ii, 100)==1
        fprintf('please wait: step[%d] ', ii)
        fprintf('\n')
    end
    
    waitbar(ii/N, h);
end

% Finalize the video file.
close(outputVideo)

disp('writing the output video is done')

% delete the tmp file
rmdir edited_frames s

toc
end