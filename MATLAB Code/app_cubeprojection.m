function [x_list, y_list] = app_cubeprojection(width, height, phi, theta, slant_angle, x_shift, y_shift)

%Quickly set degrees to radians
phi = mod(phi,90);
phi = phi*pi/180;
theta = theta*pi/180;
slant_angle = -slant_angle*pi/180;

%Calculate the projection of the structure in xy space
y_acc = height*sin(theta);
dx1 = width*cos(phi);
dx2 = width*sin(phi);
dy1 = width*sin(phi)*cos(theta);
dy2 = width*cos(phi)*cos(theta);
dy3 = width*(cos(phi)-sin(phi))*cos(theta);

point_1 = [0,0];
point_2 = [dx1, -dy1];
point_3 = [dx1 + dx2, dy3];
point_4 = [dx1 + dx2, y_acc + dy3];
point_5 = [dx2, y_acc + dy2];
point_6 = [0, y_acc];

%Setting the outer cornerpoints of the cubic structure in a list
%Choosing point_2 as the start of the list (for convenience later on as
%this will always be the lowest point).
x_list = [point_2(1), point_3(1), point_4(1), point_5(1), point_6(1), point_1(1), point_2(1)];
y_list = [point_2(2), point_3(2), point_4(2), point_5(2), point_6(2), point_1(2), point_2(2)];

%Introduce slanting of the coordinate system
x_acc_list = x_list*cos(slant_angle) + y_list*sin(slant_angle);
y_acc_list = -x_list*sin(slant_angle) + y_list*cos(slant_angle);

%Position the coordinates nicely to match our dataset
x_list = x_acc_list + abs(min(x_acc_list)) + 1 + x_shift;
y_list = y_acc_list + abs(min(y_acc_list)) + 1 + y_shift;


%figure
%plot(x_list,y_list)
%title(strcat("Width = ",num2str(width),", Height = ", num2str(height),", θ = ", num2str(theta*180/pi),"°,  φ = ", num2str(phi*180/pi),"°, Slant angle = ", num2str(-slant_angle*180/pi),"°"))
end