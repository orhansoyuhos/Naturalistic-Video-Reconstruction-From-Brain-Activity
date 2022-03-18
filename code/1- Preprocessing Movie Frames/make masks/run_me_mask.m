%% select
sub = '18';
run = ['1', '2', '3', '4', '5', '6', '7', '8'];

target_size = [672 672];

%%
main = 'C:\Users\ASUS\Desktop\University of Trento\2- Second year\3- Internship\Donders AI\Visualization of Eye Gazes\Eye Tracking Data\';

for i=1:length(run)
    
    eye_gazes = fullfile(main, sprintf('%s', sub), ...
        sprintf('sub-%s_ses-movie_task-movie_run-%s_recording-eyegaze_physio.tsv', sub, run));
    
    output_name = sprintf('mask%s.avi', sub(i));
    
    find_mask(eye_gazes, output_name, target_size)
    
end