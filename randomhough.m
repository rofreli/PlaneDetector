function [Hough, parameterMatrix]= RHT(pontos, defs, t, nT, show)  
    
    x_min = defs(1,1); y_min = defs(1,2); z_min = defs(1,3);
    x_max = defs(2,1); y_max = defs(2,2); z_max = defs(2,3);
    
    [Hough, theta_maximum, theta_range, rho_maximum, rho_range, phi_maximum, phi_range, parameterMatrix] = HoughMatrix(x_max, y_max, z_max, x_min, y_min, z_min);
    
    it = 0;
    threshold = t;
    best_plane = [];
    neighborhoodTresh = nT;
    
    %pontosx = pontos(1,:);
    %pontosy = pontos(2,:);
    %pontosz = pontos(3,:);
    count = length(pontos);
    
    H_bookkeeping = Hough;
    while it < nT%length(pontos) > 3
        ix = randsample(1:count,3);%get index
        if length(pontos) < 3
            break;
        end

        p = pontos(ix,:);
        pontos(ix,:) = [];
        count=count-3;
     
        p1 = p(1,:);
        p2 = p(2,:);
        p3 = p(3,:);
        %dist = dot(cross((p3 - p2) , (p1 - p2)), p1);
        %if abs(dist)>=0.5
        %    continue;
        %end
        
        H = HoughPoints(p, defs, 0);
        H_bookkeeping = H_bookkeeping + H;
        
        %count
        %maximo = max(max(max(H_bookkeeping)))
        idx = find(H_bookkeeping > threshold);
        [candidate_th, candidate_ph, candidate_rh] = ind2sub(size(H_bookkeeping > threshold), idx);
        for i = 1:size(candidate_th, 1)
            theta_index = candidate_th(i);
            for j = 1:size(candidate_ph, 1)
                phi_index = candidate_ph(j);
                for k = 1:size(candidate_rh, 1)
                    rho_index = candidate_rh(k);
                    
                    rho = rho_range(rho_index);
                    theta = theta_range(theta_index);
                    phi = phi_range(phi_index);
                    
                    x = rho .* sin(phi) .* cos(theta);
                    y = rho .* sin(phi) .* sin(theta);
                    z = rho .* cos(phi);
                
                    Hough(theta_index, phi_index, rho_index) = H_bookkeeping(theta_index, phi_index, rho_index);
                    if x>0 && y>0  && z>0
                        parameterMatrix(theta_index*phi_index*rho_index, :) = [ H_bookkeeping(theta_index, phi_index, rho_index) x y z];
                    end
                    H_bookkeeping(theta_index, phi_index, rho_index) = 0;
                    
                    %euclidianD = sqrt((pontos(:,1)-x).^2+...
                    %                     (pontos(:,2)-y).^2+...
                    %                     (pontos(:,3)-z).^2);
            
                    %idxE = find(euclidianD < neighborhoodTresh);
                    %pontos(idxE,:) = [];
                    %count = length(pontos);
                end
            end
        end   

        it = it + 1; % Step 9
        
    end
   
end