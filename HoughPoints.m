%https://github.com/palmerc/Hough/blob/master/HoughPoints.m
function [ Hough, parameterMatrix, theta_range, rho_range, phi_range ] = HoughPoints(points, defs, show)
%HOUGHCLP performs the Hough transform in a straightforward way.
%   
    x_min = defs(1,1); y_min = defs(1,2); z_min = defs(1,3);
    x_max = defs(2,1); y_max = defs(2,2); z_max = defs(2,3);
    
    [Hough, theta_maximum, theta_range, rho_maximum, rho_range, phi_maximum, phi_range, parameterMatrix] = HoughMatrix(x_max, y_max, z_max, x_min, y_min, z_min);
    
    for point_index = 1:size(points, 1)
        point = points(point_index,:);
        px = point(1);
        py = point(2);
        pz = point(3);

        %x = col - 1;
        %y = row - 1;
        for theta_index = 1:length(theta_range)
             theta = theta_range(theta_index);
             for phi_index = 1:length(theta_range)
                phi = phi_range(phi_index);
                %rho = round((px * cosd(theta)) + (py * sind(theta)));   
                rho = round(px*cos(theta)*sin(phi) + py*sin(phi)*sin(theta) + pz*cos(phi));
                rho_index = rho + rho_maximum + 1;
                %theta_index = theta + theta_maximum + 1;
                %phi_index = phi + phi_maximum + 1;
                Hough(theta_index, phi_index, rho_index) = Hough(theta_index, phi_index, rho_index) + 1;
                
                x = rho .* sin(phi) .* cos(theta);
                y = rho .* sin(phi) .* sin(theta);
                z = rho .* cos(phi);
                if x>0 && y>0  && z>0
                    parameterMatrix(theta_index*phi_index*rho_index, :) = [Hough(theta_index, phi_index, rho_index) x y z];
                end
            end
        end
    end
    
    
end

