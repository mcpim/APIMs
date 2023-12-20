function [objects] = app_findobjects(new_SEM_data)

%Obtaining all object information
objects = regionprops('table',imfill(new_SEM_data>0, 'holes'),'Area','Centroid','PixelList','MajorAxisLength','MinorAxisLength','Orientation','Image', 'BoundingBox','FilledImage', 'Extrema');

end