function point_data = app_cubefunc(p, theta, s)
%p = parameters vector
%(width, height, phi, theta, x_shift, y_shift, s0) = parameters_vector
%Input s is a vector
[x_list, y_list] = app_cubeprojection(p(1), p(2), p(3), theta, p(4), p(5), p(6));
%returns [x_list, y_list]

%Makes sure s is a always a value between 0 and 1 where the starting point
%can be shifted by s0.
s0 = p(7);
s = mod(s+s0, 1);

%Calculates the total length of all the lines
line_lengths = zeros(1, length(x_list)-1);
for i = 1:length(x_list)-1
    dx = x_list(i+1) - x_list(i);
    dy = y_list(i+1) - y_list(i);
    segment_length = sqrt(dx^2 + dy^2);
    line_lengths(i) = segment_length;
end
total_length = sum(line_lengths);

%Sets the total coordinates to s-space
position_in_s_space = zeros(1,length(x_list));
position_in_s_space(1) = 0;
for i = 2:length(x_list)
    position_in_s_space(i) = position_in_s_space(i-1) + line_lengths(i-1)/total_length;
end

%Calculates the corresponding coordinates to every s-point.
x_data = zeros(1, length(s));
y_data = zeros(1, length(s));
for i = 1:length(s)
    %The position of s will be in between these two values
    start = find(position_in_s_space <= s(i), 1, 'last');
    stop = find(position_in_s_space > s(i), 1, 'first');
    %Solve the case where s(i)=1.000 exactly:
    if isempty(stop)
        stop = 7;
        start = 6;
    end
    
    %corresponding line segment is then line_lengths(start)
    in_line_space = (s(i) - position_in_s_space(start))/(line_lengths(start)/total_length);

    x_data(i) = (x_list(stop)-x_list(start))*in_line_space + x_list(start);
    y_data(i) = (y_list(stop)-y_list(start))*in_line_space + y_list(start);
end

point_data(1,:) = x_data;
point_data(2,:) = y_data;

end