function plotinfo(SEM_Image, objects, see_bounds)

imshow(SEM_Image)
hold on

if see_bounds == 1
        visboundaries(objects.OutlineImageSpace)
end

number_objects_to_calc = length(objects.Area);

for i = 1:number_objects_to_calc
    
    %Orientation, length & width
    orientation = objects.Orientation(i);
    length_meas = objects.Length(i);
    width = objects.Width(i);

    %Physical length & width
    physical_length = objects.PhysicalLength(i);
    physical_width = objects.PhysicalWidth(i);    
    
    %Calculating centerpoint for the plots
    Pixel_info = objects.PixelList(i);
    coords = sortrows(Pixel_info{1},2);
    mean_top_x = mean(nonzeros((coords(:,2) == coords(1,2)).*coords(:,1)));
    mean_bot_x = mean(nonzeros((coords(:,2) == coords(end,2)).*coords(:,1)));
    mean_top_y = coords(1,2)-0.5;
    mean_bot_y = coords(end,2)+0.5;
    center_x = (mean_top_x+mean_bot_x)/2;
    center_y = (mean_top_y+mean_bot_y)/2;

    %Plot length line:
    if length_meas>0
        x_bot = center_x - cosd(orientation)*length_meas/2;
        x_top = center_x + cosd(orientation)*length_meas/2;
        y_bot = center_y + sind(orientation)*length_meas/2;
        y_top = center_y - sind(orientation)*length_meas/2;
          
        plot([x_bot, x_top],[y_bot, y_top], 'Color', 'r')
        disp_length = strcat("L = ", num2str(round(physical_length/1000,2))," μm");
        text(center_x + width/2 + 5, center_y+20, disp_length, 'Fontsize', 12, 'color', 'r')
    end
    
    %center moet iets beter bepaald worden wel -> bepaal exact center op de
    %hoogte waarop je plot, anders ziet plot er niet goed uit
    %Plot width line:
    center_x = objects.Centroid(i,1);
    center_y = objects.Centroid(i,2);
    
    x_left = center_x - sind(orientation)*width/2;
    y_left = center_y - cosd(orientation)*width/2;
    x_right = center_x + sind(orientation)*width/2;
    y_right = center_y + cosd(orientation)*width/2;
      
    plot([x_left, x_right],[y_left, y_right], 'Color', 'g')
        
    disp_diam = strcat("D = ", num2str(round(physical_width,1))," nm");
    text(center_x + width/2 + 5,center_y, disp_diam, 'Fontsize', 12, 'color', 'g')

    %NEW PART FOR TEUNS PURPOSE ONLY, DISPLAY WIRE DIRECTION TOP VIEW
%     if objects.Wire_direction(i) == 1
%         direction = ('left-top');
%     elseif objects.Wire_direction(i) == 2
%         direction = ('right-top');
%     elseif objects.Wire_direction(i) == 3
%         direction = ('left-bottom');
%     elseif objects.Wire_direction(i) == 4
%         direction = ('right-bottom');
%     end
%     text(center_x + width/2 + 5,center_y, direction, 'Fontsize', 12, 'color', 'r')

%     text(center_x + width/2 + 5,center_y-5, num2str(objects.Orientation(i)), 'Fontsize', 12, 'color', 'g')
end
hold off

end