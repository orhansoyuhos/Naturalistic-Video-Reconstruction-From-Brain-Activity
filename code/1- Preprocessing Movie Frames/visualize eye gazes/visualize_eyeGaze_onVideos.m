close all
clear
clc

screenSize_x=1280;
screenSize_y=720;

Screen('Preference', 'SkipSyncTests', 1);
win= Screen('OpenWindow', 0, [127 127 127], [0 0 screenSize_x screenSize_y]);

%
DrawFormattedText(win, 'Video frames are LOADING...', 'center', 'center');
Screen('Flip', win);
pause(1);

%Video into its frames (25 fps; 25 frames per second)
workingDir = tempname;
mkdir(workingDir);
mkdir(workingDir,'images');

shuttleVideo = VideoReader('fg_av_seg0.mkv');

ii = 1;
while hasFrame(shuttleVideo)
   img = readFrame(shuttleVideo);
   filename = [sprintf('%05d',ii) '.jpg'];
   fullname = fullfile(workingDir,'images',filename);
   imwrite(img,fullname);    % Write out to a JPEG file (img1.jpg, img2.jpg, etc.)
   ii = ii+1;
end

imageNames = dir(fullfile(workingDir,'images','*.jpg'));
imageNames = {imageNames.name}';

%
DrawFormattedText(win, 'Eye tracking data are LOADING...', 'center', 'center');
Screen('Flip', win);
pause(1);

%Eye tracking data (1000 Hz; 1000 lines per second)
%6 subjects, movie_run-1
sub2_eyeGaze_data= struct2table(tdfread('sub-02_ses-movie_task-movie_run-1_recording-eyegaze_physio.tsv'));
sub14_eyeGaze_data= struct2table(tdfread('sub-14_ses-movie_task-movie_run-1_recording-eyegaze_physio.tsv'));
sub15_eyeGaze_data= struct2table(tdfread('sub-15_ses-movie_task-movie_run-1_recording-eyegaze_physio.tsv'));
sub17_eyeGaze_data= struct2table(tdfread('sub-17_ses-movie_task-movie_run-1_recording-eyegaze_physio.tsv'));
sub18_eyeGaze_data= struct2table(tdfread('sub-18_ses-movie_task-movie_run-1_recording-eyegaze_physio.tsv'));
sub19_eyeGaze_data= struct2table(tdfread('sub-19_ses-movie_task-movie_run-1_recording-eyegaze_physio.tsv'));

%length of data valid for all subjects
until=min([height(sub2_eyeGaze_data),height(sub14_eyeGaze_data),height(sub15_eyeGaze_data)...
    ,height(sub17_eyeGaze_data),height(sub18_eyeGaze_data),height(sub19_eyeGaze_data)]);
until=until-mod(until,40);

%X and Y(+87 due to the gray bars) coordinates of the eye gazes for all subjects
x= [table2array(sub2_eyeGaze_data(1:until,1)),table2array(sub14_eyeGaze_data(1:until,1)),table2array(sub15_eyeGaze_data(1:until,1))...
    ,table2array(sub17_eyeGaze_data(1:until,1))...
    ,table2array(sub18_eyeGaze_data(1:until,1)),table2array(sub19_eyeGaze_data(1:until,1))];

y= [table2array(sub2_eyeGaze_data(1:until,2)),table2array(sub14_eyeGaze_data(1:until,2)),table2array(sub15_eyeGaze_data(1:until,2))...
    table2array(sub17_eyeGaze_data(1:until,2))...
    ,table2array(sub18_eyeGaze_data(1:until,2)),table2array(sub19_eyeGaze_data(1:until,2))+87];

%Pupil area measurement
sub_pupilArea_raw= [table2array(sub2_eyeGaze_data(1:until,3)),table2array(sub14_eyeGaze_data(1:until,3))...
    ,table2array(sub15_eyeGaze_data(1:until,3))...
    ,table2array(sub17_eyeGaze_data(1:until,3)),table2array(sub18_eyeGaze_data(1:until,3))...
    ,table2array(sub19_eyeGaze_data(1:until,3))];
sub_Colour= [randperm(255,3);randperm(255,3);randperm(255,3);randperm(255,3);randperm(255,3);randperm(255,3)];

%Max value for Pupil area is 100
sub_pupilArea= screenSize_x*0.04*abs(normalize(sub_pupilArea_raw)); %normalize excludes NaN values
id1 = find(sub_pupilArea>100);
sub_pupilArea(id1)=100;
%Min value for Pupil area is 10
id2 = find(sub_pupilArea<10);
sub_pupilArea(id2)=10;

%preprocess eye gaze data for visualization: take the average of 40 lines for each frame (25fps)
x=squeeze(mean(reshape(x,40,[],6),1,'omitnan'));
y=squeeze(mean(reshape(y,40,[],6),1,'omitnan'));
sub_pupilArea=squeeze(mean(reshape(sub_pupilArea,40,[],6),1,'omitnan'));

%visualization
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for ii = 1:length(imageNames)
    
    %each frame
    my_image=imread(fullfile(workingDir,'images',imageNames{ii}));
    tex=Screen('MakeTexture', win, my_image);
    Screen('DrawTexture', win, tex);
    
    %each eye gaze point
    Screen('FillOval', win, [sub_Colour(1,:);sub_Colour(2,:);sub_Colour(3,:);sub_Colour(4,:);sub_Colour(5,:);...
        sub_Colour(6,:)].',...
        [[x(ii,1) y(ii,1) x(ii,1)+sub_pupilArea(ii,1) y(ii,1)+sub_pupilArea(ii,1)]-sub_pupilArea(ii,1)/2;...
        [x(ii,2) y(ii,2) x(ii,2)+sub_pupilArea(ii,2) y(ii,2)+sub_pupilArea(ii,2)]-sub_pupilArea(ii,2)/2;...
        [x(ii,3) y(ii,3) x(ii,3)+sub_pupilArea(ii,3) y(ii,3)+sub_pupilArea(ii,3)]-sub_pupilArea(ii,3)/2;...
        [x(ii,4) y(ii,4) x(ii,4)+sub_pupilArea(ii,4) y(ii,4)+sub_pupilArea(ii,4)]-sub_pupilArea(ii,4)/2;...
        [x(ii,5) y(ii,5) x(ii,5)+sub_pupilArea(ii,5) y(ii,5)+sub_pupilArea(ii,5)]-sub_pupilArea(ii,5)/2;...
        [x(ii,6) y(ii,6) x(ii,6)+sub_pupilArea(ii,6) y(ii,6)+sub_pupilArea(ii,6)]-sub_pupilArea(ii,6)/2].',10)
    
    Screen('Flip', win, [], 1);
    
end

[secs, keyCode] = KbStrokeWait;
sca
