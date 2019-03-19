profile off
N = 1001;    % number of points per plane
a = 50;    % min value of co-ordinate
b = -50;   % max value of co-ordinate
c = 5;     % value of the constant co-ordinate

s = RandStream('mcg16807', 'Seed', 0);
RandStream.setGlobalStream(s)
points = [];

options.RHT.t = 70;
options.RHT.nT = 150;
options.RHT.COUNTTEST = 10;

options.RANSAC.TOLERANCE = 10;
options.RANSAC.THRESH = 0.3;
options.RANSAC.COUNTTEST = 10;
x = a + (b-a).*rand(N,1);
y = a + (b-a).*rand(N,1);
z = -(2*x + 2*y)/2 + 1;
%simplePlanePlot([x y z], 'r');
points = [points; [x y z]];

x = points(:,1);
y = points(:,2);
z = points(:,3);

x_min = min(x); y_min = min(y); z_min = min(z);
x_max = max(x); y_max = max(y); z_max = max(z);

defs = [x_min y_min z_min;x_max y_max z_max];

options.DEFS = defs;
options.NomeTeste = 'Sem Ruído';
RESULT1 = HoughPointsTeste(points, options);
% add random noise
points = points + randn(size(points));

x = points(:,1);
y = points(:,2);
z = points(:,3);

x_min = min(x); y_min = min(y); z_min = min(z);
x_max = max(x); y_max = max(y); z_max = max(z);

defs = [x_min y_min z_min;x_max y_max z_max];

options.DEFS = defs;
options.NomeTeste = 'Com Ruído';
RESULT2 = HoughPointsTeste(points, options);

% formatSpec = '%f %f %f';
% sizeA = [3 Inf];
% fileID = fopen('C:\\Users\\rodri\\Source\\Repos\\DepthSensor\\DepthSensor\\points.txt','r');
% A = fscanf(fileID,formatSpec, sizeA);
% points = A';
% points = points(find(points(:,1) > 0),:);
% %vMax = max(A);
% 
% idx = randperm(length(points),5000);
% pointsR = points(idx,:);
% 
% %idx = randperm(length(points),100000);
% %points = points(idx,:);
% 
% 
% 
% x = points(:,1);
% y = points(:,2);
% z = points(:,3);
% 
% x_min = min(x); y_min = min(y); z_min = min(z);
% x_max = max(x); y_max = max(y); z_max = max(z);
% 
% defs = [x_min y_min z_min;x_max y_max z_max];
% 
% 
% plot3(0, 0, 0, 'MarkerSize', 11, 'Marker', 'o', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'k');
% % plot all the points
% c = linspace(10,10,length(data));
% scatter3(pointsR(:,1), pointsR(:,2), pointsR(:,3),8,'b', 'filled');
% 
% [P,S] = ransac(points, 25000, 0.027);
%  if length(P)>0
%     for i=1:min(length(P),3)
%         [A,B,C,D] = simplePlanePlot(P(i,:), defs, 'r');
%     end
%  end                    
%RESULT3 = HoughPointsTeste(points);