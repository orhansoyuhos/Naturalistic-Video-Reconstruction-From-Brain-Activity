
function shiftedImage = shift_frame(I, x_gaze, y_gaze)

[rows, columns, ~] = size(I);

y_center = rows / 2;
x_center = columns / 2;

shiftedImage = imtranslate(I, [x_center-x_gaze, y_center-y_gaze]);

end


%1000,50; 1200,650; 200,650; 200,40; 450,400
%my_image= imread('deneme.jpg');
%shiftedImage=shift_frame(my_image,1000,50);
%set(gca,'Visible','on');

