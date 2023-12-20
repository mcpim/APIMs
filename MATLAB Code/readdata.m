function [length_per_pixel, tilt_angle] = readdata(file)

%Reading off the given pixel size
txtfile = fileread(file);
str_loc_pixel_size = strfind(txtfile,'Image Pixel Size = ');
length_per_pixel = str2double(txtfile(str_loc_pixel_size+19:str_loc_pixel_size+23));

%Reading off the given tilt angle
str_loc_tilt = strfind(txtfile,'Stage at T = ');
if str2double(txtfile(str_loc_tilt+14)) == 0
    tilt_angle = 0;
else
    tilt_angle = str2double(txtfile(str_loc_tilt+14:str_loc_tilt+17));
end

end