function [ f1_errs, f2_errs, b1_errs, b2_errs, var_errs ] = doIterations( varargin )

% parse arguments
isPositiveInteger = @(x) isnumeric(x) && floor(x) == x && x > 0;
isNonNegative = @(x) isnumeric(x) && min(x) >= 0;

p = inputParser;
addParameter(p, 'filename', 'data/basic-grid.json', @ischar);
addParameter(p, 'method', 'least squares valstar', @checkMethod);
addParameter(p, 'iterations', 50, isPositiveInteger);
addParameter(p, 'variance', 0.000001, isNonNegative);
addParameter(p, 'numberOfImages', 1, isPositiveInteger);
addParameter(p, 'withNoiseLimit', false, @islogical);
addParameter(p, 'useSamePoints', false, @islogical);
addParameter(p, 'systemToSimulate', [], @(x) true);

parse(p, varargin{:});
filename = p.Results.filename;
method = p.Results.method;
iterations = p.Results.iterations;
variance = p.Results.variance;
numberOfImages = p.Results.numberOfImages;
withNoiseLimit = p.Results.withNoiseLimit;
useSamePoints = p.Results.useSamePoints;
systemToSimulate = p.Results.systemToSimulate;

methodIsStatistical = strcmp(method, 'statistical mixed') || strcmp(method, 'statistical complete');

f1_errs = zeros(1,iterations);
f2_errs = zeros(1,iterations);
b1_errs = zeros(1,iterations);
b2_errs = zeros(1,iterations);
var_errs = zeros(1,iterations);
parfor i = 1:iterations
  if useSamePoints
    [ f1_err, f2_err, b1_err, b2_err, system ] = ...
      simulate(filename, ...
               'method', method, ...
               'variance', variance, ...
               'numberOfImages', numberOfImages, ...
               'useSamePoints', useSamePoints, ...
               'system', systemToSimulate{i});
  else
    [ f1_err, f2_err, b1_err, b2_err, system ] = ...
      simulate(filename, ...
               'method', method, ...
               'variance', variance, ...
               'numberOfImages', numberOfImages);
  end
  f1_errs(i) = f1_err;
  f2_errs(i) = f2_err;
  b1_errs(i) = b1_err;
  b2_errs(i) = b2_err;
  if methodIsStatistical
    var_errs(i) = system.variance;
  end
end

end

