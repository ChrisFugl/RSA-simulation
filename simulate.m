function [ f1_err, f2_err, b1_err, b2_err, system ] = simulate(filename, varargin)
%simulate Do simulation of RSA based on setup from file.

% parse arguments
isPositiveInteger = @(x) isnumeric(x) && floor(x) == x && x > 0;

p = inputParser;
addRequired(p, 'filename', @ischar);
addParameter(p, 'method', 'least squares valstar', @checkMethod);
addParameter(p, 'variance', 0.000001, @isnumeric);
addParameter(p, 'numberOfImages', 1, isPositiveInteger);
addParameter(p, 'withNoiseLimit', false, @islogical);
addParameter(p, 'useSamePoints', false, @islogical);
addParameter(p, 'system', [], @(x) true);

parse(p, filename, varargin{:});
filename = p.Results.filename;
method = p.Results.method;
variance = p.Results.variance;
numberOfImages = p.Results.numberOfImages;
withNoiseLimit = p.Results.withNoiseLimit;
useSamePoints = p.Results.useSamePoints;
systemIn = p.Results.system;

if useSamePoints
  control_markers = systemIn.control_markers;
  bone_markers = systemIn.bone_markers;
  focus_points = systemIn.focus_points;
  image1 = systemIn.image1;
  image2 = systemIn.image2;
  h = systemIn.proj_height;
else
  % setup RSA simulation from file
  [control_markers, bone_markers, focus_points, oImage1, oImage2, h] = setupRSA(filename);

  % generate images with normal distributed noise
  image1 = [];
  image1.control_markers = [];
  image1.bone_markers = [];
  image2 = [];
  image2.control_markers = [];
  image2.bone_markers = [];
  for i = 1:numberOfImages
    [i1, i2] = addNoise(variance, oImage1, oImage2, withNoiseLimit);
    image1.control_markers = [image1.control_markers ; i1.control_markers];
    image2.control_markers = [image2.control_markers ; i2.control_markers];
  end
  image1.bone_markers = i1.bone_markers;
  image2.bone_markers = i2.bone_markers;
end

n = size(control_markers, 1);
control_markers = repmat(control_markers, numberOfImages, 1);
b1_est = [image1.bone_markers(1,:) ; image2.bone_markers(1,:)];
b2_est = [image1.bone_markers(2,:) ; image2.bone_markers(2,:)];
% estimate focus points and bone markers
if strcmp(method, 'statistical mixed')
  [F1, F2, stat_variance] = ...
    statistical_mixed(image1.control_markers, image2.control_markers, control_markers, h);
  F = [F1.' ; F2.'];
  n = size(F, 1);
  B1 = least_squares_valstar(F, b1_est);
  B1 = B1(n+1:n+3);
  B2 = least_squares_valstar(F, b2_est);
  B2 = B2(n+1:n+3);
elseif strcmp(method, 'statistical complete')
  [F1, F2, B1, B2, stat_variance] = ...
    statistical_complete(image1, image2, control_markers, h);
  F = [F1.' ; F2.'];
elseif strcmp(method, 'least squares new')
  F1 = least_squares_new(control_markers, image1.control_markers);
  F2 = least_squares_new(control_markers, image2.control_markers);
  F = [F1.' ; F2.'];
  B1 = least_squares_new(F, b1_est);
  B2 = least_squares_new(F, b2_est);
elseif strcmp(method, 'valstar test')
  [F1, F2] = valstar_minimize(image1.control_markers, image2.control_markers, control_markers);
  F = [F1.' ; F2.'];
  [B1, B2] = valstar_minimize(b1_est, b2_est, F);
else
  n = size(control_markers, 1);
  F1 = least_squares_valstar(control_markers, image1.control_markers);
  F1 = F1(n+1:n+3);
  F2 = least_squares_valstar(control_markers, image2.control_markers);
  F2 = F2(n+1:n+3);
  F = [F1.' ; F2.'];
  n = size(F, 1);
  B1 = least_squares_valstar(F, b1_est);
  B1 = B1(n+1:n+3);
  B2 = least_squares_valstar(F, b2_est);
  B2 = B2(n+1:n+3);
end

f1_err = norm(focus_points(1,:).' - F1, 2);
f2_err = norm(focus_points(2,:).' - F2, 2);
b1_err = norm(bone_markers(1,:).' - B1, 2);
b2_err = norm(bone_markers(2,:).' - B2, 2);
B = [B1.' ; B2.'];

system = [];
system.control_markers = control_markers;
system.focus_points = focus_points;
system.bone_markers = bone_markers;
system.image1 = image1;
system.image2 = image2;
system.f_est = F;
system.b_est = B;
if strcmp(method, 'statistical mixed') || strcmp(method, 'statistical complete')
    system.variance = stat_variance;
end

end

