function objects = app_topview_orientation(objects, SEM_data)

for i = 1:length(objects.Area)
    clear pixel_list
    %Pixel_list is in (y,x)
    pixel_list = objects.PixelList{i};
    for j = 1:length(pixel_list)
        pixel_value = SEM_data(pixel_list(j,2), pixel_list(j,1));
        %Now pixel list will be (y,x, pixel value)
        pixel_list(j,3) = pixel_value;
    end


    %Now let's find the average pixel value for all unique y-values:
    average_y = nonzeros(accumarray(pixel_list(:,1) , pixel_list(:,3), [], @mean));
    py = polyfit(1:length(average_y),average_y,1);


    %Do the same thing, but now for all unique x-values:
    %We start by sorting for the x-value:
    pixel_list = sortrows(pixel_list,2);
    average_x = nonzeros(accumarray(pixel_list(:,2) , pixel_list(:,3), [], @mean));
    px = polyfit(1:length(average_x),average_x,1);

    
    %There are now a few scenarios:
    %Scenario 1: coefficient py = neg, px = neg -> tip of wire = left-top
    %Scenario 2: coefficient py = pos, px = neg -> tip of wire = right-top
    %Scenario 3: coefficient py = neg, px = pos -> tip of wire = left-bottom
    %Scenario 4: coefficient py = pos, px = pos -> tip of wire = right-bottom

    %Wire pointing to left-top
    if py(1)<0 && px(1)<0
        objects.Wire_direction(i) = 1;
        if objects.Orientation(i) < 0
            objects.TopViewOrientation(i) = mod(objects.Orientation(i), 360)-180;
        elseif objects.Orientation(i) >= 0
            objects.TopViewOrientation(i) = mod(objects.Orientation(i), 360);
        end
    elseif py(1)>0 && px(1)<0
        objects.Wire_direction(i) = 2;
        if objects.Orientation(i) < 0
            objects.TopViewOrientation(i) = mod(objects.Orientation(i), 360)-180;
        elseif objects.Orientation(i) >= 0
            objects.TopViewOrientation(i) = mod(objects.Orientation(i), 360);
        end
    elseif py(1)<0 && px(1)>0
        objects.Wire_direction(i) = 3;
        if objects.Orientation(i) <= 0
            objects.TopViewOrientation(i) = mod(objects.Orientation(i), 360);
        elseif objects.Orientation(i) <= 180
            objects.TopViewOrientation(i) = objects.Orientation(i)+180;
        end
    elseif py(1)>0 && px(1)> 0
        objects.Wire_direction(i) = 4;
        if objects.Orientation(i) <= 0
            objects.TopViewOrientation(i) = mod(objects.Orientation(i), 360);
        elseif objects.Orientation(i) <= 180
            objects.TopViewOrientation(i) = objects.Orientation(i)+180;
        end
    elseif py(1)==0 || px(1) ==0
        objects.TopViewOrientation(i) = -10;
    end
end

end