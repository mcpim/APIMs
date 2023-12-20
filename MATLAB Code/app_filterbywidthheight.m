function objects = app_filterbywidthheight(objects, factor)
loop = 1;
for i = 1:length(objects.Area)
    lengths = objects.PhysicalLength(i);
    widths = objects.PhysicalWidth(i);
    if lengths <= factor*widths || widths >= factor*lengths || lengths*widths == 0
        delete_me(loop) = i;
        loop = loop+1;
    end
end
if exist('delete_me','var')
    objects(delete_me,:) = [];
end
end