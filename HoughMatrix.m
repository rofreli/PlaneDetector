function [Hough, theta_maximum, theta_range, rho_maximum, rho_range, phi_maximum, phi_range, parameterMatrix] = HoughMatrix(x_max, y_max, z_max, x_min, y_min, z_min)
%HOUGHMATRIX Creates a matrix suitable for the Hough Transform

theta_maximum = pi/2;
phi_maximum = pi/2;
step = 0.1;
rho_maximum = max(floor(sqrt(x_min.^2 + y_min.^2 + z_min.^2)) - 1, floor(sqrt(x_max.^2 + y_max.^2 + z_max.^2)) - 1);
theta_range = -theta_maximum:step:theta_maximum;
phi_range = -phi_maximum:step:phi_maximum;
rho_range = -rho_maximum:rho_maximum+1;

Hough = zeros(length(theta_range), length(phi_range),  length(rho_range));
parameterMatrix = zeros( length(theta_range) * length(phi_range) * length(rho_range), 4);

end