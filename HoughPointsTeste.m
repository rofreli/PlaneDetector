function [RESULTS] = HoughPointsTeste(points, options)
    profile off

    RESULTS(1).Plane = [];
    RESULTS(2).Plane = [];
    RESULTS(3).Plane = [];
    RESULTS(2).AllTimes = [];
    RESULTS(3).AllTimes = [];

    defs = options.DEFS;


    profile on -timer 'cpu' -nohistory
    [H, P] = HoughPoints(points, defs,1);
    p = profile('info');

    RESULTS(1).Name = 'SHT';
    RESULTS(1).Time = p.FunctionTable(1).TotalTime;
    % sort by number of votes and remove all accumulators where votes == 0
    P = sortrows(P, [-1]);
    P = P(P(:, 1) > 0, :);

    figure('Name',strcat('Standard Hough Transform ',options.NomeTeste));

    % plot the origin
    plot3(0, 0, 0, 'MarkerSize', 11, 'Marker', 'o', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'k');

    % plot all the points
    scatter3(points(:,1), points(:,2), points(:,3), 'g', 'filled');


    P = sortrows(P, [-1]);
    P = P(P(:, 1) > 0, :);
    i = 1;
    if length(P)>0
        [A,B,C,D] = simplePlanePlot(P(1, 2:4), defs, 'r');
        RESULTS(1).Plane(i).ACC = P(1,1);
        RESULTS(1).Plane(i).A = A;
        RESULTS(1).Plane(i).B = B;
        RESULTS(1).Plane(i).C = C;
        RESULTS(1).Plane(i).D = D;
        RESULTS(1).Plane(i).DistM = distanciaMedia(points, [A,B,C,D]);
        RESULTS(1).DistM = RESULTS(1).Plane(i).DistM;
    end
    view(-35,50);

    figure('Name',strcat('Randomized Hough Transform ',options.NomeTeste));
    % plot the origin
    plot3(0, 0, 0, 'MarkerSize', 11, 'Marker', 'o', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'k');

    % plot all the points
    scatter3(points(:,1), points(:,2), points(:,3), 'g', 'filled');
    
    
    RESULTS(2).Name = 'RHT';
    RESULTS(2).AllTimes = [];
    RESULTS(2).Plane = [];
    RESULTS(2).DistM = 0;
    solved = 0;
    i=1;
    for i = 1:options.RHT.COUNTTEST %TESTAR O RANDOMIZADO VARIAS VEZES
        profile on -timer 'cpu' -nohistory
        [H,P] = randomhough(points, defs,options.RHT.t,options.RHT.nT,0);
        p = profile('info');
        % sort by number of votes and remove all accumulators where votes == 0
        P = sortrows(P, [-1]);
        P = P(P(:, 1) > 0, :);
        if length(P)>0
            [A,B,C,D] = simplePlanePlot(P(1, 2:4), defs, 'r');
            RESULTS(2).Plane(i).ACC = P(1,1);
            RESULTS(2).Plane(i).A = A;
            RESULTS(2).Plane(i).B = B;
            RESULTS(2).Plane(i).C = C;
            RESULTS(2).Plane(i).D = D;
            RESULTS(2).Plane(i).DistM = distanciaMedia(points, [A,B,C,D]);
            RESULTS(2).DistM = RESULTS(2).DistM + RESULTS(2).Plane(i).DistM;
            solved = solved +1;
        end
        %RHTTotal = RHTTotal + p.FunctionTable(1).TotalTime;
        RESULTS(2).AllTimes(i) = p.FunctionTable(1).TotalTime;
    end
    RESULTS(2).Time = mean(RESULTS(2).AllTimes);
    RESULTS(2).DistM = RESULTS(2).DistM / solved;
    view(-35,50);

    figure('Name',strcat('RANSAC ',options.NomeTeste));
    % plot the origin
    plot3(0, 0, 0, 'MarkerSize', 11, 'Marker', 'o', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'k');

    % plot all the points
    scatter3(points(:,1), points(:,2), points(:,3), 'g', 'filled');
        
    RESULTS(3).Name = 'RANSAC';
    RESULTS(3).AllTimes = [];
    RESULTS(3).Plane = [];
    RESULTS(3).DistM = 0;
    solved = 0;
    for i = 1:options.RANSAC.COUNTTEST %TESTAR O RANDOMIZADO VARIAS VEZES
        profile on -timer 'cpu' -nohistory
        [P,S] = ransac(points, options.RANSAC.THRESH, options.RANSAC.TOLERANCE);
        p = profile('info');
        if S == 1
            % sort by number of votes and remove all accumulators where votes == 0
            P = P(end,:);
            if length(P)>0
                %for ip=1:min(length(P),10)
                    [A,B,C,D] = simplePlanePlot(P, defs, 'r');
                    RESULTS(3).Plane(i).ACC = 0;
                    RESULTS(3).Plane(i).A = A;
                    RESULTS(3).Plane(i).B = B;
                    RESULTS(3).Plane(i).C = C;
                    RESULTS(3).Plane(i).D = D;
                    [DistM, DistP] = distanciaMedia(points, [A,B,C,D]);
                    RESULTS(3).Plane(i).DistM = DistM;
                    RESULTS(3).DistM = RESULTS(3).DistM + RESULTS(3).Plane(i).DistM;
                    solved = solved + 1;
                %end
            end
        end
        %RHTTotal = RHTTotal + p.FunctionTable(1).TotalTime;
        RESULTS(3).AllTimes(i) = p.FunctionTable(1).TotalTime;
    end
    RESULTS(3).DistM = RESULTS(3).DistM / solved;
    RESULTS(3).Time = mean(RESULTS(3).AllTimes);
    view(-35,50);
    profile off
end