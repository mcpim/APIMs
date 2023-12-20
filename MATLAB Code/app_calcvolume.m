function objects = app_calcvolume(objects)
%Volume in pixels
objects.Volume = pi*objects.Length.*(objects.Width./2).^2;
min_volume = pi*(objects.Length - objects.Std_Length).*((objects.Width - objects.Std_Width)./2).^2;
max_volume = pi*(objects.Length + objects.Std_Length).*((objects.Width + objects.Std_Width)./2).^2;
std_volume = (max_volume - objects.Volume + objects.Volume - min_volume)/2;
objects.Std_Volume = std_volume;

objects.PhysicalVolume = pi*objects.PhysicalLength.*(objects.PhysicalWidth./2).^2;
min_physical_volume = pi*(objects.PhysicalLength - objects.Std_PhysicalLength).*((objects.PhysicalWidth - objects.Std_PhysicalWidth)./2).^2;
max_physical_volume = pi*(objects.PhysicalLength + objects.Std_PhysicalLength).*((objects.PhysicalWidth + objects.Std_PhysicalWidth)./2).^2;
std_physical_volume = (max_physical_volume - objects.PhysicalVolume + objects.PhysicalVolume - min_physical_volume)/2;
objects.Std_PhysicalVolume = std_physical_volume;

end