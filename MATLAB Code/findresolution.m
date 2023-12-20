function [SEM_data, resolution] = findresolution(SEM_Image)

if size(SEM_Image) == [384 512]
    SEM_data = SEM_Image(1:348, :);
end

if size(SEM_Image) == [768 1024]
    SEM_data = SEM_Image(1:697, :);
end

if size(SEM_Image) == [1536 2048]
    SEM_data = SEM_Image(1:1395, :);
end

if size(SEM_Image) == [2304 3072]
    SEM_data = SEM_Image(1:2090, :);
end

if exist('SEM_data')
    resolution = size(SEM_data);
end

end