function [distM, distP] = distanciaMedia(points, plane)

    X = points(:,1);
    Y = points(:,2);
    Z = points(:,3);

    A = plane(1);
    B = plane(2);
    C = plane(3);
    D = plane(4);
    
    distP =  (abs(X.*A+B.*Y+C.*Z+D)/sqrt(A^2+B^2+C^2));
    distM = mean(distP); 
end