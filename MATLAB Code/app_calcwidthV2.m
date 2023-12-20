function objects = app_calcwidthV2(objects,length_per_pixel, top, bottom)

number_objects_to_calc = length(objects.Area);
objects.Width = zeros(number_objects_to_calc,1);
objects.Std_Width = objects.Width;
objects.PhysicalWidth = objects.Width;
objects.Std_PhysicalWidth = objects.Width;

%In the case that we're looking at top-view and the object points down,
%the range has to be defined differently, for this we use q_topview_present
Exist_Column = strcmp('TopViewOrientation',objects.Properties.VariableNames);
q_topview_present = Exist_Column(Exist_Column==1);

for i = 1:number_objects_to_calc
    clear outline new_outline
    %i = 1516;
    %visboundaries(objects.OutlineImageSpace(i),'Color','g')
    %visboundaries(objects.Outline(i),'Color','g')
    outline = objects.Outline{i};
    %objects.Orientation(i)
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

    %visboundaries({outline},'Color', 'b')

    top_y = min(outline(:,1));
    bot_y = max(outline(:,1));
    diff_top_bot = bot_y - top_y;


    %Rotate the outline around. The outline moves clockwise!
    %Make the lowest y-point, the start of the list
    outline(end,:) = [];
    outline = circshift(outline, length(outline) - find(outline(:,1) == bot_y,1,'first')+1);
    outline(end+1,:) = outline(1,:);

    top_y_right = find(outline(:,1) == top_y, 1,'last');
    right_part_outline = outline(top_y_right:end,:);
    left_part_outline = outline(1:top_y_right, :);
    %visboundaries({right_part_outline}, 'Color', 'g')
    %visboundaries({left_part_outline}, 'Color', 'b')

    %Determine the width of the object based on the top 15-30% of the length
    %of the object.
    range_start = top_y + diff_top_bot*(1-top);
    range_stop = top_y + diff_top_bot*(1-bottom);
    %range_start = round(range_start);
    %range_stop = round(range_stop);
    
    %In the case that we're looking at top-view and the object points down,
    %the range is defined in a different manner.
    if q_topview_present
        if objects.TopViewOrientation(i) > 180
        range_start = top_y + diff_top_bot*(bottom);
        range_stop = top_y + diff_top_bot*(top);
        end
    end

    %See which outline part is longer, choose this for calculating
    if length(left_part_outline(:,1)) >= length(right_part_outline(:,2))
        %Determine number of points to do calculation on, which depends on
        %the amount of points would be considered in the range
        in_range = left_part_outline(:,1)>= range_start & left_part_outline(:,1)<=range_stop;
        numb_points_to_calc = sum(in_range);
    else
        in_range = right_part_outline(:,1)>= range_start & right_part_outline(:,1)<=range_stop;
        numb_points_to_calc = sum(in_range);
    end
    
    %make sure there is always atleast one point
    if numb_points_to_calc == 0 
        numb_points_to_calc = 1;
    end
    %Choice: within the provided range, interpolate that many points
    %evenly over the length, where the amount of points is determined
    %by the amount that would be in the original range, but the points
    %themselves are interpolated from the original data.
    step_size = ((range_stop - range_start)/(numb_points_to_calc-1));
    if isnan(step_size) %then ONLY 1 value
        y_coords = range_stop;
    else
        y_coords = range_start:step_size:range_stop;
    end
    %y_coords is the coordinates we will check against interpolated
    %original data
    width = zeros(length(y_coords),1);
    for j = 1:length(y_coords)
        y = y_coords(j);
        %interpolate left coordinate
        between1_left = find(left_part_outline(:,1)>= y, 1, 'last');
        between2_left = find(left_part_outline(:,1)<= y, 1, 'first');
        yl_1 = left_part_outline(between1_left,1);
        yl_2 = left_part_outline(between2_left,1);
        if yl_1 == yl_2
            x_left = left_part_outline(between1_left,2);
        else
            diff_y = abs(yl_1-yl_2);
            diff_y_to_max = max([yl_1,yl_2])-y;
            xl_1 = left_part_outline(between1_left,2);
            xl_2 = left_part_outline(between2_left,2);
            diff_x = abs(xl_1-xl_2);
            x_left = max([xl_1,xl_2]) - (diff_y_to_max/diff_y)*diff_x;
        end

        %interpolate right coordinate
        between1_right = find(right_part_outline(:,1)>= y, 1, 'first');
        between2_right = find(right_part_outline(:,1)<= y, 1, 'last');
        yr_1 = right_part_outline(between1_right,1);
        yr_2 = right_part_outline(between2_right,1);
        if yr_1 == yr_2
            x_right = right_part_outline(between1_right,2);
        else
            diff_y = abs(yr_1-yr_2);
            diff_y_to_max = max([yr_1,yr_2])-y;
            xr_1 = right_part_outline(between1_right,2);
            xr_2 = right_part_outline(between2_right,2);
            diff_x = abs(xr_1-xr_2);
            x_right = max([xr_1,xr_2]) - (diff_y_to_max/diff_y)*diff_x;
        end
        %width is then the difference between the left and right
        %coordinate
        width(j) = x_right-x_left;
        if isnan(width(j))
            width(j) = 0;
        end
    end
    %Remove occurences where top or bottom is included, gives width of 0:
    if sum(width)==0 %VERY UNIQUE CASE, -> when outline is on the same pixel twice, AND you're looking at 1 specific height only.
        width = 0;
    else
        width = nonzeros(width);
    end
    
    objects.Width(i,1) = mean(width);
    objects.Std_Width(i,1) = std(width);
    objects.PhysicalWidth(i,1) = objects.Width(i,1)*length_per_pixel;
    objects.Std_PhysicalWidth(i,1) = objects.Std_Width(i,1)*length_per_pixel;
%     if isnan(Width(i,1))
%         dbstop in calcwidthV2 at 134
%     end
end

end