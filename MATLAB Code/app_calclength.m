function objects = app_calclength(objects, resolution, tilt_angle, length_per_pixel)

number_objects_to_calc = length(objects.Area);
objects.Length = zeros(number_objects_to_calc,1);
objects.Std_Length = zeros(number_objects_to_calc,1);
objects.PhysicalLength = zeros(number_objects_to_calc,1);
objects.Std_PhysicalLength = zeros(number_objects_to_calc,1);


for i = 1:number_objects_to_calc
    clear outline new_outline
    outline = objects.Outline{i};
    Pixel_info = objects.PixelList(i);
    %Calcute what rotation has to be applied
%     if objects.Orientation(i) < 0
%         rotation = mod(objects.Orientation(i),90);
%     else
%         rotation = mod(objects.Orientation(i),-90);
%     end
    rotation = mod(objects.Orientation(i),180)-90;
    %rotate object w.r.t axis:
    %Outline is in form (y,x)
    if rotation == 90 || rotation==0
    else
        new_outline(:,2) = outline(:,2)*cosd(rotation) - outline(:,1)*sind(rotation);
        new_outline(:,1) = outline(:,2)*sind(rotation) + outline(:,1)*cosd(rotation);
        outline = new_outline;
    end
    top_y = min(outline(:,1));
    bot_y = max(outline(:,1));
    top_x = mean(outline(find(outline(:,1) == top_y),2));
    bot_x = mean(outline(find(outline(:,1) == bot_y),2));

    coords = sortrows(Pixel_info{1},2);
    %mean_top_x = mean(nonzeros((coords(:,2) == coords(1,2)).*coords(:,1)));
    %mean_bot_x = mean(nonzeros((coords(:,2) == coords(end,2)).*coords(:,1)));
    %mean_top_y = coords(1,2)-0.5;
    %mean_bot_y = coords(end,2)+0.5;
    
    %Length in pixels.
    if coords(1,2)>1 && coords(end,2)<resolution(1)
        length_meas = sqrt((top_x - bot_x)^2 + (bot_y-top_y)^2);
    else
        length_meas = 0;
    end
    
    objects.Length(i) = length_meas;
    
    %Length in physical dimension.
    if tilt_angle > 0
        physical_length = length_per_pixel*length_meas/sind(tilt_angle);
    else
        physical_length = length_per_pixel*length_meas;
    end
    objects.PhysicalLength(i) = physical_length;
end
%Standard deviation is +/- 1 pixel
objects.Std_Length(:) = 1;
if tilt_angle > 0
    objects.Std_PhysicalLength(:) = length_per_pixel*1/sind(tilt_angle);
else
    objects.Std_PhysicalLength(:) = length_per_pixel*1;
end

end