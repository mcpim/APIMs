function app_plotcube(objects, tilt_angle, SEM_Image,cmap, ColorList)
%This functions plots the cube on top of the object
imshow(SEM_Image)
hold on

for which_obj = 1:length(objects.Area)
    if objects.CubeFit(which_obj) == 1

        width = objects.xopt{which_obj}(1);
        height = objects.xopt{which_obj}(2);
        phi = objects.xopt{which_obj}(3);
        theta = tilt_angle;
        slant_angle = objects.xopt{which_obj}(4);
        x_shift = objects.xopt{which_obj}(5);
        y_shift = objects.xopt{which_obj}(6);

        [x,y] = app_cubeprojection(width, height, phi, theta, slant_angle, x_shift, y_shift);

        %Calculate extra point and set everything to fit in image space
        %Outline per object in total image space
        x_shift = objects.BoundingBox(which_obj,1)+0.5 + objects.BoundingBox(which_obj,3) + x_shift;
        y_shift = objects.BoundingBox(which_obj,2)-0.5 +y_shift;
        
        x = -x + x_shift;
        y = y + y_shift;
        
        %Setting extra points so it looks like a cube
        extra_point1_x = x(1)+x(5)-x(6);
        extra_point1_y = y(1)+y(5)-y(6);

        extra_line1_x = [x(1), extra_point1_x];
        extra_line1_y = [y(1), extra_point1_y];

        extra_line2_x = [x(3), extra_point1_x];
        extra_line2_y = [y(3), extra_point1_y];

        extra_line3_x = [x(5), extra_point1_x];
        extra_line3_y = [y(5), extra_point1_y];

        extra_point2_x = x(2)+x(6)-x(7);
        extra_point2_y = y(2)+y(6)-y(7);

        extra_line4_x = [x(4), extra_point2_x];
        extra_line4_y = [y(4), extra_point2_y];

        extra_line5_x = [x(2), extra_point2_x];
        extra_line5_y = [y(2), extra_point2_y];

        extra_line6_x = [x(6), extra_point2_x];
        extra_line6_y = [y(6), extra_point2_y];
        
        %Plotting the data
        cube = line(x,y, 'Color', cmap(ColorList(which_obj,1), :),  'LineWidth',1);
        usecolor = get(cube, 'Color');
        line(extra_line1_x, extra_line1_y, 'LineStyle',':', 'Color', [usecolor 0.5], 'LineWidth',1)
        line(extra_line2_x, extra_line2_y, 'LineStyle',':', 'Color', [usecolor 0.5],'LineWidth',1)
        line(extra_line3_x, extra_line3_y, 'LineStyle',':', 'Color', [usecolor 0.5],'LineWidth',1)
        line(extra_line4_x, extra_line4_y, 'Color', usecolor,'LineWidth',1)
        line(extra_line5_x, extra_line5_y, 'Color', usecolor,'LineWidth',1)
        line(extra_line6_x, extra_line6_y, 'Color', usecolor,'LineWidth',1)
        
        %Displaying length and width
        %Length
        %disp_length = strcat("L = ", num2str(round(objects.PhysicalLength(which_obj))),"±", num2str(round(objects.PhysicalLength_Uncertainty(which_obj))) ," nm");
        %text(max(x) + 5, min(y) + 10, disp_length, 'Fontsize', 14, 'Color', 'r')
        %Width
        %disp_width = strcat("W = ", num2str(round(objects.PhysicalWidth(which_obj))), "±", num2str(round(objects.PhysicalWidth_Uncertainty(which_obj))) ," nm");
        %text(max(x) + 5, min(y) + 30, disp_width, 'Fontsize', 14, 'Color', 'r')
        disp_number = num2str(which_obj);
        text(max(x) + 5, min(y) + 10, disp_number, 'Fontsize', 14, 'Color', usecolor)
    end
end
hold off
end