function [ f1_avg, f2_avg, b1_avg, b2_avg, var_avg ] = test_images( varargin )

% parse arguments
isPositiveInteger = @(x) isnumeric(x) && floor(x) == x && x > 0;
isNonNegative = @(x) isnumeric(x) && min(x) >= 0;

p = inputParser;
addParameter(p, 'filename', 'data/basic-grid.json', @ischar);
addParameter(p, 'saveDirectories', char('out/least_squares_valstar/'), @ischar);
addParameter(p, 'methods', char('least squares valstar'), @checkMethod);
addParameter(p, 'iterations', 50, isPositiveInteger);
addParameter(p, 'variance', 0.000001, @isnumeric);
addParameter(p, 'values', 1:30, isNonNegative);
addParameter(p, 'withNoiseLimit', false, @islogical);
addParameter(p, 'useSamePoints', false, @islogical);

parse(p, varargin{:});
filename = p.Results.filename;
saveDirectories = p.Results.saveDirectories;
methods = p.Results.methods;
iterations = p.Results.iterations;
variance = p.Results.variance;
images = p.Results.values;
withNoiseLimit = p.Results.withNoiseLimit;
useSamePoints = p.Results.useSamePoints;

xaxis = (1:iterations)';
headers = {'xaxis', 'f1', 'f2', 'b1', 'b2', 'variance'};
itrFilename = ['itr', num2str(iterations)];

n = length(images);
systems = cell(n, iterations);
if useSamePoints
  % setup RSA simulation from file
  [control_markers, bone_markers, focus_points, oImage1, oImage2, h] = ...
    setupRSA(filename);
  parfor i = 1:n
    image = images(i);
    systems{i} = cell(1, iterations);
    for j = 1:iterations
      % generate images with normal distributed noise
      image1 = [];
      image1.control_markers = [];
      image1.bone_markers = [];
      image2 = [];
      image2.control_markers = [];
      image2.bone_markers = [];
      for k = 1:image
        [i1, i2] = addNoise(variance, oImage1, oImage2, withNoiseLimit);
        image1.control_markers = [image1.control_markers ; i1.control_markers];
        image2.control_markers = [image2.control_markers ; i2.control_markers];
      end
      image1.bone_markers = i1.bone_markers;
      image2.bone_markers = i2.bone_markers;

      systems{i}{j}.control_markers = control_markers;
      systems{i}{j}.bone_markers = bone_markers;
      systems{i}{j}.focus_points = focus_points;
      systems{i}{j}.image1 = image1;
      systems{i}{j}.image2 = image2;
      systems{i}{j}.proj_height = h;
    end
  end
end

lastImageNumber = images(n);
n_methods = size(methods, 1);
for i = 1:n_methods
  k = 1;
  method = strtrim(methods(i,:));
  sd = strtrim(saveDirectories(i,:));
  f1_avg = zeros(1,n);
  f2_avg = zeros(1,n);
  b1_avg = zeros(1,n);
  b2_avg = zeros(1,n);
  var_avg = zeros(1,n);
  display([method, ' (images):']);
  for j = images
    numberOfImages = images(k);
    [f1_err, f2_err, b1_err, b2_err, var_err] = ...
      doIterations('filename', filename, ...
                   'method', method, ...
                   'iterations', iterations, ...
                   'variance', variance, ...
                   'numberOfImages', numberOfImages, ...
                   'useSamePoints', useSamePoints, ...
                   'systemToSimulate', systems{k});
    f1_avg(k) = sum(f1_err) / iterations;
    f2_avg(k) = sum(f2_err) / iterations;
    b1_avg(k) = sum(b1_err) / iterations;
    b2_avg(k) = sum(b2_err) / iterations;
    var_avg(k) = sum(var_err) / iterations;
    display(['number of images = ', num2str(numberOfImages), ' out of ', num2str(lastImageNumber)]);

    outputFile = [sd, itrFilename, '_img', num2str(numberOfImages), '.csv'];
    csvwrite_with_headers(outputFile, ...
                          [xaxis, f1_err', f2_err', b1_err', b2_err', var_err'], ...
                          headers);
    k = k + 1;
  end
  
  outFile = 'out/';
  if useSamePoints
    outFile = [outFile, 'sp_'];
  end
  outFile = [outFile, itrFilename, '_images', method2Filename(method), '.csv'];
  outData = [images', f1_avg' , f2_avg' , b1_avg' , b2_avg' , var_avg'];
  csvwrite_with_headers(outFile, outData, headers);
end

end

