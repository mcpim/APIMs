function new_SEM_data = app_removebackground(SEM_Image, SEM_data, contrast_parameter, object_too_small, x, y)

disp('Please click on the background and press "Enter".')
imshow(SEM_Image)
%title('Please click on the background and press "Enter".')
pixel_value = double(SEM_data(y,x));
average_background = mean(pixel_value(1:end,1));
%close all
cleanimage = SEM_data > average_background-contrast_parameter & SEM_data < average_background+contrast_parameter ;
new_SEM_data = SEM_data - SEM_data .* uint8(cleanimage);

%Filling up any gaps caused by background removal:
new_SEM_data = imfill(new_SEM_data,4,'holes');
%Find any 'stray pixels' that are left-over:
left_over_pixels = bwareaopen(new_SEM_data, object_too_small);
%Remove these stray pixels:
new_SEM_data = uint8(left_over_pixels) .* new_SEM_data;
clc

end