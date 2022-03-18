% %
% % Example Inputs:
% input_video = 'fg_av_seg7.mkv'
% eye_gazes = 'sub-19_ses-movie_task-movie_run-8_recording-eyegaze_physio.tsv'
% output_name = 'segment8.avi'
% target_size = [720 720]
% workingDir = tempname
% %

%
% Example Inputs:
input_video = 'C:\Users\ASUS\Desktop\Visualization of Eye Gazes\fg_av_seg7.mkv';
eye_gazes = 'C:\Users\ASUS\Desktop\Visualization of Eye Gazes\Eye Tracking Data\18\sub-18_ses-movie_task-movie_run-8_recording-eyegaze_physio.tsv';
output_name = 'segment8.avi';
target_size = [672 672];
workingDir = tempname
%

edit_video(input_video, eye_gazes, output_name, target_size, workingDir)

display(workingDir)