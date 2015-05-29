function [ f1_err, f2_err, b1_err, b2_err ] = visualize( varargin )
%visualize Simulate RSA and visualize result in scatterplot

% parse arguments
validMethods = {'least squares valstar', 'least squares new', 'statistical', 'valstar test', 'statistical complete'};
checkMethod = @(x) any(validatestring(x, validMethods));
isPositiveInteger = @(x) isnumeric(x) && floor(x) == x && x > 0;

p = inputParser;
addParameter(p, 'filename', 'data/basic-grid.json', @ischar);
addParameter(p, 'method', 'least squares valstar', checkMethod);
addParameter(p, 'variance', 0.000001, @isnumeric);
addParameter(p, 'numberOfImages', 1, isPositiveInteger);
addParameter(p, 'withNoiseLimit', false, @islogical);

parse(p, varargin{:});
filename = p.Results.filename;
method = p.Results.method;
numberOfImages = p.Results.numberOfImages;
variance = p.Results.variance;
withNoiseLimit = p.Results.withNoiseLimit;

[ f1_err, f2_err, b1_err, b2_err, system ] = ...
  simulate(filename, ...
           'method', method, ...
           'variance', variance, ...
           'numberOfImages', numberOfImages, ...
           'withNoiseLimit', withNoiseLimit);

image1 = system.image1;
image2 = system.image2;
control_markers = system.control_markers;
bone_markers = system.bone_markers;
focus_points = system.focus_points;
f_est = system.f_est;
b_est = system.b_est;

i1bm = image1.bone_markers;
i1cm = image1.control_markers;
i2bm = image2.bone_markers;
i2cm = image2.control_markers;

h1 = figure();
hold on;
scatter3(control_markers(:,1), control_markers(:,2), control_markers(:,3));
scatter3(i1cm(:,1), i1cm(:,2), i1cm(:,3));
scatter3(i2cm(:,1), i2cm(:,2), i2cm(:,3));
scatter3(i1bm(:,1), i1bm(:,2), i1bm(:,3));
scatter3(i2bm(:,1), i2bm(:,2), i2bm(:,3));
scatter3(bone_markers(:,1), bone_markers(:,2), bone_markers(:,3));
scatter3(focus_points(:,1), focus_points(:,2), focus_points(:,3));
scatter3(f_est(:,1),f_est(:,2),f_est(:,3));
scatter3(b_est(:,1),b_est(:,2),b_est(:,3));

disp(['norm(f1 - f1_est) = ', num2str(f1_err)]);
disp(['norm(f2 - f2_est) = ', num2str(f2_err)]);
disp(['norm(b1 - b1_est) = ', num2str(b1_err)]);
disp(['norm(b2 - b2_est) = ', num2str(b2_err)]);

end