function objects = app_excludeobjectsatedges(objects, resolution)

number_objects_to_calc = length(objects.Area);
loop=1;
for i = 1:number_objects_to_calc
    %Outline is in (y,x)
    outline = objects.OutlineImageSpace{i};
    min_x = min(outline(:,2));
    max_x = max(outline(:,2));
    top_y = min(outline(:,1));
    bot_y = max(outline(:,1));

    if min_x>1 && max_x<resolution(2) && top_y>1 && bot_y<resolution(1)-2
        %You're completely inside the figure
    else
        delete_me(loop) = i;
        loop = loop+1;
    end
end
if loop>1
    objects(delete_me,:) = [];
end

end