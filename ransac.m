function [plane_list, solved] = ransac(points, thresh, t)
    n = 3;
    count = length(points);
    %PS = (1-w);
    
    %fastpow (base=2, exp=4)
    %
    P = 0.99;
    w = 0.5;
    k= round(log(1-P)/log(1-w^n));
    
    TOLERANCE = t;
    N_ITERATIONS = k;
    iterations = 0;
    solved = 0;
    plane_list = [];
    best_ratio = 0;
    solvedIt = 1;
    while iterations < N_ITERATIONS
        CP = [0 0 0];
        while CP(1) == 0 && CP(2) == 0 && CP(3) == 0
            ix = randsample(1:count,3);
            p = points(ix,:);
            A = p(1,:);B = p(2,:);C = p(3,:);
            %make sure they are non-collinear
            CP = cross(A-B, B-C);
        end
        
        ar = [A;B;C];
        invABC = inv(ar);
        o = ones(3,1);
        abc = invABC*o;
        d = sqrt(abc(1)*abc(1)+abc(2)*abc(2)+abc(3)*abc(3));
        
        dist = abs(((points* abc) - 1)/d);
        ind = find(dist < TOLERANCE);
        ratio = length(ind);
        if ratio > thresh
            inliers = points(ind,:);
            XYZ = pinv(inliers)*ones(length(inliers), 1);
            if ratio > thresh && ratio > best_ratio
                best_ratio = ratio;
                plane_list = [plane_list; XYZ(1) XYZ(2) XYZ(3)];
                solvedIt = solvedIt + 1;
            end
            solved = 1;
        end
        iterations = iterations+ 1;
    end
end