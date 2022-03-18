close all
clear
clc

screenSize_x=1280;
screenSize_y=720;

Screen('Preference', 'SkipSyncTests', 1);
win= Screen('OpenWindow', 0, [127 127 127], [0 0 screenSize_x screenSize_y]);

DrawFormattedText(win, 'DATA IS LOADING...', 'center', 'center');
Screen('Flip', win);
pause(1);

%7 subjects, movie_run-4
sub6_eyeGaze_data= struct2table(tdfread('sub-06_ses-movie_task-movie_run-4_recording-eyegaze_physio.tsv'));
sub9_eyeGaze_data= struct2table(tdfread('sub-09_ses-movie_task-movie_run-4_recording-eyegaze_physio.tsv'));
sub15_eyeGaze_data= struct2table(tdfread('sub-15_ses-movie_task-movie_run-4_recording-eyegaze_physio.tsv'));
sub16_eyeGaze_data= struct2table(tdfread('sub-16_ses-movie_task-movie_run-4_recording-eyegaze_physio.tsv'));
sub17_eyeGaze_data= struct2table(tdfread('sub-17_ses-movie_task-movie_run-4_recording-eyegaze_physio.tsv'));
sub18_eyeGaze_data= struct2table(tdfread('sub-18_ses-movie_task-movie_run-4_recording-eyegaze_physio.tsv'));
sub19_eyeGaze_data= struct2table(tdfread('sub-19_ses-movie_task-movie_run-4_recording-eyegaze_physio.tsv'));

%length of data for all subjects
until=min([height(sub6_eyeGaze_data),height(sub9_eyeGaze_data),height(sub15_eyeGaze_data)...
    ,height(sub16_eyeGaze_data),height(sub17_eyeGaze_data),height(sub18_eyeGaze_data),height(sub19_eyeGaze_data)]);

%X and Y(+87 due to the gray bars) coordinates of the eye gazes for all subjects
x= [table2array(sub6_eyeGaze_data(1:until,1)),table2array(sub9_eyeGaze_data(1:until,1)),table2array(sub15_eyeGaze_data(1:until,1))...
    ,table2array(sub16_eyeGaze_data(1:until,1)),table2array(sub17_eyeGaze_data(1:until,1))...
    ,table2array(sub18_eyeGaze_data(1:until,1)),table2array(sub19_eyeGaze_data(1:until,1))];

y= [table2array(sub6_eyeGaze_data(1:until,2)),table2array(sub9_eyeGaze_data(1:until,2)),table2array(sub15_eyeGaze_data(1:until,2))...
    ,table2array(sub16_eyeGaze_data(1:until,2)),table2array(sub17_eyeGaze_data(1:until,2))...
    ,table2array(sub18_eyeGaze_data(1:until,2)),table2array(sub19_eyeGaze_data(1:until,2))]+87;

%Pupil area measurement
sub_pupilArea_raw= [table2array(sub6_eyeGaze_data(1:until,3)),table2array(sub9_eyeGaze_data(1:until,3))...
    ,table2array(sub15_eyeGaze_data(1:until,3)),table2array(sub16_eyeGaze_data(1:until,3))...
    ,table2array(sub17_eyeGaze_data(1:until,3)),table2array(sub18_eyeGaze_data(1:until,3))...
    ,table2array(sub19_eyeGaze_data(1:until,3))];
sub_Colour= [randperm(255,3);randperm(255,3);randperm(255,3);randperm(255,3);randperm(255,3);randperm(255,3);randperm(255,3)];

%Max value for Pupil area is 100
sub_pupilArea= screenSize_x*0.04*abs(normalize(sub_pupilArea_raw));
id1 = find(sub_pupilArea>100);
sub_pupilArea(id1)=100;
%Min value for Pupil area is 10
id2 = find(sub_pupilArea<10);
sub_pupilArea(id2)=10;

%visualization
for ii= 1:until
        
    Screen(win, 'FillRect', [255 255 255], [0 87 screenSize_x screenSize_y-87]); % 1280x546
    
    Screen('FillOval', win, [sub_Colour(1,:);sub_Colour(2,:);sub_Colour(3,:);sub_Colour(4,:);sub_Colour(5,:);...
        sub_Colour(6,:);sub_Colour(7,:)].',...
        [[x(ii,1) y(ii,1) x(ii,1)+sub_pupilArea(ii,1) y(ii,1)+sub_pupilArea(ii,1)]-sub_pupilArea(ii,1)/2;...
        [x(ii,2) y(ii,2) x(ii,2)+sub_pupilArea(ii,2) y(ii,2)+sub_pupilArea(ii,2)]-sub_pupilArea(ii,2)/2;...
        [x(ii,3) y(ii,3) x(ii,3)+sub_pupilArea(ii,3) y(ii,3)+sub_pupilArea(ii,3)]-sub_pupilArea(ii,3)/2;...
        [x(ii,4) y(ii,4) x(ii,4)+sub_pupilArea(ii,4) y(ii,4)+sub_pupilArea(ii,4)]-sub_pupilArea(ii,4)/2;...
        [x(ii,5) y(ii,5) x(ii,5)+sub_pupilArea(ii,5) y(ii,5)+sub_pupilArea(ii,5)]-sub_pupilArea(ii,5)/2;...
        [x(ii,6) y(ii,6) x(ii,6)+sub_pupilArea(ii,6) y(ii,6)+sub_pupilArea(ii,6)]-sub_pupilArea(ii,6)/2;...
        [x(ii,7) y(ii,7) x(ii,7)+sub_pupilArea(ii,7) y(ii,7)+sub_pupilArea(ii,7)]-sub_pupilArea(ii,7)/2].',10)
    
    Screen('Flip',win);
    
end

[secs, keyCode] = KbStrokeWait;
sca
