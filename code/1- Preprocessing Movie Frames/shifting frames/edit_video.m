function edit_video(input_video, eye_gazes, output_name, target_size, workingDir)

%% Example Inputs:
% input_video = 'fg_av_seg7.mkv'
% eye_gazes = 'sub-19_ses-movie_task-movie_run-8_recording-eyegaze_physio.tsv'
% output_name = 'segment8.avi'
% target_size = [720 720]
% workingDir = tempname

tic

%% Video into its frames (25 fps; 25 frames per second)
mkdir(workingDir);
mkdir(workingDir, 'images');

% change the name accordingly
shuttleVideo = VideoReader(input_video);
NumFrames = shuttleVideo.NumFrames;

h = waitbar(0,'Please wait: reading the video frames...');
ii = 1;
while hasFrame(shuttleVideo)
    img = readFrame(shuttleVideo);
    filename = [sprintf('%05d', ii) '.jpg'];
    fullname = fullfile(workingDir, 'images', filename);
    imwrite(img, fullname);    % Write out to a JPEG file (img1.jpg, img2.jpg, etc.)
    
    waitbar(ii/NumFrames, h);
    ii = ii+1;
end

disp('reading the video frames is done')

imageNames = dir(fullfile(workingDir, 'images', '*.jpg'));
imageNames = {imageNames.name}';

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

%% shift each frame according to eye gaze locations
currentFolder = pwd;
mkdir('edited_frames');

h = waitbar(0,'Please wait: shifting the video frames...');

for ii = 1:length(imageNames)
    
    if ii > length(x)
        break
    end
    
    % each frame
    my_image = imread(fullfile(workingDir, 'images', imageNames{ii}));
    if isnan(x(ii)) && isnan(y(ii))
        shifted_image = my_image;
    else
        shifted_image = shift_frame(my_image, x(ii), y(ii));
    end
    filename = [sprintf('%05d', ii) '.jpg'];
    fullname = fullfile(currentFolder, 'edited_frames', filename);
    imwrite(shifted_image, fullname, 'jpg');
    
    waitbar(ii/length(imageNames), h); 
end

disp('shifting the video frames is done')

%% Make the video
imageNames = dir(fullfile(currentFolder, 'edited_frames', '*.jpg'));
imageNames = {imageNames.name}';

% Construct a VideoWriter object, which creates a Motion-JPEG AVI file by default.
outputVideo = VideoWriter(fullfile(currentFolder, output_name));
outputVideo.FrameRate = shuttleVideo.FrameRate;
open(outputVideo);

h = waitbar(0,'Please wait: writing the output video...');

% Loop through the image sequence, load each image, and then write it to the video.
if length(x) <= length(imageNames)
    N = length(x);
else
    N = length(imageNames);
end

for ii = 1:N
    img = imread(fullfile(currentFolder, 'edited_frames', imageNames{ii}));
    
    %%% make it e.g. 720x720
    %Create a Rectangle object that specifies the spatial extent of the crop window.
    r = centerCropWindow2d(size(img), target_size);
    %Crop the image to the spatial extents. Display the cropped region.
    J = imcrop(img, r);
    
    writeVideo(outputVideo, J)
    
    if mod(ii,100)==1
        fprintf('please wait: step[%d] ', ii)
        fprintf('\n')
    end
    
    waitbar(ii/length(x), h);
end

% Finalize the video file.
close(outputVideo)

disp('writing the output video is done')

toc
end
