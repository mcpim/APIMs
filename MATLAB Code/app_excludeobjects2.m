function objects = app_excludeobjects2(SEM_Image, objects, select_or_delete)
%select_or_delete = 0 to exclude objects.
%select_or_delete = 1 to select objects to measure.
%imshow(SEM_Image)
hold on
% if select_or_delete == 0
%     visboundaries(objects.OutlineImageSpace)
%     %title('Please click on found objects that you do NOT want to include in this analysis and press "Enter".')
% else
%     visboundaries(objects.OutlineImageSpace, 'Color', 'b')
%     %title('Please click on found objects that you DO want to include in this analysis and press "Enter".')
% end
hold off

disp('All found objects are outlined in red.')
disp('Please click on found objects that you do NOT want to include in this analysis and press "Enter".')
[neglect_x, neglect_y] = getpts;
neglect_x = round(neglect_x);
neglect_y = round(neglect_y);
clc

number_objects_to_calc = length(objects.Area);
%list_of_objects_to_delete = zeros(1,length(neglect_x));
if isempty(neglect_x)
else
    selected_objects = 0;
    for i = 1:number_objects_to_calc
        pixels_object = objects.PixelList{i};
        
        for k = 1:length(neglect_x)
            
            for h = 1:length(pixels_object)
                %If the following condition is met, a clicked pixel is
                %inside of the object and the object will be put on the
                %list of objects to delete from data.
                if neglect_x(k) == pixels_object(h,1) && neglect_y(k) == pixels_object(h,2)
                    selected_objects = selected_objects+1;
                    list_of_selected_objects(selected_objects) = i;
                    
                end
            
            end
        end
    end
    if exist('list_of_selected_objects','var')
        if select_or_delete == 0
            objects(list_of_selected_objects,:) = [];
        else
            list_of_selected_objects = unique(list_of_selected_objects);
            objects = objects(list_of_selected_objects,:);
        end

    end
end

end
