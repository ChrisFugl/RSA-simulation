function [ f1_err, f2_err, b1_err, b2_err ] = visualize_setup( varargin )
%visualize Simulate RSA and visualize result in scatterplot

% parse arguments
isPositiveInteger = @(x) isnumeric(x) && floor(x) == x && x > 0;

p = inputParser;
addParameter(p, 'filename', 'data/basic-grid.json', @ischar);
addParameter(p, 'variance', 0.000001, @isnumeric);
addParameter(p, 'numberOfImages', 1, isPositiveInteger);
addParameter(p, 'withNoiseLimit', false, @islogical);

parse(p, varargin{:});
filename = p.Results.filename;
numberOfImages = p.Results.numberOfImages;
variance = p.Results.variance;
withNoiseLimit = p.Results.withNoiseLimit;

[ ~, ~, ~, ~, system ] = ...
  simulate(filename, ...
           'variance', variance, ...
           'numberOfImages', numberOfImages, ...
           'withNoiseLimit', withNoiseLimit);

image1 = system.image1;
image2 = system.image2;
control_markers = system.control_markers;
bone_markers = system.bone_markers;
focus_points = system.focus_points;

i1bm = image1.bone_markers;
i1cm = image1.control_markers;
i2bm = image2.bone_markers;
i2cm = image2.control_markers;

h1 = figure();
hold on;
scatter3(control_markers(:,1), control_markers(:,2), control_markers(:,3), 'filled');
scatter3(i1cm(:,1), i1cm(:,2), i1cm(:,3), 'filled');
scatter3(i2cm(:,1), i2cm(:,2), i2cm(:,3), 'filled');
scatter3(i1bm(:,1), i1bm(:,2), i1bm(:,3), 'filled');
scatter3(i2bm(:,1), i2bm(:,2), i2bm(:,3), 'filled');
scatter3(bone_markers(:,1), bone_markers(:,2), bone_markers(:,3), 'filled');
scatter3(focus_points(:,1), focus_points(:,2), focus_points(:,3), 'filled');

end
