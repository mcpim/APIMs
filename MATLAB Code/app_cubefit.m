function objects = app_cubefit(objects,length_per_pixel, tilt_angle)

for which_obj = 1:length(objects.Area)
    clear x_data y_data
    %% Collecting data
    %Outlinedata is written as (y,x)
    Outlinedata = objects.Outline{which_obj};
    %Because of the way data is structured, we want to mirror in the x-axis
    %(in imagespace top is (1,1) bottom is (1000, 1) meaning going down is
    %positive)
    Outlinedata(:,1) = -Outlinedata(:,1) + max(Outlinedata(:,1)) + 1;


    %% Start conversion of everything to s-space such that it can be fit

    %Ordering the outline data such that s starts at the bottom
    first = find(Outlinedata(:,1) == min(Outlinedata(:,1)), 1, 'first');
    last = find(Outlinedata(:,1) == min(Outlinedata(:,1)), 1, 'last');
    center_bot_x_coord = (max([Outlinedata(first,2),Outlinedata(last,2)]) + min([Outlinedata(first,2),Outlinedata(last,2)]))/2;
    index_of_most_bot_point = find(abs(Outlinedata(:,2).*(Outlinedata(:,1)==min(Outlinedata(:,1)))-center_bot_x_coord) == min(abs(Outlinedata(:,2).*(Outlinedata(:,1)==min(Outlinedata(:,1)))-center_bot_x_coord)),1,'last');

    new_Outlinedata = zeros(length(Outlinedata(:,1)),2);
    for i = 1:length(Outlinedata(:,1))-index_of_most_bot_point
        new_Outlinedata(i,1) = Outlinedata(i+index_of_most_bot_point-1, 1);
        new_Outlinedata(i,2) = Outlinedata(i+index_of_most_bot_point-1, 2);
    end
    for i = 1:index_of_most_bot_point-1
        new_Outlinedata(i+length(Outlinedata(:,1))-index_of_most_bot_point, 1) = Outlinedata(i,1);
        new_Outlinedata(i+length(Outlinedata(:,1))-index_of_most_bot_point, 2) = Outlinedata(i,2);
    end
    new_Outlinedata(end,:) = new_Outlinedata(1,:);

    %flipping because order is reverse w.r.t. function #oops
    new_Outlinedata = flip(new_Outlinedata);
    %Splitting outline data into x and y
    Outlinedata_x = new_Outlinedata(:,2);
    Outlinedata_y = new_Outlinedata(:,1);

    %Calculates the total length of all the lines
    line_lengths = zeros(1, length(Outlinedata_x)-1);
    for i = 1:length(Outlinedata_x)-1
        dx = Outlinedata_x(i+1) - Outlinedata_x(i);
        dy = Outlinedata_y(i+1) - Outlinedata_y(i);
        segment_length = sqrt(dx^2 + dy^2);
        line_lengths(i) = segment_length;
    end
    total_length = sum(line_lengths);

    %Sets the total coordinates to s-space
    position_in_s_space = zeros(1,length(Outlinedata_x));
    position_in_s_space(1) = 0;
    for i = 2:length(Outlinedata_x)
        position_in_s_space(i) = position_in_s_space(i-1) + line_lengths(i-1)/total_length;
    end

    %% Attempting to fit
    %Setting parameters to easily understand
    s = position_in_s_space;
    x_data = s;
    y_data(1,:) = Outlinedata_x;
    y_data(2,:) = Outlinedata_y;

    % Initial guess:
    width_guess = objects.Width(which_obj);
    height_guess = objects.Length(which_obj);
    phi_guess = 80;
    %theta_guess = tilt_angle;
    slant_guess = 0;
    x_shift_guess = 0;
    y_shift_guess = 0;
    s0_guess = 0;
    x0 = [width_guess, height_guess, phi_guess, slant_guess, x_shift_guess, y_shift_guess, s0_guess];

    %Actual fitting
    lower_bound = [0,0,0,-90,0,0,-Inf];
    upper_bound = [Inf, Inf, 90, 90, Inf, Inf, Inf];
    fun = @(x,xdata)app_cubefunc(x,tilt_angle,xdata);
    options = optimoptions(@lsqcurvefit,'Algorithm','levenberg-marquardt','MaxFunctionEvaluations',5000, 'Display', 'off');
    %xopt = lsqcurvefit(fun, x0, x_data, y_data, lower_bound, upper_bound, options);
    
    %To calculate confidence use:
    [xopt,~,residual,~,~,~,jacobian] = lsqcurvefit(fun, x0, x_data, y_data, lower_bound, upper_bound, options);
    conf = nlparci(xopt,residual,'jacobian',jacobian);

    %% Writing found parameters to objects data
    objects.CubeFit(which_obj) = 1;
    
    %Width
    objects.Width(which_obj) = xopt(1);
    objects.PhysicalWidth(which_obj) = xopt(1)*length_per_pixel;
    %Width uncertainty
    objects.Width_Uncertainty(which_obj) = xopt(1) - conf(1,1);
    objects.PhysicalWidth_Uncertainty(which_obj) = (xopt(1) - conf(1,1))*length_per_pixel;

    %Length
    objects.Length(which_obj) = xopt(2);
    objects.PhysicalLength(which_obj) = xopt(2)*length_per_pixel;
    %Length uncertainty
    objects.Length_Uncertainty(which_obj) = xopt(2) - conf(2,1);
    objects.PhysicalLength_Uncertainty(which_obj) = (xopt(2) - conf(2,1))*length_per_pixel;

    %Volume
    objects.Volume(which_obj) = xopt(1)*xopt(1)*xopt(2);
    objects.PhysicalVolume(which_obj) = xopt(1)*xopt(1)*xopt(2)*length_per_pixel^3;
    %Volume uncertainty
    objects.Volume_Uncertainty(which_obj) = objects.Width_Uncertainty(which_obj)*objects.Width_Uncertainty(which_obj)*objects.PhysicalLength_Uncertainty(which_obj);
    objects.PhysicalVolume_Uncertainty(which_obj) = objects.Volume_Uncertainty(which_obj)*length_per_pixel^3;
    
    %Phi
    objects.Phi(which_obj) = xopt(3);
    objects.Phi_Uncertainty(which_obj) = xopt(3) - conf(3,1);

    %Slant
    objects.Slant(which_obj) = xopt(4);
    objects.Slant_Uncertainty(which_obj) = xopt(4) - conf(4,1);
    
    %xshift, yshift
    objects.Xshift(which_obj) = xopt(5);
    objects.Xshift_Uncertainty(which_obj) = xopt(5) - conf(5,1);
    objects.Yshift(which_obj) = xopt(6);
    objects.Yshift_Uncertainty(which_obj) = xopt(6) - conf(6,1);
    
    %xopt
    objects.xopt{which_obj} = xopt;
    objects.xopt_uncertainty{which_obj} = xopt - conf(:,1);
end

end