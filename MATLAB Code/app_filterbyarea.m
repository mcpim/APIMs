function objects = app_filterbyarea(objects, upperlimit, lowerlimit)
%Filter by area
av_area = mean(objects.Area);
more_than_av = objects.Area > av_area*upperlimit;
which_ones = find(more_than_av == 1);
objects_new = objects;
objects_new(which_ones,:) = [];

less_than_av = objects_new.Area < av_area*lowerlimit;
which_ones = find(less_than_av == 1);
objects_new(which_ones,:) = [];

objects = objects_new;
end
