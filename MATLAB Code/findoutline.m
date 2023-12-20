function [Outline, OutlineImageSpace] = findoutline(objects)

number_objects_found = length(objects.Area);
%Obtaining the information about the outline of the found objects
%Objects.Outline has information about the coordinates of the outline per
%object in the form of (y,x)
for i = 1:number_objects_found
    %Outline per object in single object space
    outline_object_space = bwboundaries(objects.FilledImage{i});
    outline{1}(:,1) = outline_object_space{1}(:,1);
    outline{1}(:,2) = outline_object_space{1}(:,2);
    Outline(i,1) = outline;

    %Outline per object in total image space
    x_shift = objects.BoundingBox(i,1)-0.5;
    y_shift = objects.BoundingBox(i,2)-0.5;
    
    %Outline is in (y,x)
    outline{1}(:,1) = outline{1}(:,1) + y_shift;
    outline{1}(:,2) = outline{1}(:,2) + x_shift;
    OutlineImageSpace(i,1) = outline;

    clear outline
end

end