function [line1, line2, line3, line4, line5] = app_command_text_to_textbox(objects, name)

number_objects_to_calc = length(objects.Area);
%Display all of the measured data
format bank %shows 2 decimals
line1 = strcat("File loaded: ", name);
line2 = strcat("Number of analysed objects: ",num2str(number_objects_to_calc));
line3 = strcat("Number of analysed objects completely inside the image: ", num2str(length(nonzeros(objects.Length))));

mean_width = round(mean(objects.PhysicalWidth),2);
spread_width = round(std(objects.PhysicalWidth),2);
mean_length = round(mean(nonzeros(objects.PhysicalLength)),2);
spread_length = round(std(nonzeros(objects.PhysicalLength)),2);

line4 = strcat("Mean width of analysed objects is: ", num2str(mean_width)," ",char(177)," ",num2str(spread_width)," nm.");
if sum(objects.Length) == 0
    line5 = '';
else
    line5 = strcat("Mean length of analysed objects completely inside the image: ", num2str(round(mean_length/1000,2))," ",char(177)," ",num2str(round(spread_length/1000,2))," μm.");
end
format default %sets the format back to standard
end